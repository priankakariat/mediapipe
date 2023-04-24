# Copyright 2022 The MediaPipe Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Utilities for defining TensorFlow Lite Support Bazel dependencies."""

OPEN_CV_XCFRAMEWORK_FILE_LIST = [
"opencv2.xcframework/Info.plist",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Resources/Info.plist",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Moments.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfRect2d.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfFloat4.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint2i.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/video/tracking.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/video/legacy/constants_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/video/background_segm.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/video/video.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Double3.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfByte.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Range.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Core.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Size2f.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/world.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv2-Swift.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/fast_math.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda_types.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/check.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cv_cpu_dispatch.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utility.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/softfloat.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cv_cpu_helper.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvstd.inl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/msa_macros.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_rvv.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/simd_utils.impl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_wasm.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_neon.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx512.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_vsx.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/interface.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_msa.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_cpp.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_forward.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse_em.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/hal.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/async.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/bufferpool.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/ovx.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/optim.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/va_intel.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvdef.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/warp.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/filters.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/dynamic_smem.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/reduce.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/utility.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/warp_shuffle.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/border_interpolate.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/transform.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/saturate_cast.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/vec_math.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/functional.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/limits.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/type_traits.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/vec_distance.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/block.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce_key_val.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/color_detail.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/type_traits_detail.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/vec_distance_detail.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/transform_detail.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/emulation.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/color.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/datamov_utils.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/funcattrib.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/common.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/vec_traits.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/simd_functions.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/warp_reduce.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/scan.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/traits.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opengl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvstd_wrapper.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda.inl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/eigen.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda_stream_accessor.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/ocl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/affine.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/mat.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/logger.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.impl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/logtag.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/filesystem.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/tls.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/trace.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/instrumentation.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/logger.defines.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/quaternion.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/neon_utils.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/sse_utils.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/version.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/opencl_info.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_definitions.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_hsa_extension.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdblas.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_20.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core_wrappers.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl_wrappers.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdfft.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdblas.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core_wrappers.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl_wrappers.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdfft.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/ocl_defs.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/opencl_svm.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/ocl_genbase.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/detail/async_promise.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/detail/exception_ptr.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/simd_intrinsics.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/matx.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/directx.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/base.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/operations.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/vsx_utils.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/persistence.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/mat.inl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/types_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvstd.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/types.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/bindings_utils.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/quaternion.inl.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/saturate.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/core_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/core.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Converters.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Mat.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Algorithm.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Mat+Converters.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/ByteVector.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/imgproc.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/imgproc_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/hal/interface.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/hal/hal.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/detail/gcgraph.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/types_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/highgui.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/features2d.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point2f.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/KeyPoint.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Rect2f.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Float6.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfKeyPoint.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfRect2i.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/FloatVector.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/TermCriteria.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv2.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Int4.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfDMatch.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Scalar.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point3f.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfDouble.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/IntVector.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/RotatedRect.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfFloat6.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/cvconfig.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/DoubleVector.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Size2d.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MinMaxLocResult.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfInt4.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Rect2i.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point2i.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint3.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfRotatedRect.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/DMatch.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/TickMeter.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point3i.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/video.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/ios.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/legacy/constants_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/macosx.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/CvType.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/CVObjcUtil.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Size2i.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Float4.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/registry.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/cap_ios.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/legacy/constants_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/videoio.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/videoio_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfFloat.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Rect2d.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint2f.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point2d.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/highgui/highgui.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/highgui/highgui_c.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Double2.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/CvCamera2.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/features2d/hal/interface.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/features2d/features2d.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv_modules.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core.hpp",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfInt.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/ArrayUtil.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint3f.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point3d.h",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.swiftinterface",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.abi.json",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.private.swiftinterface",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.swiftdoc",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/Project/x86_64-apple-ios-simulator.swiftsourceinfo",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.swiftinterface",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.private.swiftinterface",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.swiftdoc",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.abi.json",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/module.modulemap",
"opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/opencv2",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Resources/Info.plist",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Moments.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfRect2d.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfFloat4.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint2i.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/tracking.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/legacy/constants_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/background_segm.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/video.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Double3.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfByte.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Range.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Core.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Size2f.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/world.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv2-Swift.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/fast_math.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda_types.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/check.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cv_cpu_dispatch.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utility.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/softfloat.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cv_cpu_helper.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvstd.inl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/msa_macros.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_rvv.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/simd_utils.impl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_wasm.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_neon.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx512.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_vsx.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/interface.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_msa.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_cpp.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_forward.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse_em.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/hal.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/async.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/bufferpool.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/ovx.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/optim.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/va_intel.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvdef.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/warp.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/filters.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/dynamic_smem.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/reduce.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/utility.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/warp_shuffle.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/border_interpolate.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/transform.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/saturate_cast.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/vec_math.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/functional.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/limits.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/type_traits.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/vec_distance.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/block.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce_key_val.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/color_detail.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/type_traits_detail.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/vec_distance_detail.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/transform_detail.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/emulation.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/color.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/datamov_utils.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/funcattrib.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/common.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/vec_traits.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/simd_functions.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/warp_reduce.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/scan.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/traits.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opengl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvstd_wrapper.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda.inl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/eigen.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda_stream_accessor.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/ocl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/affine.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/mat.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/logger.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.impl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/logtag.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/filesystem.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/tls.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/trace.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/instrumentation.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/logger.defines.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/quaternion.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/neon_utils.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/sse_utils.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/version.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/opencl_info.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_definitions.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_hsa_extension.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdblas.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_20.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core_wrappers.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl_wrappers.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdfft.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdblas.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core_wrappers.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl_wrappers.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdfft.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/ocl_defs.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/opencl_svm.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/ocl_genbase.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/detail/async_promise.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/detail/exception_ptr.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/simd_intrinsics.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/matx.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/directx.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/base.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/operations.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/vsx_utils.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/persistence.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/mat.inl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/types_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvstd.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/types.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/bindings_utils.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/quaternion.inl.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/saturate.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/core_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/core.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Converters.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Mat.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Algorithm.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Mat+Converters.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/ByteVector.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/imgproc.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/imgproc_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/hal/interface.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/hal/hal.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/detail/gcgraph.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/types_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/highgui.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/features2d.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point2f.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/KeyPoint.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Rect2f.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Float6.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfKeyPoint.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfRect2i.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/FloatVector.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/TermCriteria.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv2.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Int4.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfDMatch.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Scalar.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point3f.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfDouble.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/IntVector.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/RotatedRect.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfFloat6.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/cvconfig.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/DoubleVector.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Size2d.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MinMaxLocResult.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfInt4.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Rect2i.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point2i.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint3.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfRotatedRect.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/DMatch.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/TickMeter.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point3i.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/ios.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/legacy/constants_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/macosx.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/CvType.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/CVObjcUtil.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Size2i.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Float4.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/registry.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/cap_ios.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/legacy/constants_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/videoio.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/videoio_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfFloat.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Rect2d.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint2f.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point2d.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/highgui/highgui.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/highgui/highgui_c.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Double2.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/CvCamera2.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/features2d/hal/interface.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/features2d/features2d.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv_modules.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core.hpp",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfInt.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/ArrayUtil.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint3f.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point3d.h",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.swiftinterface",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.swiftdoc",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.abi.json",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.private.swiftinterface",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/module.modulemap",
"opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/opencv2",
]
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Double3.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfByte.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Range.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Core.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Size2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/world.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv2-Swift.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/fast_math.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda_types.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/check.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cv_cpu_dispatch.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utility.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/softfloat.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cv_cpu_helper.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvstd.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/msa_macros.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_rvv.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/simd_utils.impl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_wasm.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_neon.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx512.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_vsx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/interface.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_msa.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_cpp.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_forward.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse_em.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/hal/hal.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/async.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/bufferpool.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/ovx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/optim.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/va_intel.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvdef.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/warp.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/filters.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/dynamic_smem.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/reduce.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/utility.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/warp_shuffle.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/border_interpolate.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/transform.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/saturate_cast.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/vec_math.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/functional.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/limits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/type_traits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/vec_distance.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/block.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce_key_val.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/color_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/type_traits_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/vec_distance_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/detail/transform_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/emulation.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/color.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/datamov_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/funcattrib.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/common.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/vec_traits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/simd_functions.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/warp_reduce.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda/scan.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/traits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opengl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvstd_wrapper.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/eigen.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda_stream_accessor.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/ocl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cuda.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/affine.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/mat.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/logger.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.impl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/logtag.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/filesystem.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/tls.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/trace.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/instrumentation.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/utils/logger.defines.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/quaternion.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/neon_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/sse_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/version.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/opencl_info.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_definitions.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_hsa_extension.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdblas.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_20.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdfft.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdblas.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdfft.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/ocl_defs.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/opencl/opencl_svm.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/ocl_genbase.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/detail/async_promise.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/detail/exception_ptr.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/simd_intrinsics.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/matx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/directx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/base.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/operations.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/vsx_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/persistence.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/mat.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/types_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/cvstd.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/types.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/bindings_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/quaternion.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/saturate.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/core_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core/core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Converters.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Mat.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Algorithm.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Mat+Converters.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/ByteVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/imgproc.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/imgproc_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/hal/interface.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/hal/hal.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/detail/gcgraph.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgproc/types_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/highgui.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/features2d.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/KeyPoint.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Rect2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Float6.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfKeyPoint.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfRect2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/FloatVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/TermCriteria.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv2.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Int4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfDMatch.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Scalar.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point3f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfDouble.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/IntVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/RotatedRect.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfFloat6.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/cvconfig.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/DoubleVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Size2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MinMaxLocResult.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfInt4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Rect2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint3.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfRotatedRect.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/DMatch.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/TickMeter.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point3i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/video.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/ios.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/legacy/constants_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/macosx.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/CvType.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/CVObjcUtil.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Size2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/imgcodecs.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Float4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/registry.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/cap_ios.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/legacy/constants_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/videoio.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio/videoio_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfFloat.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Rect2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/highgui/highgui.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/highgui/highgui_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Double2.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/CvCamera2.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/features2d/hal/interface.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/features2d/features2d.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/videoio.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/opencv_modules.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfInt.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/ArrayUtil.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/MatOfPoint3f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/Point3d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.swiftinterface
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.abi.json
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.private.swiftinterface
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.swiftdoc
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/Project/arm64-apple-ios-simulator.swiftsourceinfo
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/Project/x86_64-apple-ios-simulator.swiftsourceinfo
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.swiftinterface
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.private.swiftinterface
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios-simulator.swiftdoc
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/x86_64-apple-ios-simulator.abi.json
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Modules/module.modulemap
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/opencv2
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Resources/Info.plist
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Moments.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfRect2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfFloat4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/tracking.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/legacy/constants_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/background_segm.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video/video.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Double3.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfByte.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Range.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Core.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Size2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/world.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv2-Swift.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/fast_math.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda_types.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/check.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cv_cpu_dispatch.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utility.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/softfloat.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cv_cpu_helper.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvstd.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/msa_macros.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_rvv.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/simd_utils.impl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_wasm.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_neon.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_avx512.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_vsx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/interface.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_msa.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_cpp.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_forward.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/intrin_sse_em.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/hal/hal.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/async.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/bufferpool.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/ovx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/optim.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/va_intel.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvdef.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/warp.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/filters.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/dynamic_smem.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/reduce.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/utility.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/warp_shuffle.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/border_interpolate.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/transform.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/saturate_cast.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/vec_math.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/functional.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/limits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/type_traits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/vec_distance.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/block.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/reduce_key_val.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/color_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/type_traits_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/vec_distance_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/detail/transform_detail.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/emulation.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/color.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/datamov_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/funcattrib.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/common.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/vec_traits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/simd_functions.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/warp_reduce.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda/scan.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/traits.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opengl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvstd_wrapper.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/eigen.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda_stream_accessor.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/ocl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cuda.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/affine.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/mat.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/logger.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/allocator_stats.impl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/logtag.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/filesystem.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/tls.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/trace.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/instrumentation.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/utils/logger.defines.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/quaternion.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/neon_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/sse_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/version.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/opencl_info.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_definitions.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_hsa_extension.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdblas.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_svm_20.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_core_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_gl_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/opencl_clamdfft.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdblas.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_core_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_gl_wrappers.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/runtime/autogenerated/opencl_clamdfft.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/ocl_defs.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/opencl/opencl_svm.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/ocl_genbase.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/detail/async_promise.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/detail/exception_ptr.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/simd_intrinsics.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/matx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/directx.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/base.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/operations.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/vsx_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/persistence.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/mat.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/types_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/cvstd.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/types.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/bindings_utils.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/quaternion.inl.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/saturate.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/core_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core/core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Converters.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Mat.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Algorithm.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Mat+Converters.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/ByteVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/imgproc.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/imgproc_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/hal/interface.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/hal/hal.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/detail/gcgraph.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgproc/types_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/highgui.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/features2d.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/KeyPoint.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Rect2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Float6.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfKeyPoint.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfRect2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/FloatVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/TermCriteria.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv2.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Int4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfDMatch.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Scalar.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point3f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfDouble.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/IntVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/RotatedRect.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfFloat6.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/cvconfig.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/DoubleVector.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Size2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MinMaxLocResult.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfInt4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Rect2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint3.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfRotatedRect.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/DMatch.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/TickMeter.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point3i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/video.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/ios.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/legacy/constants_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/macosx.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs/imgcodecs_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/CvType.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/CVObjcUtil.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Size2i.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/imgcodecs.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Float4.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/registry.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/cap_ios.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/legacy/constants_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/videoio.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio/videoio_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfFloat.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Rect2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint2f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point2d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/highgui/highgui.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/highgui/highgui_c.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Double2.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/CvCamera2.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/features2d/hal/interface.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/features2d/features2d.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/videoio.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/opencv_modules.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/core.hpp
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfInt.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/ArrayUtil.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/MatOfPoint3f.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/Point3d.h
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.swiftinterface
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.swiftdoc
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/Project/arm64-apple-ios.swiftsourceinfo
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.abi.json
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/opencv2.swiftmodule/arm64-apple-ios.private.swiftinterface
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Modules/module.modulemap
# /Users/priankakariat/Desktop/opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/opencv2

