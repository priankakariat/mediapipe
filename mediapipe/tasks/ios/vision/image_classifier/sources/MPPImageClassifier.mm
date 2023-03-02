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

#import "mediapipe/tasks/ios/vision/image_classifier/sources/MPPImageClassifier.h"

#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"
#import "mediapipe/tasks/ios/common/utils/sources/NSString+Helpers.h"
#import "mediapipe/tasks/ios/core/sources/MPPTaskInfo.h"
#import "mediapipe/tasks/ios/core/sources/MPPVisionPacketCreator.h"
#import "mediapipe/tasks/ios/vision/core/sources/MPPVisionTaskRunner.h"
#import "mediapipe/tasks/ios/vision/image_classifier/utils/sources/MPPImageClassifierOptions+Helpers.h"
#import "mediapipe/tasks/ios/vision/image_classifier/utils/sources/MPPImageClassifierResult+Helpers.h"

#include "mediapipe/tasks/cc/components/containers/proto/classifications.pb.h"

namespace {
using ::mediapipe::NormalizedRect;
using ::mediapipe::Packet;
using ::mediapipe::tasks::core::PacketMap;
using ::mediapipe::tasks::vision::core::PacketsCallback;
}  // namespace

static NSString *const kClassificationsStreamName = @"classifications_out";
static NSString *const kClassificationsTag = @"CLASSIFICATIONS";
static NSString *const kImageInStreamName = @"image_in";
static NSString *const kImageOutStreamName = @"image_out";
static NSString *const kImageTag = @"IMAGE";
static NSString *const kNormRectName = @"norm_rect_in";
static NSString *const kNormRectTag = @"NORM_RECT";

static NSString *const kTaskGraphName = @"mediapipe.tasks.vision.image_classifier.ImageClassifierGraph";

@interface MPPImageClassifier () {
  /** iOS Text Task Runner */
  MPPVisionTaskRunner *_visionTaskRunner;
}
@end

@implementation MPPImageClassifier

- (instancetype)initWithOptions:(MPPImageClassifierOptions *)options error:(NSError **)error {
  self = [super init];
  if (self) {
    MPPTaskInfo *taskInfo = [[MPPTaskInfo alloc]
        initWithTaskGraphName:kTaskGraphName
                 inputStreams:@[ [NSString stringWithFormat:@"%@:%@", kTextTag, kTextInStreamName] ]
                outputStreams:@[ [NSString stringWithFormat:@"%@:%@", kClassificationsTag,
                                                            kClassificationsStreamName] ]
                  taskOptions:options
           enableFlowLimiting:NO
                        error:error];

    if (!taskInfo) {
      return nil;
    }

    PacketsCallback packetsCallback = nullptr;

    if (options.completion) {
    auto result_callback = options->result_callback;
    packetsCallback =
        [=](absl::StatusOr<PacketMap> status_or_packets) {
          NSError *callbackError = nil;
          MPPImageClassifierResult *result;
          if ([MPPCommonUtils checkCppError:status_or_packets.status() error:callbackError]) {
            result = [MPPImageClassifierResult
      imageClassifierResultWithClassificationsPacket:status_or_packets.value()
                                                        [kClassificationsStreamName.cppString]];
          }
          options.completion(result, callbackError);
        };
  }
  
  _visionTaskRunner =
        [[MPPVisionTaskRunner alloc] initWithCalculatorGraphConfig:[taskInfo generateGraphConfig]
                                                           runningMode:options.runningMode
                                                           packetsCallback:std::move(packetsCallback)
                                                           error:error];

    if (!_visionTaskRunner) {
      return nil;
    }
  }
  return self;
}

- (instancetype)initWithModelPath:(NSString *)modelPath error:(NSError **)error {
  MPPImageClassifierOptions *options = [[MPPImageClassifierOptions alloc] init];

  options.baseOptions.modelAssetPath = modelPath;

  return [self initWithOptions:options error:error];
}

- (nullable MPPImageClassifierResult *)classifyImage:(MPPImage *)image error:(NSError **)error {
  return [self classifyImage:image roi:CGRectZero error:error];
}

- (nullable MPPImageClassifierResult *)classifyImage:(MPPImage *)image regionOfInterest:(CGRect)roi error:(NSError **)error {
  std::optional<NormalizedRect> rect = [_visionTaskRunner normalizedRectFromRegionOfInterest:roi imageOrientation:image.orientation error:error];
  if (!rect.has_value()) {
    return nil;
  }

  Packet packet = [MPPVisionPacketCreator createWithImage:image error:error];
  if (!packet) {
    return nil;
  }

  PacketMap packetMap = {{kImageInStreamName.cppString, packet}, {kNormRectName, rect.value()}};
  std::optional<PacketMap> outputPacketMap = [_visionTaskRunner processPacketMap:packetMap error:error];
  if (!outputPacketMap.has_value()) {
    return nil;
  }

  return [MPPImageClassifierResult
      imageClassifierResultWithClassificationsPacket:outputPacketMap.value()
                                                        [kClassificationsStreamName.cppString]];
}

- (nullable MPPImageClassifierResult *)classifyImage:(MPPImage *)image error:(NSError **)error {
  return [self classifyImage:image roi:CGRectZero error:error];
}

- (nullable MPPImageClassifierResult *)classifyVideoFrame:(MPPImage *)image timestampMs:(NSInteger)timestampMs regionOfInterest:(CGRect)roi error:(NSError **)error {
  std::optional<NormalizedRect> rect = [_visionTaskRunner normalizedRectFromRegionOfInterest:roi imageOrientation:image.orientation error:error];
  if (!rect.has_value()) {
    return nil;
  }

  Packet imagePacket = [MPPVisionPacketCreator createWithImage:image timestampMs:timestampMs error:error];
  if (!packet) {
    return nil;
  }

  Packet normalizedRectPacket = [MPPVisionPacketCreator createPacketWithNormalizedRect:rect.value() timestampMs:timestampMs];

  PacketMap packetMap = {{kImageInStreamName.cppString, imagePacket}, {kNormRectName.cppString, normalizedRectPacket}};

  std::optional<PacketMap> outputPacketMap = [_visionTaskRunner processVideoFramePacketMap:packetMap error:error];
  if (!outputPacketMap.has_value()) {
    return nil;
  }

  return [MPPImageClassifierResult
      imageClassifierResultWithClassificationsPacket:outputPacketMap.value()
                                                        [kClassificationsStreamName.cppString]];
}

- (nullable MPPImageClassifierResult *)classifyVideoFrame:(MPPImage *)image timestampMs:(NSInteger)timestampMs error:(NSError **)error {
  return [self classifyVideoFrame:image timestampMs:timestampMs roi:CGRectZero error:error];

}

- (BOOL)classifyAsyncImage:(MPPImage *)image timestampMs:(NSInteger)timestampMs regionOfInterest:(CGRect)roi error:(NSError **)error {
  std::optional<NormalizedRect> rect = [_visionTaskRunner normalizedRectFromRegionOfInterest:roi imageOrientation:image.orientation error:error];
  if (!rect.has_value()) {
    return NO;
  }

  Packet imagePacket = [MPPVisionPacketCreator createWithImage:image timestampMs:timestampMs error:error];
  if (!packet) {
    return NO;
  }

  Packet normalizedRectPacket = [MPPVisionPacketCreator createPacketWithNormalizedRect:rect.value() timestampMs:timestampMs];

  PacketMap packetMap = {{kImageInStreamName.cppString, imagePacket}, {kNormRectName.cppString, normalizedRectPacket}};

  return [_visionTaskRunner processLiveStreamPacketMap:packetMap error:error];
}


@end
