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

#import <XCTest/XCTest.h>

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/vision/image_classifier/sources/MPPImageClassifier.h"
#import "mediapipe/tasks/ios/test/vision/utils/sources/MPPImage+TestUtils.h"
// #include "mediapipe/framework/port/opencv_core_inc.h"
// #include "mediapipe/framework/port/opencv_imgproc_inc.h"

static NSString *const kFloatModelName = @"mobilenet_v2_1.0_224";
static NSString *const kQuantizedModelName =
    @"mobilenet_v1_0.25_224_quant";
static NSString *const kNegativeText = @"unflinchingly bleak and desperate";
static NSString *const kBurgerImageName = @"burger";
static NSString *const kBurgerRotatedImageName = @"burger_rotated";
static NSString *const kMultiObjectsImageName = @"multi_objects";
static NSString *const kMultiObjectsRotatedImageName = @"multi_objects_rotated";
static const int kMobileNetCategoriesCount = 1001;
static NSString *const kExpectedErrorDomain = @"com.google.mediapipe.tasks";

#define AssertEqualErrors(error, expectedError)                                               \
  XCTAssertNotNil(error);                                                                     \
  XCTAssertEqualObjects(error.domain, expectedError.domain);                                  \
  XCTAssertEqual(error.code, expectedError.code);                                             \
  XCTAssertNotEqual(                                                                          \
      [error.localizedDescription rangeOfString:expectedError.localizedDescription].location, \
      NSNotFound)

#define AssertEqualCategoryArrays(categories, expectedCategories)                         \
  XCTAssertEqual(categories.count, expectedCategories.count);                             \
  for (int i = 0; i < categories.count; i++) {                                            \
    XCTAssertEqual(categories[i].index, expectedCategories[i].index, @"index i = %d", i); \
    XCTAssertEqualWithAccuracy(categories[i].score, expectedCategories[i].score, 1e-3,    \
                               @"index i = %d", i);                                       \
    XCTAssertEqualObjects(categories[i].categoryName, expectedCategories[i].categoryName, \
                          @"index i = %d", i);                                            \
    XCTAssertEqualObjects(categories[i].displayName, expectedCategories[i].displayName,   \
                          @"index i = %d", i);                                            \
  }

#define AssertImageClassifierResultHasOneHead(imageClassifierResult)                    \
  XCTAssertNotNil(imageClassifierResult);                                              \
  XCTAssertNotNil(imageClassifierResult.classificationResult);                         \
  XCTAssertEqual(imageClassifierResult.classificationResult.classifications.count, 1); \
  XCTAssertEqual(imageClassifierResult.classificationResult.classifications[0].headIndex, 0);


@interface MPPImageClassifierTests : XCTestCase
@end

@implementation MPPImageClassifierTests

//  - (void)testClassifyWithModelPathAndFloatModelSucceeds {

//   // NSLog(@"Enter 1");
//   // MPPImageClassifier *imageClassifier =
//   //     [self imageClassifierFromModelFileWithName:kFloatModelName];

//   // NSLog(@"Created classif");
  
//   const cv::RotatedRect rotated_rect(cv::Point2f(0, 0),
//                                      cv::Size2f(100, 100),
//                                      90 * 180.f / M_PI);
//   cv::Mat src_points;
//   cv::boxPoints(rotated_rect, src_points);
  
//   NSLog(@"Hello done cv");

//   // [self assertResultsOfClassifyImageWithName:kBurgerImageName
//   //               usingImageClassifier:imageClassifier
//   //               expectedCategoriesCount:kMobileNetCategoriesCount
//   //                  equalsCategories:[MPPImageClassifierTests
//   //                                       expectedResultCategoriesForBurgerImage]];
// }

+ (NSArray<MPPCategory *> *)expectedResultCategoriesForBurgerImage {
  return @[
    [[MPPCategory alloc] initWithIndex:934 score:0.7952058f categoryName:@"cheeseburger" displayName:nil],
    [[MPPCategory alloc] initWithIndex:932 score:0.027329788f categoryName:@"bagel" displayName:nil],
    [[MPPCategory alloc] initWithIndex:925 score:0.019334773f categoryName:@"guacamole" displayName:nil]
  ];
}

+ (NSArray<MPPCategory *> *)expectedResultCategoriesForBurgerImageWithScoreThreshold {
  return @[
    [[MPPCategory alloc] initWithIndex:934 score:0.7952058f categoryName:@"cheeseburger" displayName:nil],
    [[MPPCategory alloc] initWithIndex:932 score:0.027329788f categoryName:@"bagel" displayName:nil],
  ];
}

// + (NSArray<MPPCategory *> *)expectedRegexResultCategoriesForPositiveText {
//   return @[
//     [[MPPCategory alloc] initWithIndex:0 score:0.5120041f categoryName:@"Negative" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:1 score:0.48799595 categoryName:@"Positive" displayName:nil]
//   ];
// }

// + (NSArray<MPPCategory *> *)expectedBertResultCategoriesForEdgeCaseTests {
//   return @[ [[MPPCategory alloc] initWithIndex:0
//                                          score:0.956187f
//                                   categoryName:@"negative"
//                                    displayName:nil] ];
// }

- (NSString *)filePathWithName:(NSString *)fileName extension:(NSString *)extension {
  NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:fileName
                                                                      ofType:extension];
  return filePath;
}

- (MPPImageClassifierOptions *)imageClassifierOptionsWithModelName:(NSString *)modelName {
  NSString *modelPath = [self filePathWithName:modelName extension:@"tflite"];
  MPPImageClassifierOptions *imageClassifierOptions = [[MPPImageClassifierOptions alloc] init];
  imageClassifierOptions.baseOptions.modelAssetPath = modelPath;

  return imageClassifierOptions;
}

- (MPPImageClassifier *)imageClassifierFromModelFileWithName:(NSString *)modelName {
  NSString *modelPath = [self filePathWithName:modelName extension:@"tflite"];
  MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithModelPath:modelPath
                                                                             error:nil];
  XCTAssertNotNil(imageClassifier);

  return imageClassifier;
}

- (void)assertCreateImageClassifierWithOptions:(MPPImageClassifierOptions *)imageClassifierOptions
                       failsWithExpectedError:(NSError *)expectedError {
  NSError *error = nil;
  MPPImageClassifier *imageClassifier =
      [[MPPImageClassifier alloc] initWithOptions:imageClassifierOptions error:&error];
  XCTAssertNil(imageClassifier);
  AssertEqualErrors(error, expectedError);
}

- (void)assertResultsOfClassifyImageWithName:(NSString *)imageName
                usingImageClassifier:(MPPImageClassifier *)imageClassifier
                   expectedCategoriesCount:(NSInteger)expectedCategoriesCount
                   equalsCategories:(NSArray<MPPCategory *> *)expectedCategories {
  NSLog(@"Before Image");                  
  MPPImage *mppImage = [MPPImage imageFromBundleWithClass:[MPPImageClassifierTests class] fileName:imageName ofType:@"jpg" error:nil];
  XCTAssertNotNil(mppImage);
  NSLog(@"Created Image");                  


  NSLog(@"Before Classify");                  

  MPPImageClassifierResult *imageClassifierResult = [imageClassifier classifyImage:mppImage error:nil];

  // NSLog(@"After Classify");                  

  NSArray<MPPCategory *> *resultCategories = imageClassifierResult.classificationResult.classifications[0].categories;
  
  // AssertImageClassifierResultHasOneHead(imageClassifierResult);
  // XCTAssertEqual(resultCategories, expectedCategoriesCount);
  
  // NSArray<MPPCategory *> *categorySubsetToCompare;
  // if (resultCategories.count > expectedCategories.count) {
  //    categorySubsetToCompare = [resultCategories subarrayWithRange:NSMakeRange(0,expectedCategoriesCount)];
  // }
  // else {
  //   categorySubsetToCompare = imageClassifierResult.classificationResult.classifications[0].categories;
  // }
  // AssertEqualCategoryArrays(categorySubsetToCompare,
  //                           expectedCategories);
}

- (void)testCreateImageClassifierFailsWithMissingModelPath {
  NSString *modelPath = [self filePathWithName:@"" extension:@""];

  NSError *error = nil;
  MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithModelPath:modelPath
                                                                             error:&error];
  XCTAssertNil(imageClassifier);

  NSError *expectedError = [NSError
      errorWithDomain:kExpectedErrorDomain
                 code:MPPTasksErrorCodeInvalidArgumentError
             userInfo:@{
               NSLocalizedDescriptionKey :
                   @"INVALID_ARGUMENT: ExternalFile must specify at least one of 'file_content', "
                   @"'file_name', 'file_pointer_meta' or 'file_descriptor_meta'."
             }];
  AssertEqualErrors(error, expectedError);
}

- (void)testCreateImageClassifierFailsWithBothAllowlistAndDenylist {
  MPPImageClassifierOptions *options =
      [self imageClassifierOptionsWithModelName:kFloatModelName];
  options.categoryAllowlist = @[ @"cheeseburger" ];
  options.categoryDenylist = @[ @"bagel" ];

  [self assertCreateImageClassifierWithOptions:options
                       failsWithExpectedError:
                           [NSError
                               errorWithDomain:kExpectedErrorDomain
                                          code:MPPTasksErrorCodeInvalidArgumentError
                                      userInfo:@{
                                        NSLocalizedDescriptionKey :
                                            @"INVALID_ARGUMENT: `category_allowlist` and "
                                            @"`category_denylist` are mutually exclusive options."
                                      }]];
}

- (void)testCreateImageClassifierFailsWithInvalidMaxResults {
  MPPImageClassifierOptions *options =
      [self imageClassifierOptionsWithModelName:kFloatModelName];
  options.maxResults = 0;

  [self assertCreateImageClassifierWithOptions:options
                       failsWithExpectedError:
                           [NSError errorWithDomain:kExpectedErrorDomain
                                               code:MPPTasksErrorCodeInvalidArgumentError
                                           userInfo:@{
                                             NSLocalizedDescriptionKey :
                                                 @"INVALID_ARGUMENT: Invalid `max_results` option: "
                                                 @"value must be != 0."
                                           }]];
}

- (void)testClassifyWithModelPathAndFloatModelSucceeds {

  NSLog(@"Enter 1");
  MPPImageClassifier *imageClassifier =
      [self imageClassifierFromModelFileWithName:kFloatModelName];

  NSLog(@"Created classif");
  
  // const cv::RotatedRect rotated_rect(cv::Point2f(0, 0),
  //                                    cv::Size2f(100, 100),
  //                                    90 * 180.f / M_PI);
  // cv::Mat src_points;
  // cv::boxPoints(rotated_rect, src_points);
  
  // NSLog(@"Hello done cv");

  [self assertResultsOfClassifyImageWithName:kBurgerImageName
                usingImageClassifier:imageClassifier
                expectedCategoriesCount:kMobileNetCategoriesCount
                   equalsCategories:[MPPImageClassifierTests
                                        expectedResultCategoriesForBurgerImage]];
}

// - (void)testClassifyWithOptionsAndFloatModelSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kFLoatModelName];

//   const NSInteger maxResults = 3;
//   options.maxResults = maxResults;

//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);

//   [self assertResultsOfClassifyImageWithName:kBurgerImageName
//                 usingImageClassifier:imageClassifier
//                 expectedCategoriesCount:maxResults
//                    equalsCategories:[MPPImageClassifierTests
//                                         expectedResultCategoriesForBurgerImage]];
// }

// - (void)testClassifyWithQuantizedModelSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kQuantizedModelName];

//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);

//   [self assertResultsOfClassifyImageWithName:kBurgerImageName
//                 usingImageClassifier:imageClassifier
//                 expectedCategoriesCount:kMobileNetCategoriesCount
//                    equalsCategories:[MPPImageClassifierTests
//                                         expectedResultCategoriesForBurgerImage]];
// }

// - (void)testClassifyWithScoreThresholdSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kFloatModelName];
  
//   options.scoreThreshold = 0.02f;
//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);
  
//   NSArray<MPPCategory *expectedCategories = @[
//     [[MPPCategory alloc] initWithIndex:934 score:0.7952058f categoryName:@"cheeseburger" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:932 score:0.027329788f categoryName:@"bagel" displayName:nil],
//   ];
  
//   [self assertResultsOfClassifyImageWithName:kBurgerImageName
//                 usingImageClassifier:imageClassifier
//                 expectedCategoriesCount:expectedCategories.count
//                    equalsCategories:expectedCategories];
// }

// - (void)testClassifyWithAllowListSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kFloatModelName];
  
//   options.categoryAllowlist = @[
//     @"cheeseburger",
//     @"guacamole",
//     @"meat loaf"
//   ];

//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);
  
//   NSArray<MPPCategory *expectedCategories = @[
//     [[MPPCategory alloc] initWithIndex:934 score:0.7952058f categoryName:@"cheeseburger" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:925 score:0.019334773f categoryName:@"guacamole" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:963 score:0.006279315f categoryName:@"meat loaf" displayName:nil],

//   ];
  
//   [self assertResultsOfClassifyImageWithName:kBurgerImageName
//                 usingImageClassifier:imageClassifier
//                 expectedCategoriesCount:expectedCategories.count
//                    equalsCategories:expectedCategories];
// }

// - (void)testClassifyWithDenyListSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kFloatModelName];
  
//   options.categoryAllowlist = @[
//     @"bagel",
//   ];
//   options.maxResults = 3;

//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);
  
//   NSArray<MPPCategory *expectedCategories = @[
//     [[MPPCategory alloc] initWithIndex:934 score:0.7952058f categoryName:@"cheeseburger" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:925 score:0.019334773f categoryName:@"guacamole" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:963 score:0.006279315f categoryName:@"meat loaf" displayName:nil],

//   ];
  
//   [self assertResultsOfClassifyImageWithName:kBurgerImageName
//                 usingImageClassifier:imageClassifier
//                 expectedCategoriesCount:expectedCategories.count
//                    equalsCategories:expectedCategories];
// }

// - (void)testClassifyWithRegionOfInterestSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kFloatModelName];
  
//   NSInteger maxResults = 1;
//   options.maxResults = maxResults;

  
//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);
  
//   NSArray<MPPCategory *expectedCategories = @[
//     [[MPPCategory alloc] initWithIndex:806 score:0.9969325f categoryName:@"soccer ball" displayName:nil]
//   ];

//   MPPImage *mppImage = [MPPImage imageFromBundleWithClass:[MPPImageClassifierTests class] name:imageName ofType:@"jpg"];

//   MPPImageClassifierResult *imageClassifierResult = [imageClassifier classifyImage:mppImage regionOfInterest:CGRectMake(409, 109, 146, 155) error:nil];

//   AssertImageClassifierResultHasOneHead(imageClassifierResult);
//   XCTAssertEqual(imageClassifierResult.classificationResul.classifications[0].categories.count, expectedCategoriesCount);
//   AssertEqualCategoryArrays( imageClassifierResult.classificationResult.classifications[0].categories,
//                             expectedCategories);
// }

// - (void)testClassifyWithRotationSucceeds {
//   MPPImageClassifierOptions *options =
//       [self imageClassifierOptionsWithModelName:kFloatModelName];
  
//   NSInteger maxResults = 1;
//   options.maxResults = maxResults;

  
//   MPPImageClassifier *imageClassifier = [[MPPImageClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(imageClassifier);
  
//   // NSArray<MPPCategory *expectedCategories = @[
//   //   [[MPPCategory alloc] initWithIndex:934 score:0.6390683f categoryName:@"cheeseburger" displayName:nil]
//   // ];

//   // [self assertResultsOfClassifyImageWithName:kBurgerImageName
//   //               usingImageClassifier:imageClassifier
//   //               expectedCategoriesCount:maxResults
//   //                  equalsCategories:@[
//   //   [[MPPCategory alloc] initWithIndex:806 score:0.9969325f categoryName:@"soccer ball" displayName:nil]
//   // ]];
// }
  
@end
