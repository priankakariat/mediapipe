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

#import "mediapipe/tasks/ios/test/vision/utils/sources/MPPImage+TestUtils.h"

namespace {
  static void FreeRefConReleaseCallback(void *refCon, const void *baseAddress) { delete[] refCon; }
}

// TODO: Remove this category after all tests are migrated to the new methods.
@interface UIImage (FileUtils)

+ (nullable UIImage *)imageFromBundleWithClass:(Class)classObject
                                      fileName:(NSString *)name
                                        ofType:(NSString *)type;

@end

@implementation UIImage (FileUtils)

+ (nullable UIImage *)imageFromBundleWithClass:(Class)classObject
                                      fileName:(NSString *)name
                                        ofType:(NSString *)type {
  NSString *imagePath = [[NSBundle bundleForClass:classObject] pathForResource:name ofType:type];
  if (!imagePath) return nil;

  return [[UIImage alloc] initWithContentsOfFile:imagePath];
}

- (CVPixelBufferRef)pixelBufferWithFormat:(OSType)pixelBufferFormat {
  if (!self.CGImage) {
    return NULL;
  }

  size_t width = CGImageGetWidth(self.CGImage);
  size_t height = CGImageGetHeight(self.CGImage);

  NSInteger bitsPerComponent = 8;
  NSInteger channelCount = 4;
  size_t bytesPerRow = channelCount * width;
  
  NSLog(@"Width %d Height %d", width, height);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  // iOS infers bytesPerRow if it is set to 0.
  // See https://developer.apple.com/documentation/coregraphics/1455939-cgbitmapcontextcreate
  // But for segmentation test image, this was not the case.
  // Hence setting it to the value of channelCount*width.
  // kCGImageAlphaPremultipliedLast specifies that Alpha will always be next to B and the R, G, B
  // values will be pre multiplied with alpha. Images with alpha != 255 are stored with the R, G, B
  // values premultiplied with alpha by iOS. Hence `kCGImageAlphaPremultipliedLast` ensures all
  // kinds of images (alpha from 0 to 255) are correctly accounted for by iOS.
  // kCGBitmapByteOrder32Big specifies that R will be stored before B.
  // In combination they signify a pixelFormat of kCVPixelFormatType32RGBA.
  
  CGBitmapInfo bitMapinfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
  switch (pixelBufferFormat) {
    case kCVPixelFormatType_32BGRA: {
      bitMapinfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
      break;
    }
    case kCVPixelFormatType_32RGBA:
      break;
    default:
      return NULL;
  }

  CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow,
                                               colorSpace, bitMapinfo);

  void *copiedData = NULL; 
  if (context) {
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    void *srcData = CGBitmapContextGetData(context);
      
    if (srcData) {
       copiedData = malloc(height * bytesPerRow);
       NSLog(@"zbefpre copy %s", copiedData);
       memcpy(copiedData, srcData, sizeof(UInt8) * height * bytesPerRow);
        // memcpy(copiedData, srcData, sizeof(uint8_t) * height * bytesPerRow);
      //  NSLog(@"after copy src %d", UInt8*(srcData)[0]);
      //  NSLog(@"after copy %d", UInt8*(copiedData)[0]);
    }

    CGContextRelease(context);
  }

  CGColorSpaceRelease(colorSpace);

  CVPixelBufferRef outputBuffer = nil;

  NSLog(@"abefore create");

  if (copiedData) {
    NSLog(@"Copied data present");
  }
    NSLog(@"abefore create width %d", width);

  CVReturn returnVal = CVPixelBufferCreateWithBytes(NULL, width, height,
                                   kCVPixelFormatType_32BGRA, copiedData, bytesPerRow,
                                   NULL,
                                   NULL, NULL, &outputBuffer);
  
  CVPixelBufferLockBaseAddress(outputBuffer, 0);
  if(returnVal == kCVReturnSuccess) {
    NSLog(@"after create"); 
    NSLog(@"After Width %d", CVPixelBufferGetWidth(outputBuffer));     
    NSLog(@"Copied data %p Pixel Base %p", copiedData, CVPixelBufferGetBaseAddress(outputBuffer));                             
    return outputBuffer;                               
  }

  CVPixelBufferUnlockBaseAddress(outputBuffer, 0);

  
  // NSLog(@"after create fail %d", returnVal);                               
  return NULL;
}

@end

@implementation MPPImage (TestUtils)

+ (MPPImage *)imageWithFileInfo:(MPPFileInfo *)fileInfo {
  if (!fileInfo.path) return nil;

  UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileInfo.path];

  if (!image) return nil;

  return [[MPPImage alloc] initWithUIImage:image error:nil];
}

+ (MPPImage *)imageWithFileInfo:(MPPFileInfo *)fileInfo
                    orientation:(UIImageOrientation)orientation {
  if (!fileInfo.path) return nil;

  UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileInfo.path];

  if (!image) return nil;

  return [[MPPImage alloc] initWithUIImage:image orientation:orientation error:nil];
}

+ (MPPImage *)imageOfPixelBufferSourceTypeWithFileInfo:(MPPFileInfo *)fileInfo pixelBufferFormatType:(OSType)pixelBufferFormatType {
  if (!fileInfo.path) return nil;

  UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileInfo.path];

  if (!image) return nil;
  
  CVPixelBufferRef pixelBuffer;

  switch (pixelBufferFormatType) {
    case kCVPixelFormatType_32BGRA: {
      pixelBuffer = [image pixelBufferWithFormat:pixelBufferFormatType];
      break;
    }
    case kCVPixelFormatType_32RGBA: {
      NSLog(@"Enter whole 1");
      pixelBuffer = [image pixelBufferWithFormat:pixelBufferFormatType];
      break;
    }
    default:
      return NULL;
  }

  NSLog(@"After pixel buffer %p", CVPixelBufferGetBaseAddress(pixelBuffer));
  // if (!pixelBuffer) {
  //   return NULL;
  // }

  NSLog(@"Before mpimage");

  MPPImage *mpImage = [[MPPImage alloc] initWithPixelBuffer:pixelBuffer error:nil];
  NSLog(@"Done mpimage");
  CVPixelBufferRelease(pixelBuffer);

  CVPixelBufferLockBaseAddress(mpImage.pixelBuffer, 0);
    NSLog(@"Final Base %p", CVPixelBufferGetBaseAddress(mpImage.pixelBuffer));
  CVPixelBufferUnlockBaseAddress(mpImage.pixelBuffer, 0);
  return mpImage;

}

// TODO: Remove after all tests are migrated
+ (nullable MPPImage *)imageFromBundleWithClass:(Class)classObject
                                       fileName:(NSString *)name
                                         ofType:(NSString *)type {
  UIImage *image = [UIImage imageFromBundleWithClass:classObject fileName:name ofType:type];

  return [[MPPImage alloc] initWithUIImage:image error:nil];
}

// TODO: Remove after all tests are migrated
+ (nullable MPPImage *)imageFromBundleWithClass:(Class)classObject
                                       fileName:(NSString *)name
                                         ofType:(NSString *)type
                                    orientation:(UIImageOrientation)imageOrientation {
  UIImage *image = [UIImage imageFromBundleWithClass:classObject fileName:name ofType:type];

  return [[MPPImage alloc] initWithUIImage:image orientation:imageOrientation error:nil];
}

@end
