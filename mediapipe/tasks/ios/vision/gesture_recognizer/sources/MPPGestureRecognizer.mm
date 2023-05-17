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

#import "mediapipe/tasks/ios/vision/gesture_recognizer/sources/MPPGestureRecognizer.h"

#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"
#import "mediapipe/tasks/ios/common/utils/sources/NSString+Helpers.h"
#import "mediapipe/tasks/ios/core/sources/MPPTaskInfo.h"
#import "mediapipe/tasks/ios/vision/core/sources/MPPVisionPacketCreator.h"
#import "mediapipe/tasks/ios/vision/core/sources/MPPVisionTaskRunner.h"
#import "mediapipe/tasks/ios/vision/gesture_recognizer/utils/sources/MPPGestureRecognizerOptions+Helpers.h"
#import "mediapipe/tasks/ios/vision/gesture_recognizer/utils/sources/MPPGestureRecognizerResult+Helpers.h"

namespace {
using ::mediapipe::NormalizedRect;
using ::mediapipe::Packet;
using ::mediapipe::Timestamp;
using ::mediapipe::tasks::core::PacketMap;
using ::mediapipe::tasks::core::PacketsCallback;
}  // namespace

static NSString *const kImageTag = @"IMAGE";
static NSString *const kImageInStreamName = @"image_in";
static NSString *const kNormRectTag = @"NORM_RECT";
static NSString *const kNormRectInStreamName = @"norm_rect_in";
static NSString *const kImageOutStreamName = @"image_out";
static NSString *const kLandmarksTag = @"LANDMARKS";
static NSString *const kLandmarksOutStreamName = @"hand_landmarks";
static NSString *const kWorldLandmarksTag = @"WORLD_LANDMARKS";
static NSString *const kWorldLandmarksOutStreamName = @"world_hand_landmarks";
static NSString *const kHandednessTag = @"HANDEDNESS";
static NSString *const kHandednessOutStreamName = @"handedness";
static NSString *const kHandGesturesTag = @"HAND_GESTURES";
static NSString *const kHandGesturesOutStreamName = @"hand_gestures";
static NSString *const kTaskGraphName =
    @"mediapipe.tasks.vision.gesture_recognizer.GestureRecognizerGraph";
static NSString *const kTaskName = @"gestureRecognizer";

#define InputPacketMap(imagePacket, normalizedRectPacket) \
  {                                                       \
    {kImageInStreamName.cppString, imagePacket}, {        \
      kNormRectInStreamName.cppString, normalizedRectPacket \
    }                                                     \
  }

@interface MPPGestureRecognizer () {
  /** iOS Vision Task Runner */
  MPPVisionTaskRunner *_visionTaskRunner;
}
@property(nonatomic, weak) id<MPPGestureRecognizerLiveStreamDelegate>
      gestureRecognizerLiveStreamDelegate;
@end

@implementation MPPGestureRecognizer

- (nullable MPPGestureRecognizerResult *)gestureRecognizerResultWithOutputPacketMap:
    (PacketMap &)outputPacketMap {
  return [MPPGestureRecognizerResult
      gestureRecognizerResultWithHandGesturesPacket:outputPacketMap
                                                        [kHandGesturesOutStreamName.cppString]
                                   handednessPacket:outputPacketMap
                                                [kHandednessOutStreamName.cppString]
                                handLandmarksPacket:outputPacketMap
                                                        [kLandmarksOutStreamName.cppString]
                               worldLandmarksPacket:outputPacketMap
                                                        [kWorldLandmarksOutStreamName.cppString]];
}

- (instancetype)initWithOptions:(MPPGestureRecognizerOptions *)options error:(NSError **)error {
  self = [super init];
  if (self) {
    MPPTaskInfo *taskInfo = [[MPPTaskInfo alloc]
        initWithTaskGraphName:kTaskGraphName
                 inputStreams:@[
                   [NSString stringWithFormat:@"%@:%@", kImageTag, kImageInStreamName],
                   [NSString stringWithFormat:@"%@:%@", kNormRectTag, kNormRectInStreamName]
                 ]
                outputStreams:@[
                  [NSString stringWithFormat:@"%@:%@", kLandmarksTag, kLandmarksOutStreamName],
                  [NSString
                      stringWithFormat:@"%@:%@", kWorldLandmarksTag, kWorldLandmarksOutStreamName],
                  [NSString stringWithFormat:@"%@:%@", kHandednessTag, kHandednessOutStreamName],
                  [NSString stringWithFormat:@"%@:%@", kHandGesturesTag, kHandGesturesOutStreamName],
                  [NSString stringWithFormat:@"%@:%@", kImageTag, kImageOutStreamName]
                ]
                  taskOptions:options
           enableFlowLimiting:options.runningMode == MPPRunningModeLiveStream
                        error:error];

    if (!taskInfo) {
      return nil;
    }

    PacketsCallback packetsCallback = nullptr;

    if (options.gestureRecognizerLiveStreamDelegate) {
      _gestureRecognizerLiveStreamDelegate = options.gestureRecognizerLiveStreamDelegate;
      // Capturing `self` as weak in order to avoid `self` being kept in memory
      // and cause a retain cycle, after self is set to `nil`.
      MPPGestureRecognizer *__weak weakSelf = self;

      // Create a private serial dispatch queue in which the deleagte method will be called
      // asynchronously. This is to ensure that if the client performs a long running operation in
      // the delegate method, the queue on which the C++ callbacks is invoked is not blocked and is
      // freed up to continue with its operations.
      const char *queueName = [MPPVisionTaskRunner uniqueDispatchQueueNameWithSuffix:kTaskName];
      dispatch_queue_t callbackQueue = dispatch_queue_create(queueName, NULL);
      packetsCallback = [=](absl::StatusOr<PacketMap> status_or_packets) {
        if (!weakSelf) {
          return;
        }
        if (![weakSelf.gestureRecognizerLiveStreamDelegate
                respondsToSelector:@selector
                (gestureRecognizer:
                    didFinishRecognitionWithResult:timestampInMilliseconds:error:)]) {
          return;
        }

        NSError *callbackError = nil;
        if (![MPPCommonUtils checkCppError:status_or_packets.status() toError:&callbackError]) {
          dispatch_async(callbackQueue, ^{
            [weakSelf.gestureRecognizerLiveStreamDelegate
                             gestureRecognizer:weakSelf
                didFinishRecognitionWithResult:nil
                       timestampInMilliseconds:Timestamp::Unset().Value()
                                         error:callbackError];
          });
          return;
        }

        PacketMap &outputPacketMap = status_or_packets.value();
        if (outputPacketMap[kImageOutStreamName.cppString].IsEmpty()) {
          return;
        }

        MPPGestureRecognizerResult *result =
            [weakSelf gestureRecognizerResultWithOutputPacketMap:outputPacketMap];

        NSInteger timeStampInMilliseconds =
            outputPacketMap[kImageOutStreamName.cppString].Timestamp().Value() /
            kMicroSecondsPerMilliSecond;
        dispatch_async(callbackQueue, ^{
          [weakSelf.gestureRecognizerLiveStreamDelegate gestureRecognizer:weakSelf
                                           didFinishRecognitionWithResult:result
                                                  timestampInMilliseconds:timeStampInMilliseconds
                                                                    error:callbackError];
        });
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
  MPPGestureRecognizerOptions *options = [[MPPGestureRecognizerOptions alloc] init];

  options.baseOptions.modelAssetPath = modelPath;

  return [self initWithOptions:options error:error];
}

- (nullable MPPGestureRecognizerResult *)gestureRecognizerResultWithOptionalOutputPacketMap:
    (std::optional<PacketMap> &)outputPacketMap {
  if (!outputPacketMap.has_value()) {
    return nil;
  }

  return [self gestureRecognizerResultWithOutputPacketMap:outputPacketMap.value()];
}

- (nullable MPPGestureRecognizerResult *)recognizeImage:(MPPImage *)image
                                       regionOfInterest:(CGRect)roi
                                                  error:(NSError **)error {
  std::optional<NormalizedRect> rect =
      [_visionTaskRunner normalizedRectFromRegionOfInterest:roi
                                                  imageSize:CGSizeMake(image.width, image.height)
                                           imageOrientation:image.orientation
                                                 ROIAllowed:YES
                                                      error:error];
  if (!rect.has_value()) {
    return nil;
  }

  Packet imagePacket = [MPPVisionPacketCreator createPacketWithMPPImage:image error:error];
  if (imagePacket.IsEmpty()) {
    return nil;
  }

  Packet normalizedRectPacket =
      [MPPVisionPacketCreator createPacketWithNormalizedRect:rect.value()];

  PacketMap inputPacketMap = InputPacketMap(imagePacket, normalizedRectPacket);

  std::optional<PacketMap> outputPacketMap = [_visionTaskRunner processImagePacketMap:inputPacketMap
                                                                                error:error];
  [self gestureRecognizerResultWithOptionalOutputPacketMap:outputPacketMap];
}

- (std::optional<PacketMap>)inputPacketMapWithMPPImage:(MPPImage *)image
                               timestampInMilliseconds:(NSInteger)timestampInMilliseconds
                                      regionOfInterest:(CGRect)roi
                                                 error:(NSError **)error {
  std::optional<NormalizedRect> rect =
      [_visionTaskRunner normalizedRectFromRegionOfInterest:roi
                                                  imageSize:CGSizeMake(image.width, image.height)
                                           imageOrientation:image.orientation
                                                 ROIAllowed:YES
                                                      error:error];
  if (!rect.has_value()) {
    return std::nullopt;
  }

  Packet imagePacket = [MPPVisionPacketCreator createPacketWithMPPImage:image
                                                timestampInMilliseconds:timestampInMilliseconds
                                                                  error:error];
  if (imagePacket.IsEmpty()) {
    return std::nullopt;
  }

  Packet normalizedRectPacket =
      [MPPVisionPacketCreator createPacketWithNormalizedRect:rect.value()
                                     timestampInMilliseconds:timestampInMilliseconds];

  PacketMap inputPacketMap = InputPacketMap(imagePacket, normalizedRectPacket);
  return inputPacketMap;
}

- (nullable MPPGestureRecognizerResult *)recognizeImage:(MPPImage *)image error:(NSError **)error {
  return [self recognizeImage:image regionOfInterest:CGRectZero error:error];
}

- (nullable MPPGestureRecognizerResult *)recognizeVideoFrame:(MPPImage *)image
                                   timestampInMilliseconds:(NSInteger)timestampInMilliseconds
                                          regionOfInterest:(CGRect)roi
                                                     error:(NSError **)error {
  std::optional<PacketMap> inputPacketMap = [self inputPacketMapWithMPPImage:image
                                                     timestampInMilliseconds:timestampInMilliseconds
                                                            regionOfInterest:roi
                                                                       error:error];
  if (!inputPacketMap.has_value()) {
    return nil;
  }

  std::optional<PacketMap> outputPacketMap =
      [_visionTaskRunner processVideoFramePacketMap:inputPacketMap.value() error:error];

  [self gestureRecognizerResultWithOptionalOutputPacketMap:outputPacketMap];
}

- (nullable MPPGestureRecognizerResult *)classifyVideoFrame:(MPPImage *)image
                                    timestampInMilliseconds:(NSInteger)timestampInMilliseconds
                                                      error:(NSError **)error {
  return [self recognizeVideoFrame:image
           timestampInMilliseconds:timestampInMilliseconds
                  regionOfInterest:CGRectZero
                             error:error];
}

- (BOOL)recognizeAsyncImage:(MPPImage *)image
    timestampInMilliseconds:(NSInteger)timestampInMilliseconds
           regionOfInterest:(CGRect)roi
                      error:(NSError **)error {
  std::optional<PacketMap> inputPacketMap = [self inputPacketMapWithMPPImage:image
                                                     timestampInMilliseconds:timestampInMilliseconds
                                                            regionOfInterest:roi
                                                                       error:error];
  if (!inputPacketMap.has_value()) {
    return NO;
  }

  return [_visionTaskRunner processLiveStreamPacketMap:inputPacketMap.value() error:error];
}

- (BOOL)recognizeAsyncImage:(MPPImage *)image
    timestampInMilliseconds:(NSInteger)timestampInMilliseconds
                      error:(NSError **)error {
  return [self recognizeAsyncImage:image
           timestampInMilliseconds:timestampInMilliseconds
                  regionOfInterest:CGRectZero
                             error:error];
}

@end
