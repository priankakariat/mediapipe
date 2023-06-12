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

#import "mediapipe/tasks/ios/vision/core/sources/MPPImage.h"
#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"

NS_ASSUME_NONNULL_BEGIN

typedef std::function<void(void*)> Deleter;

@interface MPMask {
    std::unique_ptr<UInt8[], Deleter> _allocatedUInt8Array; 
    std::unique_ptr<float[], Deleter> _allocatedFloatArray; 
}

@end

@implementation MPMask

- (nullable instancetype)initWithUInt8Array:(UInt8 *)uint8Array
                                        width:(NSInteger)width
                                        height:(NSInteger)height
                                        shouldCopy:(BOOL)shouldCopy
                                        error:(NSError **)error NS_DESIGNATED_INITIALIZER {
  self = [super init];
  if (self) {
  _dataType = MPPMaskDataTypeUInt8;
  size_t arrayLength = (size_t)width * height;
  _width = width;
  _height = height;

  if (shouldCopy) {
    _shouldCopy = shouldCopy;
    _allocatedUInt8Array = {new uint8_t[width * height], delete};
    _uint8Array = _allocatedUInt8Array.get();
  }
  else {
    _uint8Array = uint8Array;
  }
  }
  return self;

}

- (nullable instancetype)initWithFloatArray:(float *)floatArray
                                        width:(NSInteger)width
                                        height:(NSInteger)height
                                        shouldCopy:(BOOL)shouldCopy
                                        error:(NSError **)error NS_DESIGNATED_INITIALIZER {
  self = [super init];
  if (self) {
  _dataType = MPPMaskDataTypeFloat;
  size_t arrayLength = (size_t)width * height;
  _width = width;
  _height = height;

  if (shouldCopy) {
    _shouldCopy = shouldCopy;
    _allocatedFloatArray = {new float[width * height], delete};
    _floatArray = _allocatedUInt8Array.get();
  }
  else {
    _floatArray = floatArray;
  }
  }
  return self;

}

@end

NS_ASSUME_NONNULL_END
