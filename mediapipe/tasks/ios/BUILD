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
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_static_framework",
)

load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_static_xcframework",
)

package(default_visibility = ["//mediapipe/tasks:internal"])

licenses(["notice"])

config_setting(
    name = "ios_static_framework",
    define_values = {
        "IOS_STATIC_FRAMEWORK": "1",
    },
    visibility = ["//visibility:public"],
)

strip_api_include_path_prefix(
    name = "strip_api_include_path",
    hdr_labels = [
        "//mediapipe/tasks/ios/common:sources/MPPCommon.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPCategory.h",
        "//mediapipe/tasks/ios/components/containers:sources/MPPClassificationResult.h",
        "//mediapipe/tasks/ios/core:sources/MPPBaseOptions.h",
        "//mediapipe/tasks/ios/core:sources/MPPTaskOptions.h",
        "//mediapipe/tasks/ios/core:sources/MPPTaskResult.h",
        "//mediapipe/tasks/ios/text/text_classifier:sources/MPPTextClassifier.h",
        "//mediapipe/tasks/ios/text/text_classifier:sources/MPPTextClassifierOptions.h",
        "//mediapipe/tasks/ios/text/text_classifier:sources/MPPTextClassifierResult.h",
    ],
)

# apple_static_xcframework(
#     name = "MediaPipeTaskText_framework",
#     public_hdrs = [
#         ":MPPBaseOptions.h",
#         ":MPPCategory.h",
#         ":MPPClassificationResult.h",
#         ":MPPCommon.h",
#         ":MPPTaskOptions.h",
#         ":MPPTaskResult.h",
#         ":MPPTextClassifier.h",
#         ":MPPTextClassifierOptions.h",
#         ":MPPTextClassifierResult.h",
#     ],
#     bundle_name = "MediaPipeTaskText",
#     minimum_os_versions = {
#         "ios":MPP_TASK_MINIMUM_OS_VERSION,
#     },
#     deps = [
#         "//mediapipe/tasks/ios/text:MediaPipeTaskText",
#     ],
# )

ios_static_framework(
    name = "MediaPipeTaskText_framework",
    hdrs = [
        ":MPPBaseOptions.h",
        ":MPPCategory.h",
        ":MPPClassificationResult.h",
        ":MPPCommon.h",
        ":MPPTaskOptions.h",
        ":MPPTaskResult.h",
        ":MPPTextClassifier.h",
        ":MPPTextClassifierOptions.h",
        ":MPPTextClassifierResult.h",
    ],
    bundle_name = "MediaPipeTaskText",
    minimum_os_version = MPP_TASK_MINIMUM_OS_VERSION,
    # minimum_os_versions = {
    #     "ios":MPP_TASK_MINIMUM_OS_VERSION,
    # },
    deps = [
        "//mediapipe/tasks/ios/text/text_classifier:MPPTextClassifier",
    ],
)
