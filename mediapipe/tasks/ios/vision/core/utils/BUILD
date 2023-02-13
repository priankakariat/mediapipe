package(default_visibility = ["//mediapipe/tasks:internal"])

licenses(["notice"])

objc_library(
    name = "MPPImageUtils",
    srcs = ["sources/MPPImage+Utils.m"],
    hdrs = ["sources/MPPImage+Utils.h"],
    module_name = "MPPImageUtils",
    sdk_frameworks = [
        "Accelerate",
        "CoreGraphics",
        "CoreImage",
        "CoreVideo",
    ],
    deps = [
        "//mediapipe/tasks/ios/common/utils:MPPCommonUtils",
        "//mediapipe/tasks/ios/vision/core:MPPImage",
    ],
)

objc_library(
    name = "MPPRunningMode",
    hdrs = ["sources/MPPRunningMode.h"],
    module_name = "MPPRunningMode",
)

objc_library(
    name = "MPPVisionTaskRunner",
    srcs = ["sources/MPPVisionTaskRunner.mm"],
    hdrs = ["sources/MPPVisionTaskRunner.h"],
    copts = [
        "-ObjC++",
        "-std=c++17",
    ],
    deps = [
        ":MPPRunningMode",
        "//mediapipe/tasks/ios/core:MPPTaskRunner",
    ],
)
