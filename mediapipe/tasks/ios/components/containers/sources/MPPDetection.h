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
#import "mediapipe/tasks/ios/components/containers/sources/MPPCategory.h"

NS_ASSUME_NONNULL_BEGIN

static const float kTolerance = 1e-6;

/**
 * Normalized keypoint represents a point in 2D space with x, y coordinates. x and y are normalized
 * to [0.0, 1.0] by the image width and height respectively.
 */
NS_SWIFT_NAME(NormalizedKeypoint)
@interface MPPNormalizedKeypoint : NSObject

/** The (x,y) coordinates location of the normalized keypoint. */
@property(nonatomic, readonly) CGPoint location;

/** The optional label of the normalized keypoint. */
@property(nonatomic, readonly, nullable) NSString *label;

/** The optional score of the normalized keypoint. If score is absent, it will be equal to 0.0. */
@property(nonatomic, readonly) float score;

/**
 * Initializes a new `MPPNormalizedKeypoint` object with the given location, label and score.
 * You must pass 0.0 if score is not present.
 *
 * @param location The (x,y) coordinates location of the normalized keypoint.
 * @param label  The optional label of the normalized keypoint.
 * @param score The optional score of the normalized keypoint. You must pass 0.0 if score is not present. 
 *
 * @return An instance of `MPPNormalizedKeypoint` initialized with the given given location, label and score.
 */
- (instancetype)initWithLocation:(CGPoint)location
                       label:(nullable NSString *)label score:(float)score;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 * Represents the list of classification for a given classifier head. Typically used as a result
 * for classification tasks.
 */
NS_SWIFT_NAME(Detection)
@interface MPPDetection : NSObject

/** An array of `MPPCategory` objects containing the predicted categories. */
@property(nonatomic, readonly) NSArray<MPPCategory *> *categories;

/**
 * The bounding box of the detected object.
 */
@property(nonatomic, readonly) CGRect boundingBox;



/**
 * Initializes a new `MPPClassifications` object with the given head index and array of categories.
 * Head name is initialized to `nil`.
 *
 * @param headIndex The index of the classifier head.
 * @param categories  An array of `MPPCategory` objects containing the predicted categories.
 *
 * @return An instance of `MPPClassifications` initialized with the given head index and
 * array of categories.
 */
- (instancetype)initWithHeadIndex:(NSInteger)headIndex
                       categories:(NSArray<MPPCategory *> *)categories;

/**
 * Initializes a new `MPPClassifications` with the given head index, head name and array of
 * categories.
 *
 * @param headIndex The index of the classifier head.
 * @param headName The name of the classifier head, which is the corresponding tensor metadata
 * name.
 * @param categories An array of `MPPCategory` objects containing the predicted categories.
 *
 * @return An object of `MPPClassifications` initialized with the given head index, head name and
 * array of categories.
 */
- (instancetype)initWithHeadIndex:(NSInteger)headIndex
                         headName:(nullable NSString *)headName
                       categories:(NSArray<MPPCategory *> *)categories NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 * Represents the classification results of a model. Typically used as a result for classification
 * tasks.
 */
NS_SWIFT_NAME(ClassificationResult)
@interface MPPClassificationResult : NSObject

/**
 * An Array of `MPPClassifications` objects containing the predicted categories for each head of
 * the model.
 */
@property(nonatomic, readonly) NSArray<MPPClassifications *> *classifications;

/**
 * The optional timestamp (in milliseconds) of the start of the chunk of data corresponding to
 * these results. If it is set to the value -1, it signifies the absence of a timestamp. This is
 * only used for classification on time series (e.g. audio classification). In these use cases, the
 * amount of data to process might exceed the maximum size that the model can process: to solve
 * this, the input data is split into multiple chunks starting at different timestamps.
 */
@property(nonatomic, readonly) NSInteger timestampMs;

/**
 * Initializes a new `MPPClassificationResult` with the given array of classifications and time
 * stamp (in milliseconds).
 *
 * @param classifications An Array of `MPPClassifications` objects containing the predicted
 * categories for each head of the model.
 * @param timestampMs The timestamp (in milliseconds) of the start of the chunk of data
 * corresponding to these results.
 *
 * @return An instance of `MPPClassificationResult` initialized with the given array of
 * classifications and timestampMs.
 */
- (instancetype)initWithClassifications:(NSArray<MPPClassifications *> *)classifications
                            timestampMs:(NSInteger)timestampMs NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
