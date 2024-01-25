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

#ifndef __cplusplus
#error "This file requires Objective-C++."
#endif  // __cplusplus

#include "mediapipe/framework/packet.h"
#import "mediapipe/tasks/ios/vision/holistic_landmarker/sources/MPPHolisticLandmarkerResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPHolisticLandmarkerResult (Helpers)


/**
 * Creates an `MPPHolisticLandmarkerResult` from landmarks, world landmarks and segmentation mask
 * packets.
 *
 * @param landmarksPacket A MediaPipe packet wrapping a `std::vector<NormalizedlandmarkListProto>`.
 * @param worldLandmarksPacket A MediaPipe packet wrapping a `std::vector<LandmarkListProto>`.
 * @param segmentationMasksPacket a MediaPipe packet wrapping a `std::vector<Image>`.
 *
 * @return  An `MPPHolisticLandmarkerResult` object that contains the hand landmark detection
 * results.
 */
+ (MPPHolisticLandmarkerResult *)
    holisticLandmarkerResultWithFaceLandmarksPacket:(const mediapipe::Packet &)faceLandmarksPacket
                       faceWorldLandmarksPacket:(const mediapipe::Packet &)faceWorldLandmarksPacket
                       faceBlendshapesPacket:(const mediapipe::Packet &)faceBlendShapesPacket
                       poseLandmarksPacket:(const mediapipe::Packet &)poseLandmarksPacket
                       poseWorldLandmarksPacket:(const mediapipe::Packet &)poseWorldLandmarksPacket
                       poseSegmentationMasksPacket:(const mediapipe::Packet *)poseSegmentationMasksPacket
                       leftHandLandmarksPacket:(const mediapipe::Packet &)leftHandLandmarksPacket
                       leftHandWorldLandmarksPacket:(const mediapipe::Packet &)leftHandWorldLandmarksPacket
                       rightHandLandmarksPacket:(const mediapipe::Packet &)rightHandLandmarksPacket
                       rightHandWorldLandmarksPacket:(const mediapipe::Packet &)rightHandWorldLandmarksPacket;


// /**
//  * Creates an `MPPHolisticLandmarkerResult` from landmarks, world landmarks and segmentation mask
//  * images.
//  *
//  * @param landmarksProto A vector of protos of type `std::vector<NormalizedlandmarkListProto>`.
//  * @param worldLandmarksProto A vector of protos of type `std::vector<LandmarkListProto>`.
//  * @param segmentationMasks A vector of type `std::vector<Image>`.
//  * @param timestampInMilliSeconds The timestamp of the Packet that contained the result.
//  *
//  * @return  An `MPPHolisticLandmarkerResult` object that contains the pose landmark detection
//  * results.
//  */
// + (MPPHolisticLandmarkerResult *)
//     holisticLandmarkerResultWithFaceLandmarksProto:(const std::vector<::mediapipe::NormalizedLandmarkList> &)faceLandmarksProto
//                        faceWorldLandmarksPacket:(const std::vector<::mediapipe::LandmarkList> &)faceWorldLandmarksProto
//                        faceBlendshapesPacket:(const mediapipe::Packet &)faceBlendShapesPacket
//                        poseLandmarksPacket:(const mediapipe::Packet &)poseLandmarksPacket
//                        poseWorldLandmarksPacket:(const mediapipe::Packet &)poseWorldLandmarksPacket
//                        poseSegmentationMasksPacket:(const mediapipe::Packet *)poseSegmentationMasksPacket
//                        leftHandLandmarksPacket:(const mediapipe::Packet &)leftHandLandmarksPacket
//                        leftHandWorldLandmarksPacket:(const mediapipe::Packet &)leftHandWorldLandmarksPacket
//                        rightHandLandmarksPacket:(const mediapipe::Packet &)rightHandLandmarksPacket
//                        rightHandWorldLandmarksPacket:(const mediapipe::Packet &)rightHandWorldLandmarksPacket;
// + (MPPPoseLandmarkerResult *)
//     poseLandmarkerResultWithLandmarksProto:
//         (const std::vector<::mediapipe::NormalizedLandmarkList> &)landmarksProto
//                        worldLandmarksProto:
//                            (const std::vector<::mediapipe::LandmarkList> &)worldLandmarksProto
//                          segmentationMasks:
//                              (nullable const std::vector<mediapipe::Image> *)segmentationMasks
                   timestampInMilliseconds:(NSInteger)timestampInMilliseconds;

@end
NS_ASSUME_NONNULL_END
