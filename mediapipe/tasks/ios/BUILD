# Copyright 2023 The MediaPipe Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load(
    "//mediapipe/tasks/ios:ios.bzl",
    "MPP_TASK_MINIMUM_OS_VERSION",
    "strip_api_include_path_prefix",
)
load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_static_xcframework",
    "apple_static_library",
)

package(default_visibility = ["//visibility:public"])

licenses(["notice"])

strip_api_include_path_prefix(
    name = "strip_api_include_path",
    hdr_labels = [
        "//mediapipe/tasks/ios/common:sources/MPPCommon.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPCategory.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPClassificationResult.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPEmbedding.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPEmbeddingResult.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPDetection.h",
        "//mediapipe/tasks/ios/core:sources/MPPBaseOptions.h",
        "//mediapipe/tasks/ios/core:sources/MPPTaskOptions.h",
        "//mediapipe/tasks/ios/core:sources/MPPTaskResult.h",
        "//mediapipe/tasks/ios/text/text_classifier:sources/MPPTextClassifier.h",
        "//mediapipe/tasks/ios/text/text_classifier:sources/MPPTextClassifierOptions.h",
        "//mediapipe/tasks/ios/text/text_classifier:sources/MPPTextClassifierResult.h",
        "//mediapipe/tasks/ios/text/text_embedder:sources/MPPTextEmbedder.h",
        "//mediapipe/tasks/ios/text/text_embedder:sources/MPPTextEmbedderOptions.h",
        "//mediapipe/tasks/ios/text/text_embedder:sources/MPPTextEmbedderResult.h",
        "//mediapipe/tasks/ios/vision/core:sources/MPPImage.h",
        "//mediapipe/tasks/ios/vision/image_classifier:sources/MPPImageClassifier.h",
        "//mediapipe/tasks/ios/vision/image_classifier:sources/MPPImageClassifierOptions.h",
        "//mediapipe/tasks/ios/vision/image_classifier:sources/MPPImageClassifierResult.h",
        "//mediapipe/tasks/ios/vision/object_detector:sources/MPPObjectDetector.h",
        "//mediapipe/tasks/ios/vision/object_detector:sources/MPPObjectDetectorOptions.h",
        "//mediapipe/tasks/ios/vision/object_detector:sources/MPPObjectDetectionResult.h",
    ],
)

apple_static_xcframework(
    name = "MediaPipeTaskVision_framework",
    public_hdrs = [
        ":MPPBaseOptions.h",
        ":MPPCategory.h",
        ":MPPClassificationResult.h",
        ":MPPDetection.h",
        ":MPPCommon.h",
        ":MPPTaskOptions.h",
        ":MPPTaskResult.h",
        ":MPPImage.h",
        ":MPPImageClassifier.h",
        ":MPPImageClassifierOptions.h",
        ":MPPImageClassifierResult.h",
        ":MPPObjectDetector.h",
        ":MPPObjectDetectorOptions.h",
        ":MPPObjectDetectionResult.h",
    ],
    bundle_name = "MediaPipeTaskVision",
    ios = {
        "simulator" : ["arm64", "x86_64"],
        "device" : ["arm64"],
    },
    minimum_os_versions = {
        "ios": MPP_TASK_MINIMUM_OS_VERSION,
    },
    deps = [
        "//mediapipe/tasks/ios/vision/image_classifier:MPPImageClassifier",
        "//mediapipe/tasks/ios/vision/object_detector:MPPObjectDetector",
        "@org_tensorflow//third_party/icu/data:conversion_data",
    ],
)

