# Description:
#   OpenCV libraries for video/image processing on iOS

licenses(["notice"])  # BSD license

exports_files(["LICENSE"])

load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_static_xcframework_import",
)

load(
    "@//third_party:ios_opencv_xcframework_files.bzl",
    "OPEN_CV_XCFRAMEWORK_FILE_LIST",
    "unzip",
    "print_names",
    "sequence",
    "select_headers",
)

filegroup(
    name = "opencv_files",
    # srcs = glob([":opencv2/**"]),
    # srcs = glob(["aaa/**"]),
    srcs = [":opencv2_great"],
    # data = [":build_xcframework"],
    # output_group = "gen_dir",
)

unzip (
    name = "opencv2_great",
    zip_file = "opencv2.xcframework.zip",
)

# for file_name in 

genrule(
    name = "build_xcframework",
    srcs = glob(["opencv-4.5.1/**"]),
    # outs = ["opencv2.xcframework"],
    outs = ["opencv2.xcframework.zip"],
    # outs = OPEN_CV_XCFRAMEWORK_FILE_LIST + ['opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Headers'],
    # outs = ['opencv2.xcframework/Info.plist',
    #         'opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Versions/A/Headers/opencv_modules.hpp',],
    #         'opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Headers/opencv_modules.hpp',],
    output_to_bindir = True,

    # cmd = "$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(RULEDIR) && cd $(RULEDIR)/opencv2.xcframework && ln -s ios-arm64-simulator/opencv2.framework/Versions/A/Headers Headers",

    # cmd = "$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(RULEDIR) && cd $(RULEDIR) && zip -r opencv2.xcframework.zip opencv2.xcframework/*",
    cmd = "&&".join(["$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(@D)", 
    "cd $(@D)",
    "ls",
    "pwd",
    "zip --symlinks -r opencv2.xcframework.zip opencv2.xcframework",
    ]),
)

# genrule(
#     name = "build_xcframework",
#     srcs = glob(["opencv-4.5.1/**"]),
#     # outs = ["opencv2.xcframework"],
#     # outs = ["opencv2.xcframework.zip"],
#     outs = OPEN_CV_XCFRAMEWORK_FILE_LIST + ['opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Headers'],
#     # outs = ['opencv2.xcframework/Info.plist',
#     #         'opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Versions/A/Headers/opencv_modules.hpp',],
#     #         'opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Headers/opencv_modules.hpp',],
#     # output_to_bindir = True,

#     cmd = "$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(RULEDIR) && cd $(RULEDIR)/opencv2.xcframework && ln -s ios-arm64-simulator/opencv2.framework/Versions/A/Headers Headers",

#     # cmd = "$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(RULEDIR) && cd $(RULEDIR) && zip -r opencv2.xcframework.zip opencv2.xcframework/*",
#     # cmd = "&&".join(["$(location opencv-4.5.1/platforms/apple/build_xcframework.py) --iphonesimulator_archs arm64 --without dnn --without ml --without stitching --without photo --without objdetect --without gapi --without flann --disable PROTOBUF --disable-bitcode --disable-swift --build_only_specified_archs --out $(@D)", 
#     # "cd $(@D)",
#     # "ls",
#     # "pwd",
#     # "zip --symlinks -r opencv2.xcframework.zip opencv2.xcframework",
#     # ]),
# )

select_headers(
    name = "opencv_xcframework_headers",
    srcs = [":opencv"],
)

apple_static_xcframework_import(
    name = "opencv",
    xcframework_imports = [':opencv2_great'],
    visibility = ["//visibility:public"],
)

objc_library(
    name = "opencv_xcframework_objc_lib",
    deps = [":opencv"],
    visibility = ["//visibility:public"],
)


#print_names()
# sequence(
#     name = "opencv_cc",
# )
cc_library(
    name = "opencv_cc",
    # hdrs = print_names(),
    hdrs = [":opencv_xcframework_headers"],
    copts = [
        "-std=c++11",
        "-x objective-c++",
        # "-Iopencv2.xcframework/ios-arm64-simulator/opencv2.framework/Versions/A/Headers"
    ],
    include_prefix = "opencv2",
    # include_prefix = "opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Versions/A/Headers/core/",
    # includes = [
    #     ".",
    # ],
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
        "@//mediapipe:ios_x86_64" : "opencv2.xcframework/ios-arm64-simulator",
        "@//mediapipe:ios_sim_arm64" :"opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Versions/A/Headers",
        "@//mediapipe:ios_arm64" : "opencv2.xcframework/ios-arm64/opencv2.framework/Versions/A/Headers",
        "//conditions:default": "opencv2.xcframework/ios-arm64-simulator/opencv2.framework/Versions/A/Headers",
    }),
    visibility = ["//visibility:public"],
    deps = [":opencv"],
    data = [":opencv"]
)