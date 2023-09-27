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

#import "mediapipe/tasks/ios/vision/core/utils/sources/MPPImage+Utils.h"
#import "mediapipe/tasks/ios/test/vision/utils/sources/MPPImage+TestUtils.h"

#include "mediapipe/framework/deps/file_path.h"
#include "mediapipe/tasks/cc/vision/utils/image_utils.h"

#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static MPPFileInfo *const kBurgerImageFileInfo = [[MPPFileInfo alloc] initWithName:@"burger" type:@"jpg"];
static CGFloat kBurgerImageWidthInPixels = 480.0f;
static CGFloat kBurgerImageHeightInPixels = 325.0f;

constexpr char kTestDataDirectory[] = "/mediapipe/tasks/testdata/vision/";
constexpr char kBurgerImageFile[] = "burger.jpg";

static NSString *const kExpectedErrorDomain = @"com.google.mediapipe.tasks";

#define AssertEqualErrors(error, expectedError)                                               \
  XCTAssertNotNil(error);                                                                     \
  XCTAssertEqualObjects(error.domain, expectedError.domain);                                  \
  XCTAssertEqual(error.code, expectedError.code);                                             \
  XCTAssertNotEqual(                                                                          \
      [error.localizedDescription rangeOfString:expectedError.localizedDescription].location, \
      NSNotFound)

namespace {
  using ::mediapipe::Image;
  using ::mediapipe::file::JoinPath;
  using ::mediapipe::file::DecodeImageFromFile;

}

/** Unit tests for `MPPImage+Utils`. */
@interface MPPImageUtilsTests : XCTestCase

@end

@implementation MPPImageUtilsTests

#pragma mark - Tests

- (void)setUp {
  [super setUp];
}

- (void)testInitWithCppImageAndMPPImageSucceeds {

  Image cppImage = DecodeImageFromFile(JoinPath("./", kTestDataDirectory, kBurgerImageFile));

  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  MPPImage *image = [[MPPImage alloc] initWithImage:cppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:YES error:nil];

  XCTAssertNotNil(image.CGImage);
  XCTAssertEqual(image.width, sourceImage.width);
  XCTAssertEqual(image.height, sourceImage.height);
  XCTAssertEqual(image.orientation, sourceImage.orientation);

  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
  const UInt8 *resultImagePixels = CFDataGetBytePtr(resultImageData);

  const UInt8 *cppImagePixels = image.GetImageFrameSharedPtr().get();

  for (int i = 0; i < image.width * image.height * 4) {
    XCTAssertEqual(resultImagePixels[i], cppImagePixels[i]);
  }
}


@end

NS_ASSUME_NONNULL_END
