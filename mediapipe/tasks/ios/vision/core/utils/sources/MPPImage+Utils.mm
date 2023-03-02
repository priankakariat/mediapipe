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
using ::mediapipe::ImageFrame;
using ::mediapipe::Image;
}

static void FreeCVPixelBufferReleaseCallback(void* releaseRefCon, const void* baseAddress) {
  free(refCon);
}

@interface MPPPixelDataUtils : NSObject

+ (std::uinique_ptr<ImageFrame>)imageFrameFromVImage:(uint8_t *)pixelData
                             withWidth:(size_t)width
                                height:(size_t)height
                                stride:(size_t)stride
                     pixelBufferFormat:(OSType)pixelBufferFormatType
                                 error:(NSError **)error;

@end

@interface MPPCVPixelBufferUtils : NSObject

+ (std::unique_ptr<ImageFrame>)imageFrameFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                                     error:(NSError **)error;

+ (CVPixelBufferRef)cvPixelBufferFromImageFrame:(const ImageFrame &)imageFrame error:(NSError **)error;
@end

@interface MPPCGImageUtils : NSObject

+ (std::unique_ptr<ImageFrame>)imageFrameFromCGImage:(CGImageRef)cgImage error:(NSError **)error;

@end

@interface UIImage (ImageFrameUtils)

- (std::unique_ptr<ImageFrame>)imageFrameWithError:(NSError **)error;

@end
å


@implementation MPPPixelDataUtils : NSObject

+ (uint8_t *)DataFromRGBPixelData:(uint8_t *)pixelData withWidth:(size_t)width height:(size_t)height stride:(size_t)stride error:(NSError **)error{
  
}

+ (std::uinique_ptr<ImageFrame>)imageFrameFromPixelData:(uint8_t *)pixelData
                             withWidth:(size_t)width
                                height:(size_t)height
                                stride:(size_t)stride
                     pixelBufferFormat:(OSType)pixelBufferFormatType
                                 error:(NSError **)error canOverWrite:(BOOL)canOverWrite {
  NSInteger destinationChannelCount = 3;
  size_t destinationBytesPerRow = width * destinationChannelCount;

  uint8_t *destPixelBufferAddress =
      (uint8_t *)[MPPCommonUtils mallocWithSize:sizeof(uint8_t) * height * destinationBytesPerRow
                                          error:error];

  if (!destPixelBufferAddress) {
    return NULL;
  }

  vImage_Buffer srcBuffer = {.data = pixelData,
                             .height = (vImagePixelCount)height,
                             .width = (vImagePixelCount)width,
                             .rowBytes = stride};

  vImage_Buffer destBuffer;

  if (can_overwrite) {
    return 
  }
  vImage_Buffer destBuffer = {.data = destPixelBufferAddress,
                              .height = (vImagePixelCount)height,
                              .width = (vImagePixelCount)width,
                              .rowBytes = destinationBytesPerRow};

  vImage_Error convertError = kvImageNoError;

  switch (pixelBufferFormatType) {
    case kCVPixelFormatType_32RGBA: {
      convertError = vImageConvert_RGBA8888toRGB888(&srcBuffer, &destBuffer, kvImageNoFlags);
      break;
    }
    case kCVPixelFormatType_32BGRA: {
      convertError = vImageConvert_BGRA8888toRGB888(&srcBuffer, &destBuffer, kvImageNoFlags);
      break;
    }
    default: {
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInvalidArgumentError
                            description:@"Invalid source pixel buffer format. Expecting one of "
                                        @"kCVPixelFormatType_32RGBA, kCVPixelFormatType_32BGRA"];

      free(destPixelBufferAddress);
      return NULL;
    }
  }

  if (convertError != kvImageNoError) {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPTasksErrorCodeInternalError
                          description:@"Image format conversion failed."];

    free(destPixelBufferAddress);
    return NULL;
  }

  return destPixelBufferAddress;
}

@end

@implementation MPPCVPixelBufferUtils

+ (std::unique_ptr<ImageFrame>)rgbImageFrameFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                                        error:(NSError **)error {
  CVPixelBufferLockBaseAddress(pixelBuffer, 0);

  size_t width = CVPixelBufferGetWidth(pixelBuffer);
  size_t height = CVPixelBufferGetHeight(pixelBuffer);
  size_t stride = CVPixelBufferGetBytesPerRow(pixelBuffer);

  uint8_t *rgbPixelData = [MPPPixelDataUtils
        :(uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer)
                      withWidth:CVPixelBufferGetWidth(pixelBuffer)
                         height:CVPixelBufferGetHeight(pixelBuffer)
                         stride:CVPixelBufferGetBytesPerRow(pixelBuffer)
              pixelBufferFormat:CVPixelBufferGetPixelFormatType(pixelBuffer)
                          error:error];

  CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

  if (!rgbPixelData) {
    return nullptr;
  }

  std::unique_ptr<ImageFrame> imageFrame =
      absl::make_unique<ImageFrame>(::mediapipe::ImageFormat::SRGB, width,
                                    height, stride, static_cast<uint8 *>(rgbPixelData),
                                    /*deleter=*/free);

  return imageFrame;
}

+ (std::unique_ptr<ImageFrame>)imageFrameFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                                     error:(NSError **)error {
  uint8_t *pixelData = NULL;

  OSType pixelBufferFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);

  switch (pixelBufferFormat) {
    case kCVPixelFormatType_32BGRA: {
      return [MPPCVPixelBufferUtils rgbImageFrameFromCVPixelBuffer:pixelBuffer error:error];
    }
    default: {
      [MPPCommonUtils createCustomError:error
                               withCode:MPPTasksErrorCodeInvalidArgumentError
                            description:@"Unsupported pixel format for CVPixelBuffer. Supported "
                                        @"pixel format types are kCVPixelFormatType_32BGRA"];
    }
  }

  return nullptr;
}

+ (CVPixelBufferRef)cvPixelBufferFromImageFrame:(const ImageFrame &)imageFrame error:(NSError **)error {

  const uint8* frameData = frame.PixelData();

  mediapipe::ImageFormat::Format image_format = frame.Format();
  OSType pixel_format = 0;
  CVReturn status;
  unsigned char *bgraPixel = (unsigned char *)malloc([imageRGBAData length]);

    vImage_Buffer src;
    src.height = frame.Height();
    src.width = frame.Width();
    src.rowBytes = frame.Width() * 3;
    src.data = (void *)frameData;

    vImage_Buffer dest;
    dest.height = height;
    dest.width = width;
    dest.rowBytes = frame.Width() * 4;
    dest.data = bgraPixel;

  switch (image_format) {
    case mediapipe::ImageFormat::SRGB: {
      pixel_format = kCVPixelFormatType_32BGRA;
      vImage_Error error = vImagePermuteChannels_ARGB8888(&src, &dest, order, kvImageNoFlags);

      NSDictionary *options = @{
    (__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey : @(YES),
    (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey : @(YES)
  };
  CVPixelBufferRef pixelBuffer;
  CVReturn status = CVPixelBufferCreateWithBytes(
      kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, (void *)frameData,
      bpr, NULL, nil, (__bridge CFDictionaryRef)options, &pixelBuffer);

  if (status != kCVReturnSuccess) {
    XCTFail(@"Failed to create pixel buffer.");
  }

  CVPixelBufferLockBaseAddress(pixelBuffer, 0);
  CMVideoFormatDescriptionRef videoInfo = NULL;
  CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &videoInfo);

  CMSampleBufferRef buffer;
  CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, true, NULL, NULL, videoInfo,
                                     &kCMTimingInfoInvalid, &buffer);

  CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

      pixel_format = kCVPixelFormatType_32BGRA;
      // Swap R and B channels.
      vImage_Buffer v_image = vImageForImageFrame(frame);
      vImage_Buffer v_dest;
      if (can_overwrite) {
        v_dest = v_image;
      } else {
        ASSIGN_OR_RETURN(pixel_buffer,
                         CreateCVPixelBufferWithoutPool(
                             frame.Width(), frame.Height(), pixel_format));
        status = CVPixelBufferLockBaseAddress(*pixel_buffer,
                                              kCVPixelBufferLock_ReadOnly);
        RET_CHECK(status == kCVReturnSuccess)
            << "CVPixelBufferLockBaseAddress failed: " << status;
        v_dest = vImageForCVPixelBuffer(*pixel_buffer);
      }
      const uint8_t permute_map[4] = {2, 1, 0, 3};
      vImage_Error vError = vImagePermuteChannels_ARGB8888(
          &v_image, &v_dest, permute_map, kvImageNoFlags);
      RET_CHECK(vError == kvImageNoError)
          << "vImagePermuteChannels failed: " << vError;
    } break;

    case mediapipe::ImageFormat::GRAY8:
      pixel_format = kCVPixelFormatType_OneComponent8;
      break;

    case mediapipe::ImageFormat::VEC32F1:
      pixel_format = kCVPixelFormatType_OneComponent32Float;
      break;

    case mediapipe::ImageFormat::VEC32F2:
      pixel_format = kCVPixelFormatType_TwoComponent32Float;
      break;

    default:
      return ::mediapipe::UnknownErrorBuilder(MEDIAPIPE_LOC)
             << "unsupported ImageFrame format: " << image_format;
  }

  if (*pixel_buffer) {
    status = CVPixelBufferUnlockBaseAddress(*pixel_buffer,
                                            kCVPixelBufferLock_ReadOnly);
    RET_CHECK(status == kCVReturnSuccess)
        << "CVPixelBufferUnlockBaseAddress failed: " << status;
  } else {
    CVPixelBufferRef pixel_buffer_temp;
    auto holder = absl::make_unique<std::shared_ptr<void>>(image_frame);
    status = CVPixelBufferCreateWithBytes(
        NULL, frame.Width(), frame.Height(), pixel_format, frame_data,
        frame.WidthStep(), ReleaseSharedPtr, holder.get(),
        GetCVPixelBufferAttributesForGlCompatibility(), &pixel_buffer_temp);
    RET_CHECK(status == kCVReturnSuccess)
        << "failed to create pixel buffer: " << status;
    holder.release();  // will be deleted by ReleaseSharedPtr
    pixel_buffer.adopt(pixel_buffer_temp);
  }

  return pixel_buffer;

}

@end

@implementation MPPCGImageUtils

+ (std::unique_ptr<ImageFrame>)imageFrameFromCGImage:(CGImageRef)cgImage error:(NSError **)error {

  size_t width = CGImageGetWidth(cgImage);
  size_t height = CGImageGetHeight(cgImage);

  NSInteger bitsPerComponent = 8;
  NSInteger bitsPerPixel = 32;
  NSInteger channelCount = 4;

  CGImageGetB

  vImage_Buffer imageBuffer;
  UInt8 *pixelDataToReturn = NULL;

   vImage_CGImageFormat format = {
    .bitsPerComponent = bitsPerComponent,
    .bitsPerPixel = 32,
    .colorSpace = NULL,
    .bitmapInfo = kCGImageAlphaFirst | kCGBitmapByteOrder32Big,
    .version = 0,
    .decode = NULL,
    .renderingIntent = kCGRenderingIntentDefault,
  };
  
  vImage_Error ret = vImageBuffer_InitWithCGImage(&imageBuffer, &format, NULL, sourceRef, kvImageNoFlags);
  if (ret != kvImageNoError)
  {
    free(imageBuffer.data);
  }

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  size_t bytesPerRow = channelCount * width;

  // iOS infers bytesPerRow if it is set to 0.
  // See https://developer.apple.com/documentation/coregraphics/1455939-cgbitmapcontextcreate
  // But for segmentation test image, this was not the case.
  // Hence setting it to the value of channelCount*width.
  // kCGImageAlphaNoneSkipLast specifies that Alpha will always be next to B.
  // kCGBitmapByteOrder32Big specifies that R will be stored before B.
  // In combination they signify a pixelFormat of kCVPixelFormatType32RGBA.
  CGBitmapInfo bitMapinfoFor32RGBA = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big;
  CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow,
                                               colorSpace, bitMapinfoFor32RGBA);

  if (context) {
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    uint8_t *srcData = (uint8_t *)CGBitmapContextGetData(context);

    if (srcData) {
      // We have drawn the image as an RGBA image with 8 bitsPerComponent and hence can safely input
      // a pixel format of type kCVPixelFormatType_32RGBA for conversion by vImage.
      pixelDataToReturn = [MPPPixelDataUtils rgbPixelDataFromPixelData:srcData
                                                             withWidth:width
                                                                height:height
                                                                stride:bytesPerRow
                                                     pixelBufferFormat:kCVPixelFormatType_32RGBA
                                                                 error:error];
    }

    CGContextRelease(context);
  }

  CGColorSpaceRelease(colorSpace);

  std::unique_ptr<ImageFrame> imageFrame = absl::make_unique<ImageFrame>(
      mediapipe::ImageFormat::SRGB, (int)width, (int)height, (int)bytesPerRow,
      static_cast<uint8 *>(pixelDataToReturn),
      /*deleter=*/free);

  return imageFrame;
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
  uint8_t *pixelData = nil;

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

- (std::unique_ptr<ImageFrame>)imageFrameWithError:(NSError **)error {
  uint8_t *pixelData = NULL;

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

template <typename T>
const T& GetContent(const Packet& packet) {
  RaisePyErrorIfNotOk(packet.ValidateAsType<T>());
  return packet.Get<T>();
}

+ (MPPImage *)imageWithPacket:(<mediapipe::Packet &>)packet error:(NSError **)error {
   absl::Status packetValidationStatus = packet.ValidateAsType<Image>(packet);
   if(![MPPCommonUtils checkCppError:packetValidationStatus error:error]) {
    return nil;
   }
   const mediapipe::ImageFrame& imageFrame = packet.Get<Image>().GetImageFrameSharedPtr().get();

   


}

@end
