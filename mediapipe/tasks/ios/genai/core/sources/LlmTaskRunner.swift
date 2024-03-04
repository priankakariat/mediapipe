// Copyright 2024 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import MediaPipeTasksGenAIC

/// This class is used to create and call appropriate methods on the C `LlmInferenceEngine_Session`
/// to initialize, execute and terminate any MediaPipe `LlmInference` task.
public final class LlmTaskRunner {

  private static let cacheSuffix = ".cache"
  private static let cacheDirectoryPrefix = "mediaPipe.genai.cache"

  typealias CLlmSession = UnsafeMutableRawPointer

  private let cLlmSession: CLlmSession

  private let modelCacheFile: URL
  /// Creates a new instance of `LlmTaskRunner` with the given session config.
  ///
  /// - Parameters:
  ///   - sessionConfig: C session config of type `LlmSessionConfig`.
  init(config: Config) throws {
    /// No safe guards for session creation since the C APIs only throw fatal errors.
    /// `LlmInferenceEngine_CreateSession()` will always return a llm session if the call
    /// completes. 

    guard FileManager.default.fileExists(atPath: config.modelPath),
      let modelName = config.modelPath.components(separatedBy: "/").last
    else {
      throw GenAiInferenceError.modelNotFound
    }

    /// Adding a `UUID` prefix to the cache path to prevent the app from crashing if a model cache
    /// is already found in the temporary directory.
    /// Cache will be deleted when the task runner is de-allocated. Preferring deletion on
    /// de-allocation to deleting all caches on initialization to prevent model caches of
    /// other task runners from being de-allocated prematurely during their life time.
    ///
    /// Note: Implementation will have to be updated if C++ core changes the cache prefix.
    // let modelCacheDirectory = config.cacheDirectory.versionIndependentAppending(component:LlmTaskRunner.cacheDirectoryPrefix).versionIndependentAppending(component: "\(UUID().uuidString)")
      
    cLlmSession = config.cacheDirectory.path.withCString { cCacheDir in
        return config.modelPath.withCString { cModelPath in
          let cSessionConfig = LlmSessionConfig(
        model_path: cModelPath,
        cache_dir: cCacheDir,
        sequence_batch_size: config.sequenceBatchSize,
        num_decode_steps_per_sync: config.numberOfDecodeStepsPerSync,
        max_tokens: config.maxTokens,
        topk: config.topk,
        temperature: config.temperature,
        random_seed: config.randomSeed)
        return withUnsafePointer(to: cSessionConfig) { LlmInferenceEngine_CreateSession($0) }
      }
    }

    // self.cLlmSession = withUnsafePointer(to: cSessionConfig) { LlmInferenceEngine_CreateSession($0) }

    modelCacheFile = config.cacheDirectory.versionIndependentAppending(component: "\(modelName)\(LlmTaskRunner.cacheSuffix)")
    print(modelCacheFile.path)
  }

  /// Invokes the C inference engine with the given input text to generate an array of `String`
  /// responses from the LLM.
  ///
  /// - Parameters:
  ///   - inputText: A `String` that is used to query the LLM.
  /// - Throws: An error if the LLM's response is invalid.
  public func predict(inputText: String) throws -> [String] {
    /// No safe guards for the call since the C++ APIs only throw fatal errors.
    /// `LlmInferenceEngine_Session_PredictSync()` will always return a `LlmResponseContext` if the
    /// call completes.
    var responseContext = inputText.withCString { cinputText in
      LlmInferenceEngine_Session_PredictSync(cLlmSession, cinputText)
    }

    defer {
      withUnsafeMutablePointer(to: &responseContext) {
        LlmInferenceEngine_CloseResponseContext($0)
      }
    }

    /// Throw an error if response is invalid `NULL`.
    guard let responseStrings = LlmTaskRunner.responseStrings(from: responseContext) else {
      throw GenAiInferenceError.invalidResponse
    }

    return responseStrings
  }

  public func predict(
    inputText: String, progress: @escaping (_ partialResult: [String]?, _ error: Error?) -> Void,
    completion: @escaping (() -> Void)
  ) {

    /// `strdup(inputText)` prevents input text from being deallocated as long as callbacks are
    /// being invoked. `CallbackInfo` takes care of freeing the memory of `inputText` when it is
    /// deallocated.
    let callbackInfo = CallbackInfo(
      inputText: strdup(inputText), progress: progress, completion: completion)
    let callbackContext = UnsafeMutableRawPointer(Unmanaged.passRetained(callbackInfo).toOpaque())

    LlmInferenceEngine_Session_PredictAsync(cLlmSession, callbackContext, callbackInfo.inputText) {
      context, responseContext in
      guard let cContext = context else {
        return
      }

      /// `takeRetainedValue()` decrements the reference count incremented by `passRetained()`. Only
      /// take a retained value if the LLM has finished generating responses to prevent the context
      /// from being deallocated in between response generation.
      let cCallbackInfo =
        responseContext.done
        ? Unmanaged<CallbackInfo>.fromOpaque(cContext).takeRetainedValue()
        : Unmanaged<CallbackInfo>.fromOpaque(cContext).takeUnretainedValue()

      if let responseStrings = LlmTaskRunner.responseStrings(from: responseContext) {
        cCallbackInfo.progress(responseStrings, nil)
      } else {
        cCallbackInfo.progress(nil, GenAiInferenceError.invalidResponse)
      }

      /// Call completion callback if LLM has generated its last response.
      if responseContext.done {
        cCallbackInfo.completion()
      }
    }
  }

  /// Options for setting up a `LlmInference`.
  ///
  /// Note: Inherits from `NSObject` for Objective C interoperability.
  struct Config {
    /// The absolute path to the model asset bundle stored locally on the device.
    let modelPath: String

    let cacheDirectory: URL

    let sequenceBatchSize: Int

    let numberOfDecodeStepsPerSync: Int

    /// The total length of the kv-cache. In other words, this is the total number of input + output
    /// tokens the model needs to handle.
    let maxTokens: Int

    /// The top K number of tokens to be sampled from for each decoding step. A value of 1 means
    /// greedy decoding. Defaults to 40.
    let topk: Int

    /// The randomness when decoding the next token. A value of 0.0f means greedy decoding. Defaults
    /// to 0.8.
    let temperature: Float

    /// The random seed for sampling tokens.
    let randomSeed: Int


    /// Creates a new instance of `Options` with the modelPath and default values of
    /// `maxTokens`, `topK``, `temperature` and `randomSeed`.
    /// This function is only intended to be used from Objective C.
    ///
    /// - Parameters:
    ///   - modelPath: The absolute path to a model asset bundle stored locally on the device.
    init(modelPath: String, cacheDirectory: URL, sequenceBatchSize: Int, numberOfDecodeStepsPerSync: Int,  maxTokens: Int = 512, topk: Int = 40, temperature: Float = 0.8, randomSeed: Int = 0) {
      self.modelPath = modelPath
      self.cacheDirectory = cacheDirectory
      self.sequenceBatchSize = sequenceBatchSize
      self.numberOfDecodeStepsPerSync = numberOfDecodeStepsPerSync
      self.maxTokens = maxTokens
      self.topk = topk
      self.temperature = temperature
      self.randomSeed = randomSeed
    }

      // // let modelPath = strdup(options.modelPath)
      // // let cacheDirectory = strdup(FileManager.default.temporaryDirectory.path)

      // // defer {
      // //   free(modelPath)
      // //   free(cacheDirectory)
      // // }

      // let sessionConfig = LlmSessionConfig(
      //   model_path: modelPath,
      //   cache_dir: cacheDirectoryPath,
      //   sequence_batch_size: LlmInference.sequenceBatchSize,
      //   num_decode_steps_per_sync: LlmInference.numberOfDecodeStepsPerSync,
      //   max_tokens: options.maxTokens,
      //   topk: options.topk,
      //   temperature: options.temperature,
      //   random_seed: options.randomSeed)
      // }
  }

  deinit {
    LlmInferenceEngine_Session_Delete(cLlmSession)

    // Responsibly deleting the model cache.
    // Performing on current thread since only one file needs to be deleted.
    // Note: `deinit` does not get invoked  If a crash occurs before the task runner is de-allocated or if the task runner is , we let the OS handle the
    // deletion of the cache when it sees fit.
    do {
      print("Enter removeItem")
      try FileManager.default.removeItem(at: modelCacheFile)
    } catch {
      print("Failed")
      print(error.localizedDescription)
      // Could not delete file. Common cause: file not found.
    }
  }
}

extension LlmTaskRunner {
  /// A wrapper class for whose object will be used as the C++ callback context.
  /// The progress and completion callbacks cannot be invoked without a context.
  class CallbackInfo {
    typealias ProgressCallback = (_ partialResult: [String]?, _ error: Error?) -> Void
    typealias CompletionCallback = () -> Void

    let inputText: UnsafeMutablePointer<CChar>?
    let progress: ProgressCallback
    let completion: CompletionCallback

    init(
      inputText: UnsafeMutablePointer<CChar>?, progress: @escaping (ProgressCallback),
      completion: @escaping (CompletionCallback)
    ) {
      self.inputText = inputText
      self.progress = progress
      self.completion = completion
    }

    deinit {
      free(inputText)
    }
  }
}

extension LlmTaskRunner {
  private class func responseStrings(from responseContext: LlmResponseContext) -> [String]? {
    guard let cResponseArray = responseContext.response_array else {
      return nil
    }

    var responseStrings: [String] = []
    for responseIndex in 0..<Int(responseContext.response_count) {
      /// Throw an error if the response string is `NULL`.
      guard let cResponseString = cResponseArray[responseIndex] else {
        return nil
      }
      responseStrings.append(String(cString: cResponseString))
    }

    return responseStrings
  }
}

extension URL {
  func versionIndependentAppending(component: String) -> URL {
      if  #available(iOS 16, *) {
        return self.appending(component: component)
      }
      else {
        return self.appendingPathComponent(component)
      }
  }
}
