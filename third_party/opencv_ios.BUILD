# Description:
#   OpenCV libraries for video/image processing on iOS

licenses(["notice"])  # BSD license

exports_files(["LICENSE"])

load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_static_xcframework_import",
)

apple_static_xcframework_import(
    name = "OpencvFramework",
    xcframework_imports = glob(["opencv2.xcframework/**"]),
    visibility = ["//visibility:public"],
)

objc_library(
    name = "opencv_objc_lib",
    deps = [":OpencvFramework"],
)

cc_library(
    name = "opencv",
    hdrs = select({
        "@//mediapipe:ios_x86_64" : glob(["opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/**/*.h*"]),
        "@//mediapipe:ios_sim_arm64" : glob(["opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/**/*.h*"]),
        "@//mediapipe:ios_arm64" : glob(["opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers/**/*.h*"]),
        "//conditions:default": glob(["opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers/**/*.h*"]),
    }),
    copts = [
        "-std=c++11",
        "-x objective-c++",
    ],
    include_prefix = "opencv2",
    linkopts = [
        "-framework AssetsLibrary",
        "-framework CoreFoundation",
        "-framework CoreGraphics",
        "-framework CoreMedia",
        "-framework Accelerate",
        "-framework CoreImage",
        "-framework AVFoundation",
        "-framework CoreVideo",
        "-framework QuartzCore",
    ],
    strip_include_prefix = select({
        "@//mediapipe:ios_x86_64" : "opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers",
        "@//mediapipe:ios_sim_arm64" : "opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers",
        "@//mediapipe:ios_arm64" : "opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers",
        "//conditions:default": "opencv2.xcframework/ios-arm64_x86_64-simulator/opencv2.framework/Versions/A/Headers",
    }),
    visibility = ["//visibility:public"],
    deps = [":opencv_objc_lib"],
)

