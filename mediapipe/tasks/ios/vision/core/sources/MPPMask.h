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


NS_ASSUME_NONNULL_BEGIN

/** An image used in on-device machine learning using MediaPipe Task library. */
NS_SWIFT_NAME(Mask)
@interface MPPMask : NSObject

/** Width of the image in pixels. */
@property(nonatomic, readonly) CGFloat width;

/** Height of the image in pixels. */
@property(nonatomic, readonly) CGFloat height;

@property(nonatomic, readonly) MPPMaskDataType dataType;

@property(nonatomic, readonly) const UInt8 *uint8Array;

@property(nonatomic, readonly) const float *floatArray;

- (nullable instancetype)initWithUInt8Array:(UInt8 *)uint8Array
                                        shouldCopy:(BOOL)shouldCopy
                                        error:(NSError **)error NS_DESIGNATED_INITIALIZER;



- (nullable instancetype)initWithFloat32Array:(float *)float
                                        shouldCopy:(BOOL)shouldCopy
                                        error:(NSError **)error NS_DESIGNATED_INITIALIZER;
/** Unavailable. */
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
