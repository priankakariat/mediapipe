/* Copyright 2021 The TensorFlow Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ==============================================================================*/

#import "mediapipe/tasks/ios/vision/utils/sources/MPPImage+Utils.h"

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"

#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>

@interface MPPCVPixelBufferUtils : NSObject

+ (uint8_t *)pixelDataFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer error:(NSError **)error;

@end

@interface MPPCGImageUtils : NSObject

+ (UInt8 *_Nullable)pixelDataFromCGImage:(CGImageRef)cgImage error:(NSError **)error;

@end


@interface UIImage (RawPixelDataUtils)

@property(nonatomic, readonly) CGSize bitmapSize;

- (uint8_t *)pixelDataWithError:(NSError **)error;

@end

@implementation MPPCVPixelBufferUtils

+ (uint8_t *)rgbPixelDatafromPixelData:(uint8_t *)pixelData
                                   withWidth:(size_t)width
                                      height:(size_t)height
                                      stride:(size_t)stride
                           pixelBufferFormat:(OSType)pixelBufferFormatType
                                       error:(NSError **)error {
  NSInteger destinationChannelCount = 3;
  size_t destinationBytesPerRow = width * destinationChannelCount;

  uint8_t *destPixelBufferAddress =
      [MPPCommonUtils mallocWithSize:sizeof(uint8_t) * height * destinationBytesPerRow error:error];

  if (!destPixelBufferAddress) {
    return NULL;
  }

  vImage_Buffer srcBuffer = {.data = pixelData,
                             .height = (vImagePixelCount)height,
                             .width = (vImagePixelCount)width,
                             .rowBytes = stride};

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
                               withCode:MPPErrorCodeInvalidArgumentError
                            description:@"Invalid source pixel buffer format. Expecting one of "
                                        @"kCVPixelFormatType_32RGBA, kCVPixelFormatType_32BGRA, "
                                        @"kCVPixelFormatType_32ARGB"];

      free(destPixelBufferAddress);
      return NULL;
    }
  }

  if (convertError != kvImageNoError) {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPErrorCodeImageProcessingError
                          description:@"Image format conversion failed."];

    free(destPixelBufferAddress);
    return NULL;
  }

  return destPixelBufferAddress;
}

+ (uint8_t *)rgbPixelDatafromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                           error:(NSError **)error {
  CVPixelBufferLockBaseAddress(pixelBuffer, 0);

  uint8_t *rgbPixelData = [MPPCVPixelBufferUtils
      rgbPixelDatafromCVPixelBuffer:CVPixelBufferGetBaseAddress(pixelBuffer)
                            withWidth:CVPixelBufferGetWidth(pixelBuffer)
                               height:CVPixelBufferGetHeight(pixelBuffer)
                               stride:CVPixelBufferGetBytesPerRow(pixelBuffer)
                    pixelBufferFormat:CVPixelBufferGetPixelFormatType(pixelBuffer)
                                error:error];

  CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

  return rgbPixelData;
}

+ (nullable uint8_t *)pixelDataFromCVPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                        error:(NSError **)error {
  uint8_t *pixelData = NULL;

  OSType pixelBufferFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);

  switch (pixelBufferFormat) {
    case kCVPixelFormatType_32BGRA: {
      pixelData = [MPPCVPixelBufferUtils rgbPixelDatafromCVPixelBuffer:pixelBuffer error:error];
      break;
    }
    default: {
      [MPPCommonUtils createCustomError:error
                               withCode:MPPErrorCodeInvalidArgumentError
                            description:@"Unsupported pixel format for CVPixelBuffer. Supported "
                                        @"pixel format types are kCVPixelFormatType_32BGRA"];
    }
  }

  return pixelData;
}

@end

@implementation MPPCGImageUtils

+ (UInt8 *_Nullable)pixelDataFromCGImage:(CGImageRef)cgImage error:(NSError **)error {
  size_t width = CGImageGetWidth(cgImage);
  size_t height = CGImageGetHeight(cgImage);

  NSInteger bitsPerComponent = 8;
  NSInteger channelCount = 4;
  UInt8 *pixel_data_to_return = NULL;

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
    uint8_t *srcData = CGBitmapContextGetData(context);

    if (srcData) {
      // We have drawn the image as an RGBA image with 8 bitsPerComponent and hence can safely input
      // a pixel format of type kCVPixelFormatType_32RGBA for conversion by vImage.
      pixel_data_to_return =
          [MPPCVPixelBufferUtils rgbImageDataFromImageData:srcData
                                                       withWidth:width
                                                          height:height
                                                          stride:bytesPerRow
                                               pixelBufferFormat:kCVPixelFormatType_32RGBA
                                                           error:error];
    }

    CGContextRelease(context);
  }

  CGColorSpaceRelease(colorSpace);

  return pixel_data_to_return;
}

@end

@implementation UIImage (RawPixelDataUtils)

- (uint8_t *)pixelDataFromCIImage:(NSError **)error {

  uint8_t *pixelData = NULL;

  if (self.ciImage.pixelBuffer) {
    pixelData = [MPPCVPixelBufferUtils rgbPixelDatafromCVPixelBuffer:ciImage.pixelBuffer
                                                                  error:error];

  } else if (self.ciImage.CGImage) {
    pixelData = [MPPCGImageUtils pixelDataFromCGImage:self.ciImage.CGImage error:error];
  } else {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPErrorCodeInvalidArgumentError
                          description:@"CIImage should have CGImage or CVPixelBuffer info."];
  }

  return pixelData;

}

- (uint8_t *)pixelDataWithError:(NSError **)error {
  uint8_t *pixelData = nil;

  if (self.CGImage) {
    pixelData = [MPPCGImageUtils pixelDataFromCGImage:self.CGImage error:error];
  } else if (self.CIImage) {
    pixelData = [self pixelDataFromCIImageWithError:error];
  } else {
    [MPPCommonUtils createCustomError:error
                             withCode:MPPErrorCodeInvalidArgumentError
                          description:@"UIImage should be initialized from"
                                       " CIImage or CGImage."];
  }

  return pixelData;
}

- (CGSize)bitmapSize {
  CGFloat width = 0;
  CGFloat height = 0;

  if (self.CGImage) {
    width = CGImageGetWidth(self.CGImage);
    height = CGImageGetHeight(self.CGImage);
  } else if (self.CIImage.pixelBuffer) {
    width = CVPixelBufferGetWidth(self.CIImage.pixelBuffer);
    height = CVPixelBufferGetHeight(self.CIImage.pixelBuffer);
  } else if (self.CIImage.CGImage) {
    width = CGImageGetWidth(self.CIImage.CGImage);
    height = CGImageGetHeight(self.CIImage.CGImage);
  }
  return CGSizeMake(width, height);
}
@end

@implementation MPPImage (Utils)

- (nullable uint8_t *)pixelDataWithError:(NSError **)error {
  uint8_t *pixelData = NULL;

  switch (self.imageSourceType) {
    case MPPImageSourceTypeSampleBuffer: {
      CVPixelBufferRef sampleImagePixelBuffer = CMSampleBufferGetImageBuffer(self.sampleBuffer);
      pixelData = [MPPCVPixelBufferUtils pixelDataFromCVPixelBuffer:sampleImagePixelBuffer error:error];
      break;
    }
    case MPPImageSourceTypePixelBuffer: {
      pixelData = [MPPCVPixelBufferUtils pixelDataFromCVPixelBuffer:self.pixelBuffer error:error];
      break;
    }
    case MPPImageSourceTypeImage: {
      pixelData = [self.image pixelDataWithError:error];
      break;
    }
    default:
      [MPPCommonUtils createCustomError:error
                               withCode:MPPErrorCodeInvalidArgumentError
                            description:@"Invalid source type for MPPImage."];
  }

  return pixelData;
}

- (CGSize)bitmapSize {
  CGFloat width = 0;
  CGFloat height = 0;

  switch (self.imageSourceType) {
    case MPPImageSourceTypeSampleBuffer: {
      CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(self.sampleBuffer);
      width = CVPixelBufferGetWidth(pixelBuffer);
      height = CVPixelBufferGetHeight(pixelBuffer);
      break;
    }
    case MPPImageSourceTypePixelBuffer: {
      width = CVPixelBufferGetWidth(self.pixelBuffer);
      height = CVPixelBufferGetHeight(self.pixelBuffer);
      break;
    }
    case MPPImageSourceTypeImage: {
      width = self.image.bitmapSize.width;
      height = self.image.bitmapSize.height;
      break;
    }
    default:
      break;
  }

  return CGSizeMake(width, height);
}

@end
