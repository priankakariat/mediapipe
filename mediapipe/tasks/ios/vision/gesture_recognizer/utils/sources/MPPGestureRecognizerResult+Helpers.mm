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

#import "mediapipe/tasks/ios/components/containers/utils/sources/MPPLandmark+Helpers.h"
#import "mediapipe/tasks/ios/vision/gesture_recognizer/utils/sources/MPPGestureRecognizerResult+Helpers.h"

#include "mediapipe/framework/formats/landmark.pb.h"

static const int kMicroSecondsPerMilliSecond = 1000;

namespace {
using ClassificationListProto =
    ::mediapipe::ClassificationListProto;
using LandmarkListProto =
    ::mediapipe::LandmarkList;
using NormalizedLandmarkListProto =
    ::mediapipe::NormalizedLandmarkList;
using ::mediapipe::Packet;
}  // namespace

@implementation MPPGestureRecognizerResult (Helpers)

+ (MPPGestureRecognizerResult *)gestureRecognizerResultWithHandGesturesPacket:
    (const Packet &)packet handednessPacket:(const Packet &)packet handLandmarksPacket:(const Packet &)packet worldLandmarksPacket:(const Packet &)packet {
  MPPClassificationResult *classificationResult = [MPPClassificationResult
      classificationResultWithProto:packet.Get<ClassificationResultProto>()];

  return [[MPPImageClassifierResult alloc]
      initWithClassificationResult:classificationResult
           timestampInMilliseconds:(NSInteger)(packet.Timestamp().Value() /
                                               kMicroSecondsPerMilliSecond)];
}

@end
