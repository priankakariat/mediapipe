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

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/NSString+Helpers.h"
#import "mediapipe/tasks/ios/test/vision/utils/sources/MPPImage+TestUtils.h"
#import "mediapipe/tasks/ios/vision/core/utils/sources/MPPImage+Utils.h"

#include "mediapipe/framework/deps/file_path.h"
#include "mediapipe/tasks/cc/vision/utils/image_utils.h"

#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

static MPPFileInfo *const kBurgerImageFileInfo = [[MPPFileInfo alloc] initWithName:@"burger"
                                                                              type:@"jpg"];

constexpr char kTestDataDirectory[] = "/mediapipe/tasks/testdata/vision/";
constexpr char kBurgerImageFile[] = "burger.jpg";

static NSString *const kExpectedErrorDomain = @"com.google.mediapipe.tasks";

#define AssertEqualErrors(error, expectedError)              \
  XCTAssertNotNil(error);                                    \
  XCTAssertEqualObjects(error.domain, expectedError.domain); \
  XCTAssertEqual(error.code, expectedError.code);            \
  XCTAssertEqualObjects(error.localizedDescription, expectedError.localizedDescription)

#define AssertEqualMPImages(image, expectedImage)               \
  XCTAssertEqual(image.width, expectedImage.width);             \
  XCTAssertEqual(image.height, expectedImage.height);           \
  XCTAssertEqual(image.orientation, expectedImage.orientation); \
  XCTAssertEqual(image.imageSourceType, expectedImage.imageSourceType);

namespace {
using ::mediapipe::Image;
using ::mediapipe::ImageFrame;
using ::mediapipe::file::JoinPath;
using ::mediapipe::tasks::vision::DecodeImageFromFile;

Image CppImageWithMPImage(MPPImage *image) {
  std::unique_ptr<ImageFrame> imageFrame = [image imageFrameWithError:nil];
  return Image(std::move(imageFrame));
}

}  // namespace

/** Unit tests for `MPPImage+Utils`. */
@interface MPPImageUtilsTests : XCTestCase

@end

@implementation MPPImageUtilsTests

#pragma mark - Tests

- (void)setUp {
  [super setUp];
}

+ (void)assertUnderlyingBufferOfCGImage:(const CGImageRef &)cgImage
                        equalToCppImage:(const Image &)cppImage {
  // Using common method for both copy and no Copy scenario without testing equality of the base
  // addresses of the pixel buffers of the `CGImage` and the C++ Image. `CGDataProviderCopyData` is
  // currently the only documented way to access the underlying bytes of a `CGImage` and according
  // to Apple's official documentation, this method should return copied bytes of the `CGImage`.
  // Thus, in theory, testing equality of the base addresses of the copied bytes of the `CGImage`
  // and the C++ `Image` is pointless.
  //
  // But debugging `CGDataProviderCopyData` output always returned the original underlying bytes of
  // the `CGImage` without a copy. The base address of the `CGImage` buffer was found to be equal to
  // the base address of the C++ `Image` buffer in the no copy scenario and unequal in the copy
  // scenario. This verifies that the copy and no copy scenarios work as expected. Since this isn't
  // the expected behaviour of `CGDataProviderCopyData` according to Apple's official documentation,
  // the equality checks of the base addresses of the pixel buffers of the `CGImage` and C++ Image
  // have been omitted for the time being.
  CFDataRef resultImageData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
  const UInt8 *resultImagePixels = CFDataGetBytePtr(resultImageData);

  ImageFrame *cppImageFrame = cppImage.GetImageFrameSharedPtr().get();

  XCTAssertEqual(cppImageFrame->Width(), CGImageGetWidth(cgImage));
  XCTAssertEqual(cppImageFrame->Height(), CGImageGetHeight(cgImage));
  XCTAssertEqual(cppImageFrame->ByteDepth() * 8, CGImageGetBitsPerComponent(cgImage));

  const UInt8 *cppImagePixels = cppImageFrame->PixelData();

  NSInteger consistentPixels = 0;
  for (int i = 0; i < cppImageFrame->Height() * cppImageFrame->WidthStep(); ++i) {
    consistentPixels += resultImagePixels[i] == cppImagePixels[i] ? 1 : 0;
  }

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());

  CFDataRelease(resultImageData);
}

- (void)testInitWithCppImageAndMPPImageSucceeds {
  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  Image sourceCppImage = CppImageWithMPImage(sourceImage);

  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage
                        cloningPropertiesOfSourceImage:sourceImage
                                   shouldCopyPixelData:YES
                                                 error:nil];

  AssertEqualMPImages(image, sourceImage);

  XCTAssertTrue(image.image.CGImage != NULL);
  [MPPImageUtilsTests assertUnderlyingBufferOfCGImage:image.image.CGImage
                                      equalToCppImage:sourceCppImage];
}

- (void)testInitWithCppImageNoCopySucceeds {
  MPPImage *sourceImage = [MPPImage imageWithFileInfo:kBurgerImageFileInfo];
  Image sourceCppImage = CppImageWithMPImage(sourceImage);

  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage
                        cloningPropertiesOfSourceImage:sourceImage
                                   shouldCopyPixelData:NO
                                                 error:nil];

  AssertEqualMPImages(image, sourceImage);

  XCTAssertTrue(image.image.CGImage != NULL);
  [MPPImageUtilsTests assertUnderlyingBufferOfCGImage:image.image.CGImage
                                      equalToCppImage:sourceCppImage];
}

- (void)testInitWithCPPImageCloningPropertiesOfMPImageWithPixelBuffer {
  MPPImage *sourceImage =
      [MPPImage imageOfPixelBufferSourceTypeWithFileInfo:kBurgerImageFileInfo
                                   pixelBufferFormatType:kCVPixelFormatType_32RGBA];

  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];

  Image sourceCppImage = Image(std::move(imageFrame));

  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage
                        cloningPropertiesOfSourceImage:sourceImage
                                   shouldCopyPixelData:YES
                                                 error:nil];

  XCTAssertTrue(image.pixelBuffer != NULL);
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

  for (int i = 0; i < image.height * image.width; ++i) {
    consistentPixels += resultImagePixels[i * 4] == cppImagePixels[i * 4 + 2] ? 1 : 0;
    consistentPixels += resultImagePixels[i * 4 + 1] == cppImagePixels[i * 4 + 1] ? 1 : 0;
    consistentPixels += resultImagePixels[i * 4 + 2] == cppImagePixels[i * 4] ? 1 : 0;
    consistentPixels += resultImagePixels[i * 4 + 3] == cppImagePixels[i * 4 + 3] ? 1 : 0;
  }
  CVPixelBufferUnlockBaseAddress(image.pixelBuffer, 0);

  XCTAssertEqual(consistentPixels, cppImageFrame->Height() * cppImageFrame->WidthStep());
}

- (void)testInitWithCPPImageCloningPropertiesOfMPImageWithPixelBufferNoCopy {
  MPPImage *sourceImage =
      [MPPImage imageOfPixelBufferSourceTypeWithFileInfo:kBurgerImageFileInfo
                                   pixelBufferFormatType:kCVPixelFormatType_32RGBA];
  std::unique_ptr<ImageFrame> imageFrame = [sourceImage imageFrameWithError:nil];

  Image sourceCppImage = Image(std::move(imageFrame));

  NSError *error;
  MPPImage *image = [[MPPImage alloc] initWithCppImage:sourceCppImage
                        cloningPropertiesOfSourceImage:sourceImage
                                   shouldCopyPixelData:NO
                                                 error:&error];

  XCTAssertNil(image);
  AssertEqualErrors(
      error,
      [NSError
          errorWithDomain:kExpectedErrorDomain
                     code:MPPTasksErrorCodeInvalidArgumentError
                 userInfo:@{
                   NSLocalizedDescriptionKey :
                       @"When the source type is pixel buffer, you cannot request uncopied data."
                 }]);
}

@end

NS_ASSUME_NONNULL_END
