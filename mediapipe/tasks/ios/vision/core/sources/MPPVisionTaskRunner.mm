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

#import "mediapipe/tasks/ios/vision/core/sources/MPPVisionTaskRunner.h"

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"

#include "absl/status/statusor.h"

#include <optional>

namespace {
using ::mediapipe::CalculatorGraphConfig;
using ::mediapipe::NormalizedRect;
using ::mediapipe::tasks::core::PacketMap;
}  // namespace

@interface MPPVisionTaskRunner () {
  MPPRunningMode _runningMode;
}
@end

@implementation MPPVisionTaskRunner

- (nullable instancetype)initWithCalculatorGraphConfig:(mediapipe::CalculatorGraphConfig)graphConfig
                                           runningMode:(MPPRunningMode)runningMode
                                       packetsCallback:
                                           (mediapipe::tasks::core::PacketsCallback)packetsCallback
                                                 error:(NSError **)error {
  switch (runningMode) {
    case MPPRunningModeImage:
    case MPPRunningModeVideo: {
      if (packetsCallback) {
        [MPPCommonUtils createCustomError:error
                                 withCode:MPPTasksErrorCodeInvalidArgumentError
                              description:@"The vision task is in image or video mode, a "
                                          @"user-defined result callback should not be provided."];
        return nil;
      }
      break;
    }
    case MPPRunningModeLiveStream: {
      if (!packetsCallback) {
        [MPPCommonUtils createCustomError:error
                                 withCode:MPPTasksErrorCodeInvalidArgumentError
                              description:@"The vision task is in live stream mode, a user-defined "
                                          @"result callback must be provided."];
        return nil;
      }
      break;
    }
    default: {
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInvalidArgumentError
                            description:@"Unrecognized running mode"];
      return nil;
    }
  }

  _runningMode = runningMode;
  self = [super initWithCalculatorGraphConfig:graphConfig
                              packetsCallback:packetsCallback
                                        error:error];
  return self;
}

- (std::optional<NormalizedRect>)normalizedRectFromRegionOfInterest:(CGRect)roi imageOrientation:(UIImageOrientation)imageOrientation roiAllowed:(BOOL)roiAllowed error:(NSError **)error {

   if (roi != CGRectZero && !roiAllowed) {
      [MPPCommonUtils
        createCustomError:error
                 withCode:MPPTasksErrorCodeInvalidArgumentError
              description:
                  @"This task doesn't support region-of-interest."];
      return std::nullopt;
   }

   CGRect calculatedRoi = (roi != CGRectZero) ? roi : CGRectMake(x:0.0, y:0.0, width:1.0, height:1.0);

   NormalizedRect normalizedRect;
   normalizedRect.set_x_center(CGRectGetMidX(calculatedRoi));
   normalizedRect.set_y_center(CGRectGetMidY(calculatedRoi));
   normalizedRect.set_width(CGRectGetWidth(calculatedRoi));
   normalizedRect.set_height(CGRectGetHeight(calculatedRoi));

   int rotationDegrees = 0;
   switch(imageOrientation) {
    case UIImageOrientationUp:
      break;
    case UIImageOrientationRight: {
      rotationDegrees = -90;
      break;
    }
    case UIImageOrientationDown: {
      rotationDegrees = -180;
      break;
    }
    case UIImageOrientationLeft: {
      rotationDegrees = -270;
      break;
    }
    default:
   }

  normalizedRect.set_rotation(-rotationDegrees * M_PI / 180.0);

  return normalizedRect
}

- (std::optional<PacketMap>)processImagePacketMap:(PacketMap &)packetMap error:(NSError **)error {
    
  if (_runningMode != MPPRunningModeImage) {
    [MPPCommonUtils createCustomError:error
                                 withCode:MPPTasksErrorCodeInvalidArgumentError
                              description:@"The vision task is not initialized with image mode. Current Running Mode:"];
    return std::nullopt;
  }

  return [self processPacketMap:packetMap error:error];
}

- (std::optional<PacketMap>)processVideoFramePacketMap:(PacketMap &)packetMap error:(NSError **)error {
    
  if (_runningMode != MPPRunningModeVideo) {
    [MPPCommonUtils createCustomError:error
                                 withCode:MPPTasksErrorCodeInvalidArgumentError
                              description:@"The vision task is not initialized with image mode. Current Running Mode:"];
    return std::nullopt;
  }

  return [self processPacketMap:packetMap error:error];
}

- (BOOL)processLiveStreamPacketMap:(PacketMap &)packetMap error:(NSError **)error {
    
  if (_runningMode != MPPRunningModeLiveStream) {
    [MPPCommonUtils createCustomError:error
                                 withCode:MPPTasksErrorCodeInvalidArgumentError
                              description:@"The vision task is not initialized with image mode. Current Running Mode:"];
    return NO;
  }

  return [self sendPacketMap:packetMap error:error];
}

// // Convert from ImageProcessingOptions to NormalizedRect, performing sanity
//   // checks on-the-fly. If the input ImageProcessingOptions is not present,
//   // returns a default NormalizedRect covering the whole image with rotation set
//   // to 0. If 'roi_allowed' is false, an error will be returned if the input
//   // ImageProcessingOptions has its 'region_or_interest' field set.
//   static absl::StatusOr<mediapipe::NormalizedRect> ConvertToNormalizedRect(
//       std::optional<ImageProcessingOptions> options, bool roi_allowed = true) {
//     mediapipe::NormalizedRect normalized_rect;
//     normalized_rect.set_rotation(0);
//     normalized_rect.set_x_center(0.5);
//     normalized_rect.set_y_center(0.5);
//     normalized_rect.set_width(1.0);
//     normalized_rect.set_height(1.0);
//     if (!options.has_value()) {
//       return normalized_rect;
//     }

//     if (options->rotation_degrees % 90 != 0) {
//       return CreateStatusWithPayload(
//           absl::StatusCode::kInvalidArgument,
//           "Expected rotation to be a multiple of 90°.",
//           MediaPipeTasksStatus::kImageProcessingInvalidArgumentError);
//     }
//     // Convert to radians counter-clockwise.
//     normalized_rect.set_rotation(-options->rotation_degrees * M_PI / 180.0);

//     if (options->region_of_interest.has_value()) {
//       if (!roi_allowed) {
//         return CreateStatusWithPayload(
//             absl::StatusCode::kInvalidArgument,
//             "This task doesn't support region-of-interest.",
//             MediaPipeTasksStatus::kImageProcessingInvalidArgumentError);
//       }
//       auto& roi = *options->region_of_interest;
//       if (roi.left >= roi.right || roi.top >= roi.bottom) {
//         return CreateStatusWithPayload(
//             absl::StatusCode::kInvalidArgument,
//             "Expected RectF with left < right and top < bottom.",
//             MediaPipeTasksStatus::kImageProcessingInvalidArgumentError);
//       }
//       if (roi.left < 0 || roi.top < 0 || roi.right > 1 || roi.bottom > 1) {
//         return CreateStatusWithPayload(
//             absl::StatusCode::kInvalidArgument,
//             "Expected RectF values to be in [0,1].",
//             MediaPipeTasksStatus::kImageProcessingInvalidArgumentError);
//       }
//       normalized_rect.set_x_center((roi.left + roi.right) / 2.0);
//       normalized_rect.set_y_center((roi.top + roi.bottom) / 2.0);
//       normalized_rect.set_width(roi.right - roi.left);
//       normalized_rect.set_height(roi.bottom - roi.top);
//     }
//     return normalized_rect;
//   }

@end
