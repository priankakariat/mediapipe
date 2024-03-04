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

/// Errors thrown by MediaPipe GenAI Tasks.
public enum GenAiInferenceError: Error {
  case invalidResponse
  case illegalMethodCall
  case modelNotFound
}

extension GenAiInferenceError: LocalizedError {
  /// A localized description of the `GenAiInferenceError`.
  public var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "The response returned by the model is invalid."
    case .illegalMethodCall:
      return
        "You cannot invoke `generateResponse` while another response generation invocation is in progress."
    case .modelNotFound:
      return "No file found at the `modelPath` you provided."
    }
  }
}

/// Protocol conformance for compatibilty with `NSError`.
extension GenAiInferenceError: CustomNSError {
  static public var errorDomain: String {
    return "com.google.mediapipe.tasks.genai.inference"
  }

  public var errorCode: Int {
    switch self {
    case .invalidResponse:
      return 0
    case .illegalMethodCall:
      return 1
    case .modelNotFound:
      return 2
    }
  }
}
