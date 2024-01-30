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

#import "mediapipe/tasks/ios/vision/face_stylizer/utils/sources/MPPFaceStylizerResult+Helpers.h"

#import "mediapipe/tasks/ios/vision/core/utils/sources/MPPImage+Utils.h"

#include "mediapipe/framework/formats/image.h"
#include "mediapipe/framework/packet.h"

namespace {
using ::mediapipe::Image;
using ::mediapipe::ImageFrameSharedPtr;
using ::mediapipe::Packet;
}  // namespace

@implementation MPPFaceStylizerResult (Helpers)

+ (MPPFaceStylizerResult *)
    faceStylizerResultWithStylizedImagePacket:(const mediapipe::Packet &)stylizedImagePacket sourceImage:(MPPImage *)sourceImage shouldCopyPixelData:(BOOL)shouldCopyPixelData error:(NSError **)error {

    if (!stylizedImagePacket.ValidateAsType<Image>().ok()) {
       return nil; 
    }

    const Image &cppStylizedImage = stylizedImagePacket.Get<Image>();

    MPPImage *stylizedImage = [[MPPImage alloc] initWithCppImage:Image cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:shouldCopyPixelData error:error]; 

    if (!stylizedImage) {
      return nil;
    }

    NSInteger timestampInMilliseconds =
      (NSInteger)(stylizedImagePacket.Timestamp().Value() / kMicrosecondsPerMillisecond);

  return [[MPPFaceStylizerResult alloc] initWithImage:stylizedImage
                                    timestampInMilliseconds:timestampInMilliseconds];
}

@end
