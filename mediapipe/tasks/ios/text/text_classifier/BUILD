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

package(default_visibility = ["//mediapipe/tasks:internal"])

licenses(["notice"])

objc_library(
    name = "MPPTextClassifierOptions",
    srcs = ["sources/MPPTextClassifierOptions.m"],
    hdrs = ["sources/MPPTextClassifierOptions.h"],
    copts = [
        "-ObjC++",
        "-std=c++17",
        "-x objective-c++",
    ],
    deps = [
        "//mediapipe/tasks/ios/core:MPPTaskOptions",
    ],
)

objc_library(
    name = "MPPTextClassifierResult",
    srcs = ["sources/MPPTextClassifierResult.m"],
    hdrs = ["sources/MPPTextClassifierResult.h"],
    copts = [
        "-ObjC++",
        "-std=c++17",
        "-x objective-c++",
    ],
    deps = [
        "//mediapipe/tasks/ios/components/containers:MPPClassificationResult",
        "//mediapipe/tasks/ios/core:MPPTaskResult",
    ],
)

cc_library(
    name = "objc_text_classifier_graph",
    srcs = ["sources/objc_text_classifier_graph.cc"],
    hdrs = ["sources/objc_text_classifier_graph.h"],
    deps = [
        "//mediapipe/calculators/tensor:inference_calculator_cpu",
        "//mediapipe/framework:calculator_cc_proto",
        "//mediapipe/framework:calculator_framework",
        "//mediapipe/framework/api2:builder",
        "//mediapipe/framework/api2:port",
        "//mediapipe/tasks/cc/components/containers/proto:classifications_cc_proto",
        "//mediapipe/tasks/cc/components/processors:classification_postprocessing_graph",
        "//mediapipe/tasks/cc/components/processors:text_preprocessing_graph",
        "//mediapipe/tasks/cc/components/processors/proto:classification_postprocessing_graph_options_cc_proto",
        "//mediapipe/tasks/cc/components/processors/proto:text_preprocessing_graph_options_cc_proto",
        "//mediapipe/tasks/cc/core:model_resources",
        "//mediapipe/tasks/cc/core:model_resources_calculator",
        "//mediapipe/tasks/cc/core:model_task_graph",
        "//mediapipe/tasks/cc/core/proto:model_resources_calculator_cc_proto",
        "//mediapipe/tasks/cc/text/text_classifier/proto:text_classifier_graph_options_cc_proto",
        "@com_google_absl//absl/status",
        "@com_google_absl//absl/status:statusor",
    ],
)

objc_library(
    name = "MPPTextClassifier",
    srcs = ["sources/MPPTextClassifier.mm"],
    hdrs = ["sources/MPPTextClassifier.h"],
    copts = [
        "-ObjC++",
        "-std=c++17",
        "-x objective-c++",
    ],
    # features = ["fully_static_link"],
    linkopts = ["-all_load"],
    defines = select({
        "//conditions:default": [],
        "//mediapipe/tasks/ios:ios_static_framework": ["IOS_STATIC_FRAMEWORK=1"],
    }),
    module_name = "MPPTextClassifier",
    deps = [
        ":MPPTextClassifierOptions",
        ":MPPTextClassifierResult",
        ":objc_text_classifier_graph",
        # "//mediapipe/tasks/cc/components/calculators:classification_aggregation_calculator_ios",
        "//mediapipe/tasks/cc/components/containers/proto:classifications_cc_proto",
        # "//mediapipe/tasks/cc/text/text_classifier:text_classifier_graph",
        "//mediapipe/tasks/ios/common/utils:MPPCommonUtils",
        "//mediapipe/tasks/ios/common/utils:NSStringHelpers",
        "//mediapipe/tasks/ios/core:MPPTaskInfo",
        "//mediapipe/tasks/ios/core:MPPTaskOptions",
        "//mediapipe/tasks/ios/core:MPPTextPacketCreator",
        "//mediapipe/tasks/ios/text/core:MPPTextTaskRunner",
        "//mediapipe/tasks/ios/text/text_classifier/utils:MPPTextClassifierOptionsHelpers",
        "//mediapipe/tasks/ios/text/text_classifier/utils:MPPTextClassifierResultHelpers",
        "//third_party/apple_frameworks:Foundation",
        "@com_google_absl//absl/status:statusor",
    ],
)

# apple_binary(
#     name = "MPPTextClassifierBinary",
#     deps = [
#         ":MPPTextClassifier",
#         "//mediapipe/tasks/cc/text/text_classifier:text_classifier_graph",
#     ],
#     platform_type = "ios",
# )
