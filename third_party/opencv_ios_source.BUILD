# Description:
#   OpenCV libraries for video/image processing on iOS

licenses(["notice"])  # BSD license

exports_files(["LICENSE"])

load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_static_xcframework_import",
)

load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_static_xcframework_import",
)

load(
    "@//third_party:ios_opencv_xcframework_files.bzl",
    "OPEN_CV_XCFRAMEWORK_FILE_LIST",
)

filegroup(
    name = "opencv_files",
    srcs = OPEN_CV_XCFRAMEWORK_FILE_LIST,
    data = [":build_xcframework"],
)

apple_static_xcframework_import(
    name = "OpencvFramework",
    xcframework_imports = glob(["opencv2.xcframework/**"]),
    visibility = ["//visibility:public"],
)


# genrule(
#     name = "build_xcframework",
#     srcs = glob(["opencv-4.5.1/**"]),
#     outs = OPEN_CV_XCFRAMEWORK_FILE_LIST,
#     cmd = "$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs x86_64,arm64 --iphoneos_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(RULEDIR)",
# )

apple_static_xcframework_import(
    name = "OpencvXCFramework",
    xcframework_imports = [":opencv_files"],
    visibility = ["//visibility:public"],
)

objc_library(
    name = "opencv_objc_lib",
    deps = [":OpencvFramework"],
)

objc_library(
    name = "opencv_xcframework_objc_lib",
    deps = [":OpencvXCFramework"],
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

cc_library(
    name = "opencv_source",
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
    deps = [":opencv_xcframework_objc_lib"],
)

