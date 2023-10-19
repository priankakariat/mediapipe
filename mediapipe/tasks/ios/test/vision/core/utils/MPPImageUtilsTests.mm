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

#define AssertEqualMPImages(image, expectedImage)                         \
   XCTAssertEqual(image.width, expectedImage.width); \
  XCTAssertEqual(image.height, expectedImage.height); \
  XCTAssertEqual(image.orientation, expectedImage.orientation); \
  XCTAssertEqual(image.imageSourceType, expectedImage.imageSourceType); 

namespace {
  using ::mediapipe::Image;
  using ::mediapipe::ImageFrame;
  using ::mediapipe::file::JoinPath;
  using ::mediapipe::tasks::vision::DecodeImageFromFile;

  const UInt8* PixelsFromCGImage(CGImageRef& cgImage) {
  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
  return CFDataGetBytePtr(resultImageData);
  }

}

/** Unit tests for `MPPImage+Utils`. */
@interface MPPImageUtilsTests : XCTestCase

@end

@implementation MPPImageUtilsTests

#pragma mark - Tests

- (void)setUp {
  [super setUp];
}

+ (Image)cppImageWithMPImage:(MPPImage *)image {
  std::unique_ptr<ImageFrame> imageFrame = [image imageFrameWithError:nil];

  return Image(std::move(imageFrame));
}
// + (void)assertUnderlyingBuffersHaveEqualProperties(CGImageRef& cgImage, Image& cppImage, bool isCopied) {
//   UInt8 *resultImagePixels = PixelsFromCGImage(cgImage);
  
//   ImageFrame *cppImageFrame = cppImage.GetImageFrameSharedPtr().get();

//   XCTAssertEqual(cppImageFrame->Width(), image.width);
//   XCTAssertEqual(cppImageFrame->Height(), image.height);
//   XCTAssertEqual(cppImageFrame->ByteDepth() * 8, CGImageGetBitsPerComponent(cgImage));

//   const UInt8 *cppImagePixels = cppImageFrame->PixelData();

//   if (isCopied) {
//     XCTAssertNotEqual(resultImagePixels, cppImagePixels);
//   }
//   else {
//     XCTAssertEqual(resultImagePixels, cppImagePixels);
//   }
// }


- (void)testInitWithCppImageAndMPPImageSucceeds {
  
  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  Image sourceCppImage = [MPPImageUtilsTests cppImageWithMPImage:sourceImage];
  
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:YES error:nil];

  AssertEqualMPImages(image, sourceImage);

  XCTAssertTrue(image.image.CGImage != nil);
  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(image.image.CGImage));
  const UInt8 *resultImagePixels = CFDataGetBytePtr(resultImageData);
  
  ImageFrame *cppImageFrame = sourceCppImage.GetImageFrameSharedPtr().get();

  XCTAssertEqual(cppImageFrame->Width(), image.width);
  XCTAssertEqual(cppImageFrame->Height(), image.height);
  XCTAssertEqual(cppImageFrame->ByteDepth() * 8, CGImageGetBitsPerComponent(image.image.CGImage));

  const UInt8 *cppImagePixels = cppImageFrame->PixelData();
  XCTAssertNotEqual(resultImagePixels, cppImagePixels);
  
  NSInteger consistentPixels = 0;

  for (int i = 0; i < image.height * CGImageGetBytesPerRow(image.image.CGImage); ++i) {
     consistentPixels +=
        resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
}

- (void)testInitWithCppImageNoCopySucceeds {
  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];

  Image sourceCppImage = Image(std::move(imageFrame));
  
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:NO error:nil];

  XCTAssertTrue(image.image.CGImage != nil);
  XCTAssertEqual(image.width, sourceImage.width);
  XCTAssertEqual(image.height, sourceImage.height);
  XCTAssertEqual(image.orientation, sourceImage.orientation);

  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(image.image.CGImage));
  const UInt8 *resultImagePixels = CFDataGetBytePtr(resultImageData);

  ImageFrame *cppImageFrame = sourceCppImage.GetImageFrameSharedPtr().get();
  XCTAssertEqual(cppImageFrame->Width(), image.width);

  XCTAssertEqual(cppImageFrame->Height(), image.height);

  XCTAssertEqual(cppImageFrame->ByteDepth() * 8, CGImageGetBitsPerComponent(image.image.CGImage));


  const UInt8 *cppImagePixels = cppImageFrame->PixelData();
  XCTAssertEqual(resultImagePixels, cppImagePixels);
  
  NSInteger consistentPixels = 0;

  for (int i = 0; i < image.height * CGImageGetBytesPerRow(image.image.CGImage); ++i) {
     consistentPixels +=
        resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
}

- (void)testInitWithCPPImageCloningPropertiesOfMPImageWithPixelBuffer {
  MPPImage *sourceImage = [MPPImage imageOfPixelBufferSourceTypeWithFileInfo:kBurgerImageFileInfo pixelBufferFormatType:kCVPixelFormatType_32RGBA];
  NSLog(@"Done 1");

  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];
  
  Image sourceCppImage = Image(std::move(imageFrame));
  NSLog(@"Done");
  NSError *error;
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:YES error:&error];
  NSLog(@"Done image");

  XCTAssertTrue(image.pixelBuffer != nil);
  XCTAssertEqual(image.width, sourceImage.width);
  XCTAssertEqual(image.height, sourceImage.height);
  XCTAssertEqual(image.orientation, sourceImage.orientation);

  ImageFrame *cppImageFrame = sourceCppImage.GetImageFrameSharedPtr().get();
  XCTAssertEqual(cppImageFrame->Width(), image.width);
  XCTAssertEqual(cppImageFrame->Height(), image.height);
  XCTAssertEqual(cppImageFrame->WidthStep(), CVPixelBufferGetBytesPerRow(image.pixelBuffer));


  const UInt8 *cppImagePixels = cppImageFrame->PixelData();
  CVPixelBufferLockBaseAddress(image.pixelBuffer, 0);
  UInt8 *resultImagePixels = (UInt8 *)CVPixelBufferGetBaseAddress(image.pixelBuffer);
  XCTAssertNotEqual(resultImagePixels, cppImagePixels);
  
  NSInteger consistentPixels = 0;

  for (int i = 0; i < image.height * CVPixelBufferGetBytesPerRow(image.pixelBuffer); ++i) {
     consistentPixels +=
        resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }
  CVPixelBufferUnlockBaseAddress(image.pixelBuffer, 0);

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
}

- (void)testInitWithCPPImageCloningPropertiesOfMPImageWithPixelBufferNoCopy {
  MPPImage *sourceImage = [MPPImage imageOfPixelBufferSourceTypeWithFileInfo:kBurgerImageFileInfo pixelBufferFormatType:kCVPixelFormatType_32RGBA];
  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];

  Image sourceCppImage = Image(std::move(imageFrame));
  
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage cloningPropertiesOfSourceImage:sourceImage shouldCopyPixelData:NO error:nil];

  XCTAssertTrue(image.pixelBuffer != nil);
  XCTAssertEqual(image.width, sourceImage.width);
  XCTAssertEqual(image.height, sourceImage.height);
  XCTAssertEqual(image.orientation, sourceImage.orientation);

  ImageFrame *cppImageFrame = sourceCppImage.GetImageFrameSharedPtr().get();
  XCTAssertEqual(cppImageFrame->Width(), image.width);
  XCTAssertEqual(cppImageFrame->Height(), image.height);
  XCTAssertEqual(cppImageFrame->WidthStep(), CVPixelBufferGetBytesPerRow(image.pixelBuffer));


  const UInt8 *cppImagePixels = cppImageFrame->PixelData();
  CVPixelBufferLockBaseAddress(image.pixelBuffer, 0);
  UInt8 *resultImagePixels = (UInt8 *)CVPixelBufferGetBaseAddress(image.pixelBuffer);
  XCTAssertEqual(resultImagePixels, cppImagePixels);
  
  NSInteger consistentPixels = 0;

  for (int i = 0; i < image.height * CVPixelBufferGetBytesPerRow(image.pixelBuffer); ++i) {
     consistentPixels +=
        resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
  CVPixelBufferUnlockBaseAddress(image.pixelBuffer, 0);

}

@end

NS_ASSUME_NONNULL_END
