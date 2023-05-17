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

#import "mediapipe/tasks/ios/vision/gesture_recognizer/utils/sources/MPPGestureRecognizerOptions+Helpers.h"

#import "mediapipe/tasks/ios/common/utils/sources/NSString+Helpers.h"
#import "mediapipe/tasks/ios/core/utils/sources/MPPBaseOptions+Helpers.h"
#import "mediapipe/tasks/ios/components/processors/utils/sources/MPPClassifierOptions+Helpers.h"

#include "mediapipe/tasks/cc/components/processors/proto/classifier_options.pb.h"
#include "mediapipe/tasks/cc/vision/gesture_recognizer/proto/gesture_recognizer_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/hand_detector/proto/hand_detector_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/hand_landmarker/proto/hand_landmarker_graph_options.pb.h"
#include "mediapipe/tasks/cc/vision/hand_landmarker/proto/hand_landmarks_detector_graph_options.pb.h"

namespace {
using CalculatorOptionsProto = mediapipe::CalculatorOptions;
using GestureRecognizerGraphOptionsProto =
    ::mediapipe::tasks::vision::gesture_recognizer::proto::GestureRecognizerGraphOptions;
using HandLandmarkerGraphOptionsProto =
    ::mediapipe::tasks::vision::hand_landmarker::proto::HandLandmarkerGraphOptions;
using HandDetectorGraphOptionsProto =
    ::mediapipe::tasks::vision::hand_detector::proto::HandDetectorGraphOptions;
using HandLandmarksDetectorGraphOptionsProto =
    ::mediapipe::tasks::vision::hand_landmarker::proto::HandLandmarksDetectorGraphOptions;
using ClassifierOptionsProto = ::mediapipe::tasks::components::processors::proto::ClassifierOptions;
}  // namespace

@implementation MPPGestureRecognizerOptions (Helpers)

- (void)copyToProto:(CalculatorOptionsProto *)optionsProto {
  GestureRecognizerGraphOptionsProto *gestureRecognizerGraphOptionsProto =
      optionsProto->MutableExtension(GestureRecognizerGraphOptionsProto::ext);

  [self.baseOptions copyToProto:gestureRecognizerGraphOptionsProto->mutable_base_options()
              withUseStreamMode:self.runningMode != MPPRunningModeImage];
  

  HandLandmarkerGraphOptionsProto *handLandmarkerGraphOptionsProto = HandLandmarkerGraphOptionsProto();
  handLandmarkerGraphOptionsProto->set_min_tracking_confidence(self.minTrackingConfidence);

  HandDetectorGraphOptionsProto *handDetectorGraphOptionsProto = handLandmarkerGraphOptionsProto()->mutable_hand_detector_graph_options();
  handDetectorGraphOptionsProto->Clear();
  handDetectorGraphOptionsProto->set_num_hands(self.numberOfHands);
  handDetectorGraphOptionsProto->set_min_hand_detection_confidence(self.minHandDetectionConfidence);

  HandLandmarksDetectorGraphOptionsProto *handLandmarksDetectorGraphOptionsProto = handLandmarkerGraphOptionsProto()->mutable_hand_landmarks_detector_graph_options();
  handLandmarksDetectorGraphOptionsProto->Clear();
  handLandmarksDetectorGraphOptionsProto->set_min_hand_presence_confidence(self.minHandPresenceConfidence);

  if (cannedGesturesClassifierOptions) {
    ClassifierOptionsProto *cannedGesturesClassifierOptionsProto = gestureRecognizerGraphOptionsProto->mutable_canned_gestures_classifier_options();
    cannedGesturesClassifierOptions.copyToProto(cannedGesturesClassifierOptionsProto);
  }

  if (customGesturesClassifierOptions) {
    ClassifierOptionsProto *customGesturesClassifierOptionsProto = gestureRecognizerGraphOptionsProto->mutable_canned_gestures_classifier_options();
    cannedGesturesClassifierOptions.copyToProto(customGesturesClassifierOptionsProto);
  }
}

@end
