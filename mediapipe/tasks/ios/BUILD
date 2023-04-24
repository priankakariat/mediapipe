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
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_static_framework",
)

package(default_visibility = ["//visibility:public"])

licenses(["notice"])

config_setting(
    name = "avoid_linking_graphs",
    define_values = {
        "MEDIAPIPE_AVOID_LINKING_GRAPHS": "1",
    },
    visibility = ["//visibility:public"],
)

OBJC_COMMON_DEPS = [
    "//mediapipe/tasks/ios/core:MPPBaseOptions",
    "//mediapipe/tasks/ios/core:MPPTaskInfo",
    "//mediapipe/tasks/ios/core:MPPTaskOptions",
    "//mediapipe/tasks/ios/core:MPPTaskResult",
    "//mediapipe/tasks/ios/core:MPPTaskRunner",
    "//mediapipe/tasks/ios/components/containers:MPPClassificationResult",
    "//mediapipe/tasks/ios/components/containers:MPPCategory",
    "//mediapipe/tasks/ios/common/utils:MPPCommonUtils",
]

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
        "//mediapipe/tasks/ios/vision/core:sources/MPPRunningMode.h",
        "//mediapipe/tasks/ios/vision/image_classifier:sources/MPPImageClassifier.h",
        "//mediapipe/tasks/ios/vision/image_classifier:sources/MPPImageClassifierOptions.h",
        "//mediapipe/tasks/ios/vision/image_classifier:sources/MPPImageClassifierResult.h",
        "//mediapipe/tasks/ios/vision/object_detector:sources/MPPObjectDetector.h",
        "//mediapipe/tasks/ios/vision/object_detector:sources/MPPObjectDetectorOptions.h",
        "//mediapipe/tasks/ios/vision/object_detector:sources/MPPObjectDetectionResult.h",
    ],
)

apple_static_xcframework(
    name = "MediaPipeTaskText_framework",
    public_hdrs = [
        ":MPPBaseOptions.h",
        ":MPPCategory.h",
        ":MPPClassificationResult.h",
        ":MPPEmbedding.h",
        ":MPPEmbeddingResult.h",
        ":MPPCommon.h",
        ":MPPTaskOptions.h",
        ":MPPTaskResult.h",
        ":MPPTextClassifier.h",
        ":MPPTextClassifierOptions.h",
        ":MPPTextClassifierResult.h",
        ":MPPTextEmbedder.h",
        ":MPPTextEmbedderOptions.h",
        ":MPPTextEmbedderResult.h",
    ],
    bundle_name = "MediaPipeTaskText",
    ios = {
        "simulator" : ["arm64", "x86_64"],
        "device" : ["arm64"],
    },
    minimum_os_versions = {
        "ios": MPP_TASK_MINIMUM_OS_VERSION,
    },
    deps = [
        "//mediapipe/tasks/ios/text/text_classifier:MPPTextClassifier",
        "//mediapipe/tasks/ios/text/text_embedder:MPPTextEmbedder",
    ],
    avoid_deps = OBJC_COMMON_DEPS + [
        "//mediapipe/tasks/cc/vision/image_classifier:image_classifier_graph",
        "//mediapipe/tasks/cc/vision/face_detector:face_detector_graph",
        "//mediapipe/tasks/cc/vision/face_geometry:face_geometry_graph",
        "//mediapipe/tasks/cc/vision/face_landmarker:face_landmarker_graph",
        "//mediapipe/tasks/cc/vision/face_stylizer:face_stylizer_graph",
        "//mediapipe/tasks/cc/vision/gesture_recognizer:gesture_recognizer_graph",
        "//mediapipe/tasks/cc/vision/hand_detector:hand_detector_graph",
        "//mediapipe/tasks/cc/vision/hand_landmarker:hand_landmarker_graph",
        "//mediapipe/tasks/cc/vision/image_embedder:image_embedder_graph",
        "//mediapipe/tasks/cc/vision/image_segmenter:image_segmenter_graph",
        "//mediapipe/tasks/cc/vision/interactive_segmenter:interactive_segmenter_graph",
        "//mediapipe/tasks/cc/vision/object_detector:object_detector_graph",
        "//mediapipe/tasks/cc/vision/pose_detector:pose_detector_graph",
        "//mediapipe/tasks/cc/vision/pose_landmarker:pose_landmarker_graph",
        "//mediapipe/tasks/cc/vision/audio_classifier:audio_classifier_graph",
        "//mediapipe/tasks/cc/vision/audio_embedder:audio_embedder_graph",
        "//mediapipe/tasks/cc/text/text_classifier:text_classifier_graph",
        "//mediapipe/tasks/cc/text/text_embedder:text_embedder_graph",
        "//mediapipe/gpu:metal_shared_resources",
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
        ":MPPRunningMode.h",
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
    ],
    avoid_deps = OBJC_COMMON_DEPS + [
        "//mediapipe/tasks/cc/vision/image_classifier:image_classifier_graph",
        "//mediapipe/tasks/cc/vision/face_detector:face_detector_graph",
        "//mediapipe/tasks/cc/vision/face_geometry:face_geometry_graph",
        "//mediapipe/tasks/cc/vision/face_landmarker:face_landmarker_graph",
        "//mediapipe/tasks/cc/vision/face_stylizer:face_stylizer_graph",
        "//mediapipe/tasks/cc/vision/gesture_recognizer:gesture_recognizer_graph",
        "//mediapipe/tasks/cc/vision/hand_detector:hand_detector_graph",
        "//mediapipe/tasks/cc/vision/hand_landmarker:hand_landmarker_graph",
        "//mediapipe/tasks/cc/vision/image_embedder:image_embedder_graph",
        "//mediapipe/tasks/cc/vision/image_segmenter:image_segmenter_graph",
        "//mediapipe/tasks/cc/vision/interactive_segmenter:interactive_segmenter_graph",
        "//mediapipe/tasks/cc/vision/object_detector:object_detector_graph",
        "//mediapipe/tasks/cc/vision/pose_detector:pose_detector_graph",
        "//mediapipe/tasks/cc/vision/pose_landmarker:pose_landmarker_graph",
        "//mediapipe/tasks/cc/vision/audio_classifier:audio_classifier_graph",
        "//mediapipe/tasks/cc/vision/audio_embedder:audio_embedder_graph",
        "//mediapipe/tasks/cc/text/text_classifier:text_classifier_graph",
        "//mediapipe/tasks/cc/text/text_embedder:text_embedder_graph",
        "@ios_opencv//:OpencvFramework"
    ],
)

# apple_static_library(
#     name = "MediaPipeTaskGraphs_framework",
#     bundle_name = "MediaPipeTaskGraphs",
#     # ios = {
#     #     "simulator" : ["arm64", "x86_64"],
#     #     "device" : ["arm64"],
#     # },
#     minimum_os_versions = {
#         "ios": MPP_TASK_MINIMUM_OS_VERSION,
#     },
#     deps = [
#         "//mediapipe/tasks/cc/vision/image_classifier:image_classifier_graph",
#         "//mediapipe/tasks/cc/vision/object_detector:object_detector_graph",
#         "//mediapipe/tasks/cc/text/text_classifier:text_classifier_graph",
#         "//mediapipe/tasks/cc/text/text_embedder:text_embedder_graph",
#         "@org_tensorflow//third_party/icu/data:conversion_data",
#         "@ios_opencv//:OpencvFramework"
#     ],
# )

apple_static_library(
    name = "MediaPipeTaskGraphs_library",
    # ios = {
    #     "simulator" : ["arm64", "x86_64"],
    #     "device" : ["arm64"],
    # },
    minimum_os_version = MPP_TASK_MINIMUM_OS_VERSION,
    platform_type = "ios",
    deps = [
        "//mediapipe/tasks/cc/vision/image_classifier:image_classifier_graph",
        "//mediapipe/tasks/cc/vision/face_detector:face_detector_graph",
        "//mediapipe/tasks/cc/vision/face_landmarker:face_landmarker_graph",
        "//mediapipe/tasks/cc/vision/face_stylizer:face_stylizer_graph",
        "//mediapipe/tasks/cc/vision/gesture_recognizer:gesture_recognizer_graph",
        "//mediapipe/tasks/cc/vision/hand_detector:hand_detector_graph",
        "//mediapipe/tasks/cc/vision/hand_landmarker:hand_landmarker_graph",
        "//mediapipe/tasks/cc/vision/image_embedder:image_embedder_graph",
        "//mediapipe/tasks/cc/vision/image_segmenter:image_segmenter_graph",
        "//mediapipe/tasks/cc/vision/interactive_segmenter:interactive_segmenter_graph",
        "//mediapipe/tasks/cc/vision/object_detector:object_detector_graph",
        "//mediapipe/tasks/cc/vision/pose_detector:pose_detector_graph",
        "//mediapipe/tasks/cc/vision/pose_landmarker:pose_landmarker_graph",
        "//mediapipe/tasks/cc/audio/audio_classifier:audio_classifier_graph",
        "//mediapipe/tasks/cc/audio/audio_embedder:audio_embedder_graph",
        "//mediapipe/tasks/cc/text/text_classifier:text_classifier_graph",
        "//mediapipe/tasks/cc/text/text_embedder:text_embedder_graph",
        "@org_tensorflow//third_party/icu/data:conversion_data",
        "@ios_opencv//:OpencvFramework"
    ],
    avoid_deps = [
        "@zlib//:zlib",
    ],
)

apple_static_xcframework(
    name = "MediaPipeTaskCommonObjects_framework",
    bundle_name = "MediaPipeTaskCommon",
    ios = {
        "simulator" : ["arm64", "x86_64"],
        "device" : ["arm64"],
    },
    minimum_os_versions = {
        "ios": MPP_TASK_MINIMUM_OS_VERSION,
    },
    avoid_deps = [
        "//mediapipe/gpu:metal_shared_resources",
    ],
    deps = [
        "//mediapipe/tasks/ios/core:MPPBaseOptions",
        "//mediapipe/tasks/ios/core:MPPTaskInfo",
        "//mediapipe/tasks/ios/core:MPPTaskOptions",
        "//mediapipe/tasks/ios/core:MPPTaskResult",
        "//mediapipe/tasks/ios/core:MPPTaskRunner",
        "//mediapipe/tasks/ios/components/containers:MPPClassificationResult",
        "//mediapipe/tasks/ios/components/containers:MPPCategory",
        "//mediapipe/tasks/ios/common/utils:MPPCommonUtils",
    ],
)
