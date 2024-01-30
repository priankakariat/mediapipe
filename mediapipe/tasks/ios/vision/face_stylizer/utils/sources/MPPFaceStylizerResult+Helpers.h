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

#import "mediapipe/tasks/ios/vision/face_stylizer/sources/MPPFaceStylizerResult.h"

#include "mediapipe/framework/formats/classification.pb.h"
#include "mediapipe/framework/formats/landmark.pb.h"
#include "mediapipe/framework/packet.h"

NS_ASSUME_NONNULL_BEGIN

static const int kMicrosecondsPerMillisecond = 1000;

@interface MPPFaceStylizerResult (Helpers)

/**
 * Creates an `MPPFaceStylizerResult` from the given stylized image packet.
 *
 * @param stylizedImagePacket A MediaPipe packet wrapping a `mediapipe::Image`.
 * @param error Pointer to the memory location where errors if any should be saved. If @c NULL, no error will be saved.
 *
 * @return  An `MPPFaceStylizerResult` object from the given stylized image packet.
 */
+ (MPPFaceStylizerResult *)
    faceStylizerResultWithStylizedImagePacket:(const mediapipe::Packet &)stylizedImagePacket error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
