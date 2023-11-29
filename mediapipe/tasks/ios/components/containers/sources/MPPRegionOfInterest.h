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
#import "mediapipe/tasks/ios/components/containers/sources/MPPDetection.h"

NS_ASSUME_NONNULL_BEGIN

/** The value class representing a landmark connection. */
NS_SWIFT_NAME(RegionOfInterest)
@interface MPPRegionOfInterest : NSObject

@property(nonatomic, readonly, nullable) MPPNormalizedKeypoint *keypoint;

@property(nonatomic, readonly, nullable) NSArray <MPPNormalizedKeypoint *> *scribbles;

/**
 * Initializes a new `RegionOfInterest` that represents a single normalized point pointing to the object that the user wants to segment.
 *
 * @param normalizedKeypoint The normalized key point pointing to the object that the user wants to segment.
 *
 * @return An instance of `RegionOfInterest` initialized with the given normalized key point pointing to the object that the user wants to segment.
 */
- (instancetype)initWithNormalizedKeyPoint:(MPPNormalizedKeypoint *)normalizedKeypoint NS_DESIGNATED_INITIALIZER;

/**
 * Initializes a new `RegionOfInterest` that represents scribbles over the object that the user wants to segment.
 *
 * @param scribbles The array of normalized key points that make up scribbles over the object that the user wants to segment.
 *
 * @return An instance of `RegionOfInterest` initialized with the given normalized key points that make up scribbles over the object that the user wants to segment.
 */
- (instancetype)initWitScribbles:(NSArray <MPPNormalizedKeypoint *> *)scribbles NS_DESIGNATED_INITIALIZER;


- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
