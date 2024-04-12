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

#import <Foundation/Foundation.h>

#import "mediapipe/tasks/ios/audio/core/sources/MPPAudioData.h"
#import "mediapipe/tasks/ios/audio/core/sources/MPPFloatBuffer.h"

NS_ASSUME_NONNULL_BEGIN

/** 
 * A wrapper class to record the device's microphone continuously. Currently
 * this class only supports recording upto 2 channels. If the number of channels
 * is 2, then the mono microphone input is duplicated to provide dual channel
 * data.
 */
NS_SWIFT_NAME(AudioRecord)
@interface MPPAudioRecord : NSObject

/** Audio format specifying the number of channels and sample rate supported. */
@property(nonatomic, readonly) MPPAudioDataFormat *audioDataFormat;

/** 
 * Size of the buffer held by `AudioRecord`. It ensures delivery of audio
 * data of length `bufferLength` arrays when you start recording the microphone
 * input.
 */
@property(nonatomic, readonly) NSUInteger bufferLength;

/**
 * Initializes a new `AudioRecord` with the given audio format and buffer length.
 *
 * @param format An audio format of type `AudioFormat`.
 * @param bufferLength Maximum number of elements the internal buffer of
 * `AudioRecord` can hold at any given point of time. The buffer length
 * must be a multiple of `format.channelCount`.
 * @param error An optional error parameter populated if the initialization of `AudioRecord` was
 * not successful.
 *
 * @return An new instance of `AudioRecord` with the given audio format and buffer size. `nil` if
 * there is an error in initializing `AudioRecord`.
 */
- (nullable instancetype)initWithAudioFormat:(MPPAudioDataFormat *)format
                                bufferLength:(NSUInteger)bufferSize
                                       error:(NSError **)error;

/**
 * This function starts recording the audio from the microphone if audio record permissions
 * have been granted by the user.
 *
 * @discussion Before calling this function, you must call
 * `-[AVAudioSession requestRecordPermission:]` or `+[AVAudioSession sharedInstance]` to acquire
 * record permissions. If the user has denied permission or the permissions are
 * undetermined, the return value will be false and an appropriate error is
 * populated in the error pointer. The internal buffer of `AudioRecord` of
 * length bufferSize will always have the most recent audio samples acquired
 * from the microphhone if this function returns successfully.  Use:
 * `-[MPPAudioRecord readAtOffset:withSize:error:]` to get the data from the
 * buffer at any instance, if audio recording has started successfully.
 *
 * Use `-[MPPAudioRecord stop]` to stop the audio recording.
 *
 * @param error An optional error parameter populated when the microphone input
 * could not be recorded successfully.
 *
 * @return Boolean value indicating if audio recording started successfully.
 */
- (BOOL)startRecordingWithError:(NSError **)error NS_SWIFT_NAME(startRecording());

/**
 * Stops recording audio from the microphone. All elements in the internal
 * buffer of `AudioRecord` will also be set to zero.
 */
- (void)stop;

/**
 * Returns the `length` number of elements in the internal buffer of
 * `AudioRecord` starting at `offset`, i.e, `buffer[offset:offset+length]`.
 *
 * @param offset Index in the buffer from which elements are to be read.
 * @param length Number of elements to be returned.
 * @param error An optional error parameter populated if the internal buffer could not be read
 * successfully.
 *
 * @return A `FloatBuffer` containing the elements of the internal buffer of `AudioRecord` in
 * the range, `buffer[offset:offset+size]`. Returns `nil` if there is an error in reading the
 * internal buffer.
 */
- (nullable MPPFloatBuffer *)readAtOffset:(NSUInteger)offset
                                 withLEngth:(NSUInteger)length
                                    error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
