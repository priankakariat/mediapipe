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

#import "mediapipe/tasks/ios/vision/core/utils/sources/MPPCVPixelBufferUtils.h"

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"

#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>


/// When storing a shared_ptr in a CVPixelBuffer's refcon, this can be
/// used as a CVPixelBufferReleaseBytesCallback. This keeps the data
/// alive while the CVPixelBuffer is in use.
static void ReleaseSharedPtr(void* refcon, const void* base_address) {
  auto ptr = (std::shared_ptr<void>*)refcon;
  free(ptr);
}

@implementation MPPCVPixelBufferUtils
+ (CVPixelBufferRef)pixelBufferWithPixelData:(uint8_t *)pixelData
                                       width:()
                                       error:(NSError **)error {

 CVReturn status = CVPixelBufferCreateWithBytes(
        NULL, width, height, kCVPixelFormatType_OneComponent8, pixelData,
        frame.WidthStep(), ReleaseSharedPtr, holder.get(),
        GetCVPixelBufferAttributesForGlCompatibility(), &pixel_buffer_temp);                                                    

}

absl::StatusOr<CFHolder<CVPixelBufferRef>> CreateCVPixelBufferForImageFrame(
    std::shared_ptr<mediapipe::ImageFrame> image_frame, bool can_overwrite) {
  CFHolder<CVPixelBufferRef> pixel_buffer;
  const auto& frame = *image_frame;
  void* frame_data =
      const_cast<void*>(reinterpret_cast<const void*>(frame.PixelData()));

  mediapipe::ImageFormat::Format image_format = frame.Format();
  OSType pixel_format = 0;
  CVReturn status;
  switch (image_format) {
    case mediapipe::ImageFormat::SRGBA: {
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

    case mediapipe::ImageFormat::VEC32F4:
      pixel_format = kCVPixelFormatType_128RGBAFloat;
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