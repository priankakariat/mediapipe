// Copyright 2023 The MediaPipe Authors.
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
#import <UIKit/UIKit.h>

#import "mediapipe/tasks/ios/core/sources/MPPTaskRunner.h"
#import "mediapipe/tasks/ios/vision/core/sources/MPPRunningMode.h"

#include "mediapipe/framework/formats/rect.pb.h"

NSString *const kImageInStreamName = @"image_in";
NSString *const kImageTag = @"IMAGE";
NSString *const kNormRectStreamName = @"norm_rect_in";
static NSString *const kNormRectTag = @"NORM_RECT";

NS_ASSUME_NONNULL_BEGIN

/**
 * This class is used to create and call appropriate methods on the C++ Task Runner to initialize,
 * execute and terminate any MediaPipe vision task.
 */
@interface MPPVisionTaskRunner : MPPTaskRunner

/**
 * Initializes a new `MPPVisionTaskRunner` with the MediaPipe calculator config proto running mode
 * and packetsCallback.
 * Make sure that the packets callback is set properly based on the vision task's running mode.
 * In case of live stream running mode, a C++ packets callback that is intended to deliver inference
 * results must be provided. In case of image or video running mode, packets callback must be set to
 * nil.
 *
 * @param graphConfig A MediaPipe calculator config proto.
 * @param runningMode MediaPipe vision task running mode.
 * @param packetsCallback An optional C++ callback function that takes a list of output packets as
 * the input argument. If provided, the callback must in turn call the block provided by the user in
 * the appropriate task options. Make sure that the packets callback is set properly based on the
 * vision task's running mode. In case of live stream running mode, a C++ packets callback that is
 * intended to deliver inference results must be provided. In case of image or video running mode,
 * packets callback must be set to nil.
 *
 * @param error Pointer to the memory location where errors if any should be saved. If @c NULL, no
 * error will be saved.
 *
 * @return An instance of `MPPVisionTaskRunner` initialized to the given MediaPipe calculator config
 * proto, running mode and packets callback.
 */
- (nullable instancetype)initWithTaskInfo:(MPPTaskInfo *)taskInfo
                                          runningMode:(MPPRunningMode)runningMode
                                          roiAllowed:(BOOL)roiAllowed
                                       packetsCallback:(PacketsCallback)packetsCallback
                                          error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/**
 * A synchronous method to invoke the C++ task runner to process single image inputs. The call
 * blocks the current thread until a failure status or a successful result is returned.
 *
 * @param packetMap A `PacketMap` containing pairs of input stream name and data packet.
 * @param error Pointer to the memory location where errors if any should be
 * saved. If @c NULL, no error will be saved.
 *
 * @return An optional `PacketMap` containing pairs of output stream name and data packet.
 */
- (std::optional<mediapipe::tasks::core::PacketMap>)
    processImage:(MPPImage *)image
                    error:(NSError **)error;     


- (std::optional<mediapipe::tasks::core::PacketMap>)
    processImage:(MPPImage *)image
    regionOfInterest:(CGRect)regionOfInterest
                    error:(NSError **)error;                                       

/**
 * A synchronous method to invoke the C++ task runner to process continuous video frames. The call
 * blocks the current thread until a failure status or a successful result is returned.
 *
 * @param packetMap A `PacketMap` containing pairs of input stream name and data packet.
 * @param error Pointer to the memory location where errors if any should be saved. If @c NULL, no
 * error will be saved.
 *
 * @return An optional `PacketMap` containing pairs of output stream name and data packet.
 */
- (std::optional<PacketMap>)processVideoFrame:(MPPImage *)videoFrame
                                   timestampInMilliSeconds:(NSInteger)timeStampInMilliseconds
                                   error:(NSError **)error;   

 
- (std::optional<PacketMap>)processVideoFrame:(MPPImage *)videoFrame
                                   timestampInMilliSeconds:(NSInteger)timeStampInMilliseconds
                                   regionOfInterest:(CGRect)regionOfInterest
                                   error:(NSError **)error;                                                        

/**
 * An asynchronous method to send live stream data to the C++ task runner. The call blocks the
 * current thread until a failure status or a successful result is returned. The results will be
 * available in the user-defined `packetsCallback` that was provided during initialization of the
 * `MPPVisionTaskRunner`.
 *
 * @param packetMap A `PacketMap` containing pairs of input stream name and data packet.
 * @param error Pointer to the memory location where errors if any should be saved. If @c NULL, no
 * error will be saved.
 *
 * @return A `BOOL` indicating if the live stream data was sent to the C++ task runner successfully.
 * Please note that any errors during processing of the live stream packet map will only be
 * available in the user-defined `packetsCallback` that was provided during initialization of the
 * `MPPVisionTaskRunner`.
 */
- (BOOL)processLiveStreamImage:(MPPImage *)image
                                   timestampInMilliSeconds:(NSInteger)timeStampInMilliseconds
                                   error:(NSError **)error;

- (BOOL)processLiveStreamImage:(MPPImage *)image
                                   timestampInMilliSeconds:(NSInteger)timeStampInMilliseconds
                                   regionOfInterest:(CGRect)regionOfInterest
                                   error:(NSError **)error;

/**
 * This method returns a unique dispatch queue name by adding the given suffix and a `UUID` to the
 * pre-defined queue name prefix for vision tasks. The vision tasks can use this method to get
 * unique dispatch queue names which are consistent with other vision tasks.
 * Dispatch queue names need not be unique, but for easy debugging we ensure that the queue names
 * are unique.
 *
 * @param suffix A suffix that identifies a dispatch queue's functionality.
 *
 * @return A unique dispatch queue name by adding the given suffix and a `UUID` to the pre-defined
 * queue name prefix for vision tasks.
 */
+ (const char *)uniqueDispatchQueueNameWithSuffix:(NSString *)suffix;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
