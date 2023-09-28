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

#import "mediapipe/tasks/ios/common/utils/sources/NSString+Helpers.h"
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
  using ::mediapipe::ImageFrame;
  using ::mediapipe::file::JoinPath;
  using ::mediapipe::tasks::vision::DecodeImageFromFile;

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

  // absl::StatusOr<Image> cppImage = DecodeImageFromFile(kBurgerImageFileInfo.path.cppString);
  // XCTAssertTrue(cppImage.status().code() == absl::StatusCode::kOk);
  
  NSLog(@"Continue after");
  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];

  Image sourceCppImage = Image(std::move(imageFrame));
  
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:YES error:nil];
  NSLog(@"After image creatuin");

  XCTAssertTrue(image.image.CGImage != nil);
  NSLog(@"After CGImage");
  XCTAssertEqual(image.width, sourceImage.width);
  XCTAssertEqual(image.height, sourceImage.height);
  XCTAssertEqual(image.orientation, sourceImage.orientation);
  NSLog(@"After All Tests");

  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(image.image.CGImage));
  const UInt8 *resultImagePixels = CFDataGetBytePtr(resultImageData);

    NSLog(@"After result image pix");


  ImageFrame *cppImageFrame = sourceCppImage.GetImageFrameSharedPtr().get();
  
      NSLog(@"After rimage frame get");


  XCTAssertEqual(cppImageFrame->Width(), image.width);
 NSLog(@"After width");

  XCTAssertEqual(cppImageFrame->Height(), image.height);
          NSLog(@"After height");

  // XCTAssertEqual(cppImageFrame->WidthStep(), CGImageGetBytesPerRow(image.image.CGImage));
  XCTAssertEqual(cppImageFrame->ByteDepth() * 8, CGImageGetBitsPerComponent(image.image.CGImage));
            NSLog(@"After byte depth");



  const UInt8 *cppImagePixels = cppImageFrame->PixelData();
              NSLog(@"After cpp image pixels");

  
  NSInteger consistentPixels = 0;

  int j = 0;
  NSLog(@"Enter For");
  for (int i = 0; i < image.height * CGImageGetBytesPerRow(image.image.CGImage); ++i) {

    // if ((i % 4) == 0) {
    //   continue;
    // }
     consistentPixels +=
        resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
}

- (void)testInitWithCppImageNoCopySucceeds {

  // absl::StatusOr<Image> cppImage = DecodeImageFromFile(kBurgerImageFileInfo.path.cppString);
  // XCTAssertTrue(cppImage.status().code() == absl::StatusCode::kOk);
  
  NSLog(@"Continue after");
  CGImageGetWidth(nil);

  void *data = malloc(0);
  if (!data) {
      NSLog(@"Data %@", data);
  }

  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];

  Image sourceCppImage = Image(std::move(imageFrame));
  
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:NO error:nil];
  NSLog(@"After image creatuin");

  XCTAssertTrue(image.image.CGImage != nil);
  NSLog(@"After CGImage");
  XCTAssertEqual(image.width, sourceImage.width);
  XCTAssertEqual(image.height, sourceImage.height);
  XCTAssertEqual(image.orientation, sourceImage.orientation);
  NSLog(@"After All Tests");

  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(image.image.CGImage));
  const UInt8 *resultImagePixels = CFDataGetBytePtr(resultImageData);

    NSLog(@"After result image pix");


  ImageFrame *cppImageFrame = sourceCppImage.GetImageFrameSharedPtr().get();
  
      NSLog(@"After rimage frame get");


  XCTAssertEqual(cppImageFrame->Width(), image.width);
 NSLog(@"After width");

  XCTAssertEqual(cppImageFrame->Height(), image.height);
          NSLog(@"After height");

  // XCTAssertEqual(cppImageFrame->WidthStep(), CGImageGetBytesPerRow(image.image.CGImage));
  XCTAssertEqual(cppImageFrame->ByteDepth() * 8, CGImageGetBitsPerComponent(image.image.CGImage));
            NSLog(@"After byte depth");



  const UInt8 *cppImagePixels = cppImageFrame->PixelData();
              NSLog(@"After cpp image pixels");

  
  NSInteger consistentPixels = 0;

  int j = 0;
  NSLog(@"Enter For");
  for (int i = 0; i < image.height * CGImageGetBytesPerRow(image.image.CGImage); ++i) {

    // if ((i % 4) == 0) {
    //   continue;
    // }
     consistentPixels +=
        resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
}


@end

NS_ASSUME_NONNULL_END
