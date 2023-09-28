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

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"

#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>

#include "mediapipe/framework/formats/image_format.pb.h"

namespace {
using ::mediapipe::Image;
using ::mediapipe::ImageFormat;
using ::mediapipe::ImageFrame;

vImage_Buffer allocatedVImageBuffer(vImagePixelCount width, vImagePixelCount height,
                                    size_t rowBytes) {
  UInt8 *data = new UInt8[height * rowBytes];

  return {.data = data, .width = width, .height = height, .rowBytes = rowBytes};
}

}  // namespace

@interface MPPPixelDataUtils : NSObject

+ (std::unique_ptr<ImageFrame>)imageFrameFromPixelData:(uint8_t *)pixelData
                                             withWidth:(size_t)width
                                                height:(size_t)height
                                                stride:(size_t)stride
                                     pixelBufferFormat:(OSType)pixelBufferFormatType
                                                 error:(NSError **)error;

@end

@interface MPPCVPixelBufferUtils : NSObject

+ (std::unique_ptr<ImageFrame>)imageFrameFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                                     error:(NSError **)error;

@end

@interface MPPCGImageUtils : NSObject

+ (std::unique_ptr<ImageFrame>)imageFrameFromCGImage:(CGImageRef)cgImage error:(NSError **)error;
+ (CGImageRef)cgImageFromImageFrame:(ImageFrame &)imageFrame error:(NSError **)error;

@end

@interface UIImage (ImageFrameUtils)

- (std::unique_ptr<ImageFrame>)imageFrameWithError:(NSError **)error;

@end

@implementation MPPPixelDataUtils : NSObject

+ (std::unique_ptr<ImageFrame>)imageFrameFromPixelData:(uint8_t *)pixelData
                                             withWidth:(size_t)width
                                                height:(size_t)height
                                                stride:(size_t)stride
                                     pixelBufferFormat:(OSType)pixelBufferFormatType
                                                 error:(NSError **)error {
  NSInteger destinationChannelCount = 4;
  size_t destinationBytesPerRow = width * destinationChannelCount;

  ImageFormat::Format imageFormat = ImageFormat::SRGBA;

  vImage_Buffer srcBuffer = {.data = pixelData,
                             .height = (vImagePixelCount)height,
                             .width = (vImagePixelCount)width,
                             .rowBytes = stride};

  vImage_Buffer destBuffer;

  vImage_Error convertError = kvImageNoError;

  switch (pixelBufferFormatType) {
    case kCVPixelFormatType_32RGBA: {
      destBuffer = allocatedVImageBuffer((vImagePixelCount)width, (vImagePixelCount)height,
                                         destinationBytesPerRow);
      convertError = vImageUnpremultiplyData_RGBA8888(&srcBuffer, &destBuffer, kvImageNoFlags);
      break;
    }
    case kCVPixelFormatType_32BGRA: {
      const uint8_t permute_map[4] = {2, 1, 0, 3};
      destBuffer = allocatedVImageBuffer((vImagePixelCount)width, (vImagePixelCount)height,
                                         destinationBytesPerRow);
      convertError =
          vImagePermuteChannels_ARGB8888(&srcBuffer, &destBuffer, permute_map, kvImageNoFlags);
      if (convertError == kvImageNoError) {
        convertError = vImageUnpremultiplyData_RGBA8888(&destBuffer, &destBuffer, kvImageNoFlags);
      }
      break;
    }
    default: {
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInvalidArgumentError
                            description:@"Invalid source pixel buffer format. Expecting one of "
                                        @"kCVPixelFormatType_32RGBA, kCVPixelFormatType_32BGRA"];
      return nullptr;
    }
  }

  if (convertError != kvImageNoError) {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPTasksErrorCodeInternalError
                          description:@"Image format conversion failed."];
    return nullptr;
  }

  // Uses default deleter
  return absl::make_unique<ImageFrame>(imageFormat, width, height, destinationBytesPerRow,
                                       static_cast<uint8 *>(destBuffer.data));
}

@end

@implementation MPPCVPixelBufferUtils

+ (std::unique_ptr<ImageFrame>)imageFrameFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                                     error:(NSError **)error {
  OSType pixelBufferFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
  std::unique_ptr<ImageFrame> imageFrame = nullptr;

  switch (pixelBufferFormat) {
    case kCVPixelFormatType_32RGBA:
    case kCVPixelFormatType_32BGRA: {
      CVPixelBufferLockBaseAddress(pixelBuffer, 0);
      imageFrame = [MPPPixelDataUtils
          imageFrameFromPixelData:(uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer)
                        withWidth:CVPixelBufferGetWidth(pixelBuffer)
                           height:CVPixelBufferGetHeight(pixelBuffer)
                           stride:CVPixelBufferGetBytesPerRow(pixelBuffer)
                pixelBufferFormat:pixelBufferFormat
                            error:error];
      CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    }
    default: {
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInvalidArgumentError
                            description:@"Unsupported pixel format for CVPixelBuffer. Supported "
                                        @"pixel format types are kCVPixelFormatType_32BGRA and "
                                        @"kCVPixelFormatType_32RGBA"];
    }
  }

  return imageFrame;
}

@end

@implementation MPPCGImageUtils

namespace {
static void FreeDataProviderReleaseCallback(void *info, const void *data, size_t size) {
  free(info);
}
}  // namespace

+ (std::unique_ptr<ImageFrame>)imageFrameFromCGImage:(CGImageRef)cgImage error:(NSError **)error {
  size_t width = CGImageGetWidth(cgImage);
  size_t height = CGImageGetHeight(cgImage);

  NSInteger bitsPerComponent = 8;
  NSInteger channelCount = 4;
  size_t bytesPerRow = channelCount * width;

  NSInteger destinationChannelCount = 3;
  size_t destinationBytesPerRow = destinationChannelCount * width;

  UInt8 *pixelDataToReturn = NULL;

  std::unique_ptr<ImageFrame> imageFrame = nullptr;

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  // iOS infers bytesPerRow if it is set to 0.
  // See https://developer.apple.com/documentation/coregraphics/1455939-cgbitmapcontextcreate
  // But for segmentation test image, this was not the case.
  // Hence setting it to the value of channelCount*width.
  // kCGImageAlphaPremultipliedLast specifies that Alpha will always be next to B and the R, G, B values will be pre multiplied with alpha.
  // Images with alpha != 255 are stored with the R, G, B values premultiplied with alpha by iOS.
  // Hence `kCGImageAlphaPremultipliedLast` ensures all kinds of images (alpha from 0 to 255) are correctly accounted for by iOS.
  // kCGBitmapByteOrder32Big specifies that R will be stored before B.
  // In combination they signify a pixelFormat of kCVPixelFormatType32RGBA.
  CGBitmapInfo bitMapinfoFor32RGBA = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
  CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow,
                                               colorSpace, bitMapinfoFor32RGBA);

  if (context) {
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    uint8_t *srcData = (uint8_t *)CGBitmapContextGetData(context);

    if (srcData) {
      // We have drawn the image as an RGBA image with 8 bitsPerComponent and hence can safely input
      // a pixel format of type kCVPixelFormatType_32RGBA for conversion by vImage.
      imageFrame = [MPPPixelDataUtils imageFrameFromPixelData:srcData
                                                    withWidth:width
                                                       height:height
                                                       stride:bytesPerRow
                                            pixelBufferFormat:kCVPixelFormatType_32RGBA
                                                        error:error];
    }

    CGContextRelease(context);
  }

  CGColorSpaceRelease(colorSpace);

  return imageFrame;
}

+ (CGImageRef)cgImageFromImageFrame:(std::shared_ptr<ImageFrame>)imageFrame
                shouldCopyPixelData:(BOOL)shouldCopyPixelData
                              error:(NSError **)error {
  CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;

  ImageFrame *internalImageFrame = imageFrame.get();
  size_t channelCount = 4;

  switch (internalImageFrame->Format()) {
    case ImageFormat::SRGBA: {
      bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
      break;
    }
    default:
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInternalError
                            description:@"Unsupported Image Format Conversion."];
      return NULL;
  }

  size_t bitsPerComponent = 8;

  UInt8 *pixelBufferAddress = NULL;

  vImage_Buffer sourceBuffer = {
      .data = (void *)internalImageFrame->MutablePixelData(),
      .width = static_cast<vImagePixelCount>(internalImageFrame->Width()),
      .height = static_cast<vImagePixelCount>(internalImageFrame->Height()),
      .rowBytes = static_cast<size_t>(internalImageFrame->WidthStep())};

  vImage_Buffer destBuffer;

  CGDataProviderReleaseDataCallback callback = NULL;

  if (shouldCopyPixelData) {
    destBuffer = allocatedVImageBuffer(static_cast<vImagePixelCount>(internalImageFrame->Width()),
                                       static_cast<vImagePixelCount>(internalImageFrame->Height()),
                                       static_cast<size_t>(internalImageFrame->WidthStep()));
    callback = FreeDataProviderReleaseCallback;
  } else {
    destBuffer = sourceBuffer;
  }

  vImage_Error convertError =
      vImagePremultiplyData_RGBA8888(&sourceBuffer, &destBuffer, kvImageNoFlags);

  if (convertError != kvImageNoError) {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPTasksErrorCodeInternalError
                          description:@"Image format conversion failed."];

    return NULL;
  }

  CGDataProviderRef provider = CGDataProviderCreateWithData(
      destBuffer.data, destBuffer.data,
      internalImageFrame->WidthStep() * internalImageFrame->Height(), callback);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGImageRef cgImageRef =
      CGImageCreate(internalImageFrame->Width(), internalImageFrame->Height(), bitsPerComponent,
                    bitsPerComponent * channelCount, internalImageFrame->WidthStep(), colorSpace,
                    bitmapInfo, provider, NULL, YES, kCGRenderingIntentDefault);

  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);

  return cgImageRef;
}

@end

@implementation UIImage (ImageFrameUtils)

- (std::unique_ptr<ImageFrame>)imageFrameFromCIImageWithError:(NSError **)error {
  if (self.CIImage.pixelBuffer) {
    return [MPPCVPixelBufferUtils imageFrameFromCVPixelBuffer:self.CIImage.pixelBuffer error:error];

  } else if (self.CIImage.CGImage) {
    return [MPPCGImageUtils imageFrameFromCGImage:self.CIImage.CGImage error:error];
  } else {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPTasksErrorCodeInvalidArgumentError
                          description:@"CIImage should have CGImage or CVPixelBuffer info."];
  }

  return nullptr;
}

- (std::unique_ptr<ImageFrame>)imageFrameWithError:(NSError **)error {
  if (self.CGImage) {
    return [MPPCGImageUtils imageFrameFromCGImage:self.CGImage error:error];
  } else if (self.CIImage) {
    return [self imageFrameFromCIImageWithError:error];
  } else {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPTasksErrorCodeInvalidArgumentError
                          description:@"UIImage should be initialized from"
                                       " CIImage or CGImage."];
  }

  return nullptr;
}

@end

@implementation MPPImage (Utils)

- (nullable instancetype)initWithCppImage:(mediapipe::Image &)image
           cloningPropertiesOfSourceImage:(MPPImage *)sourceImage
                      shouldCopyPixelData:(BOOL)shouldCopyPixelData
                                    error:(NSError **)error {
  switch (sourceImage.imageSourceType) {
    case MPPImageSourceTypeImage: {
      CGImageRef cgImageRef = [MPPCGImageUtils cgImageFromImageFrame:image.GetImageFrameSharedPtr()
                                                 shouldCopyPixelData:shouldCopyPixelData
                                                               error:error];
      UIImage *image = [UIImage imageWithCGImage:cgImageRef];
      CGImageRelease(cgImageRef);

      return [[MPPImage alloc] initWithUIImage:image orientation:sourceImage.orientation error:nil];
    }
    default:
      // TODO Implement Other Source Types.
      return nil;
  }
}

- (std::unique_ptr<ImageFrame>)imageFrameWithError:(NSError **)error {
  switch (self.imageSourceType) {
    case MPPImageSourceTypeSampleBuffer: {
      CVPixelBufferRef sampleImagePixelBuffer = CMSampleBufferGetImageBuffer(self.sampleBuffer);
      return [MPPCVPixelBufferUtils imageFrameFromCVPixelBuffer:sampleImagePixelBuffer error:error];
    }
    case MPPImageSourceTypePixelBuffer: {
      return [MPPCVPixelBufferUtils imageFrameFromCVPixelBuffer:self.pixelBuffer error:error];
    }
    case MPPImageSourceTypeImage: {
      return [self.image imageFrameWithError:error];
    }
    default:
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInvalidArgumentError
                            description:@"Invalid source type for MPPImage."];
  }

  return nullptr;
}

@end
