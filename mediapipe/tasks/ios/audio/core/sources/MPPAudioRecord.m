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

#import <AVFoundation/AVFoundation.h>

#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"
#import "mediapipe/tasks/ios/audio/core/sources/MPPAudioRecord.h"
#import "mediapipe/tasks/ios/audio/core/sources/MPPFloatRingBuffer.h"

static const NSUInteger kMaximumChannelCount = 2;

@implementation MPPAudioRecord {
  AVAudioEngine *_audioEngine;

  /* 
   * Specifying a custom buffer size on AVAUdioEngine while tapping does not take effect. Hence we
   * are storing the returned samples in a ring buffer to acheive the desired buffer size. If the
   * specified buffer size is shorter than the buffer size supported by `AVAudioEngine` only the
   * most recent data of the buffer of size `bufferLength` will be stored by the ring buffer. 
   */
  MPPFloatRingBuffer *_floatRingBuffer;
  dispatch_queue_t _conversionQueue;
  NSError *_globalError;
}

- (nullable instancetype)initWithAudioFormat:(MPPAudioFormat *)audioFormat
                                  bufferLength:(NSUInteger)bufferLength
                                       error:(NSError **)error {
  self = [super init];
  if (self) {
    if (audioFormat.channelCount > kMaximumChannelCount || audioFormat.channelCount == 0) {
      [MPPCommonUtils
        createCustomError:error
                 withCode:MPPTasksErrorCodeInvalidArgumentError
              description:
                  [NSString stringWithFormat:@"The channel count provided does not match the supported channel count. Only channels counts in the range [1 : %d] are supported", kMaximumChannelCount]];
      return nil;
    }

    if (bufferLength % audioFormat.channelCount != 0) {
      [MPPCommonUtils
        createCustomError:error
                 withCode:MPPTasksErrorCodeInvalidArgumentError
              description:
                  [NSString stringWithFormat:@"The buffer length provided (%d) is not a multiple of channel count(%d).", bufferLength, audioFormat.channelCount]];
      return nil;
    }

    [MPPCommonUtils
        createCustomError:_globalError
                 withCode:MPPTasksErrorCodeAudioRecordWaitingForNewMicInputError
              description:
                  [NSString stringWithFormat:@"AudioRecord hasn't started receiving samples from the audio "
                          @"input source. Please wait for the input."]];

    _audioFormat = audioFormat;
    _audioEngine = [[AVAudioEngine alloc] init];
    _bufferLength = bufferLength;

    _floatRingBuffer = [[MPPFloatRingBuffer alloc] initWithLength:_bufferLength];

    // Serial Queue
    _conversionQueue =
        dispatch_queue_create("org.tensorflow.lite.AudioConversionQueue", NULL);  
  }
  return self;
}

+ (AVAudioPCMBuffer *)bufferFromInputBuffer:(AVAudioPCMBuffer *)pcmBuffer
                        usingAudioConverter:(AVAudioConverter *)audioConverter
                                      error:(NSError **)error {
  // Capacity of converted PCM buffer is calculated in order to maintain the same
  // latency as the input pcmBuffer.
  AVAudioFrameCount capacity = ceil(pcmBuffer.frameLength * audioConverter.outputFormat.sampleRate /
                                    audioConverter.inputFormat.sampleRate);
  AVAudioPCMBuffer *outPCMBuffer = [[AVAudioPCMBuffer alloc]
      initWithPCMFormat:audioConverter.outputFormat
          frameCapacity:capacity * (AVAudioFrameCount)audioConverter.outputFormat.channelCount];

  AVAudioConverterInputBlock inputBlock = ^AVAudioBuffer *_Nullable(
      AVAudioPacketCount inNumberOfPackets, AVAudioConverterInputStatus *_Nonnull outStatus) {
    *outStatus = AVAudioConverterInputStatus_HaveData;
    return pcmBuffer;
  };

  NSError *conversionError = nil;
  AVAudioConverterOutputStatus converterStatus = [audioConverter convertToBuffer:outPCMBuffer
                                                                           error:&conversionError
                                                              withInputFromBlock:inputBlock];

  switch (converterStatus) {
    case AVAudioConverterOutputStatus_HaveData: {
      return outPCMBuffer;
    }
    case AVAudioConverterOutputStatus_Error: {
      NSString *errorDescription = conversionError.localizedDescription
                                       ? conversionError.localizedDescription
                                       : @"Some error occured while processing incoming audio "
                                         @"frames.";
      [TFLCommonUtils createCustomError:error
                             withDomain:TFLAudioRecordErrorDomain
                                   code:TFLAudioRecordErrorCodeProcessingError
                            description:errorDescription];
      break;
    }
    case AVAudioConverterOutputStatus_EndOfStream: {
      [TFLCommonUtils createCustomError:error
                             withDomain:TFLAudioRecordErrorDomain
                                   code:TFLAudioRecordErrorCodeProcessingError
                            description:@"Reached end of input audio stream."];
      break;
    }
    case AVAudioConverterOutputStatus_InputRanDry: {
      [TFLCommonUtils createCustomError:error
                             withDomain:TFLAudioRecordErrorDomain
                                   code:TFLAudioRecordErrorCodeProcessingError
                            description:@"Not enough input is available to satisfy the request."];
      break;
    }
  }
  return nil;
}

- (BOOL)loadAudioPCMBuffer:(AVAudioPCMBuffer *)pcmBuffer error:(NSError **)error {
  if (pcmBuffer.frameLength == 0) {
    [TFLCommonUtils createCustomError:error
                           withDomain:TFLAudioRecordErrorDomain
                                 code:TFLAudioRecordErrorCodeInvalidArgumentError
                          description:@"You may have to try with a different "
                                      @"channel count or sample rate"];
  } else if (pcmBuffer.format.commonFormat != AVAudioPCMFormatFloat32) {
    [TFLCommonUtils createCustomError:error
                           withDomain:TFLAudioRecordErrorDomain
                                 code:TFLAudioRecordErrorCodeProcessingError
                          description:@"An error occured while processing mic input."];
  } else {
    // `pcmBuffer` is already converted to an interleaved format since this method is called after
    // -[self bufferFromInputBuffer:usingAudioConverter:error:].
    // If an `AVAudioPCMBuffer` is interleaved, both floatChannelData[0] and floatChannelData[1]
    // point to the same 1d array with both channels in an interleaved format according to:
    // https://developer.apple.com/documentation/avfaudio/avaudiopcmbuffer/1386212-floatchanneldata
    // Hence we can safely access floatChannelData[0] to get the 1D data in interleaved fashion.
    if ([self.floatRingBuffer loadFloatData:pcmBuffer.floatChannelData[0]
                                dataSize:pcmBuffer.frameLength
                                  offset:0
                                    size:pcmBuffer.frameLength
                                   error:error]) {
      return YES;
    }
  }
  return NO;
}

- (void)convertAndLoadBuffer:(AVAudioPCMBuffer *)buffer
         usingAudioConverter:(AVAudioConverter *)audioConverter error:(NSError **)error {
    NSError *conversionError = nil;
    AVAudioPCMBuffer *convertedPCMBuffer = [MPPAudioRecord bufferFromInputBuffer:buffer
                                                         usingAudioConverter:audioConverter
                                                                       error:error];
    if (convertedPCMBuffer) {
      [self loadAudioPCMBuffer:convertedPCMBuffer error:error];
    }

}

- (void)startTappingMicrophoneWithError:(NSError **)error {
  AVAudioNode *inputNode = [_audioEngine inputNode];
  AVAudioFormat *format = [inputNode outputFormatForBus:0];

  AVAudioFormat *recordingFormat =
      [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32
                                       sampleRate:self.audioFormat.sampleRate
                                         channels:(AVAudioChannelCount)self.audioFormat.channelCount
                                      interleaved:YES];

  AVAudioConverter *audioConverter = [[AVAudioConverter alloc] initFromFormat:format
                                                                     toFormat:recordingFormat];

  // Setting buffer size takes no effect on the input node. This class uses a ring buffer internally
  // to ensure the requested buffer size.
  __weak MPPAudioRecord *weakSelf = self;
  [inputNode installTapOnBus:0
                  bufferSize:(AVAudioFrameCount)self.bufferLength
                      format:format
                       block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
                            __strong MPPAudioRecord *strongSelf = self;
                          if (!strongSelf) {
                            return
                          }
                          dispatch_sync(strongSelf.conversionQueue, ^{
                            NSError *convertAndLoadError = nil;
                            [strongSelf convertAndLoadBuffer:buffer usingAudioConverter:audioConverter error:&convertAndLoadError];
                            strongSelf.globalError = nil;
                            strongSelf.globalError = convertAndLoadError;
                          });
                       }];

  [_audioEngine prepare];
  [_audioEngine startAndReturnError:error];
}

- (BOOL)startRecordingWithError:(NSError **)error {
  switch ([AVAudioSession sharedInstance].recordPermission) {
    case AVAudioSessionRecordPermissionDenied: {
      [MPPCommonUtils  createCustomError:error
                 withCode:MPPTasksErrorCodeAudioRecordPermissionDeniedError
              description:
                            description:@"Record permission was denied by the user. "];
      break;
    }
    case AVAudioSessionRecordPermissionUndetermined: {
      [MPPCommonUtils  createCustomError:error
                 withCode:MPPTasksErrorCodeAudioRecordPermissionUndeterminedError
              description:
                            description:@"Record permissions are undertermined. Yo must use AVAudioSession's "
                            @"requestRecordPermission() to request audio record permission from "
                            @"the user. Please read Apple's documentation for further details"
                            @"If record permissions are granted, you can call this "
                            @"method in the completion handler of requestRecordPermission()."];
      break;
    }

    case AVAudioSessionRecordPermissionGranted: {
      [self startTappingMicrophoneWithError:error];
      return YES;
    }
  }

  return NO;
}

- (void)stop {
  [[_audioEngine inputNode] removeTapOnBus:0];
  [_audioEngine stop];
  __weak TFLRingBuffer *weakRingBuffer = _ringBuffer;
  dispatch_sync(self->_conversionQueue, ^{
    [weakRingBuffer clear];
  });
}

- (nullable MPPFloatBuffer *)readAtOffset:(NSUInteger)offset
                                 withLength:(NSUInteger)length
                                    error:(NSError **)error {
  __block MPPFloatBuffer *bufferToReturn = nil;
  __block NSError *readError = nil;

  // Using strong `self` is okay since block is shortlived and it'll release its 
  // strong reference to `self` when it finishes execution.
  dispatch_sync(self.conversionQueue, ^{
      readError = [self.globalError copy];
      bufferToReturn = [self.floatRingBuffer readAtOffset:offset withLength:length error:error]
  });

  if (!bufferToReturn && error) {
    *error = readError;
  }

  return bufferToReturn;
}

@end
