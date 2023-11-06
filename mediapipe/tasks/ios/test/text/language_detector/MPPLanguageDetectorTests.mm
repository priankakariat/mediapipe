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
#import "mediapipe/tasks/ios/text/language_detector/sources/MPPLanguageDetector.h"
#import "mediapipe/tasks/ios/test/utils/sources/MPPFileInfo.h"

static MPPFileInfo *const kLanguageDetectorModelFileInfo =
    [[MPPFileInfo alloc] initWithName:@"language_detector" type:@"tflite"];

static NSString *const kExpectedErrorDomain = @"com.google.mediapipe.tasks";

#define AssertEqualErrors(error, expectedError)                                               \
  XCTAssertNotNil(error);                                                                     \
  XCTAssertEqualObjects(error.domain, expectedError.domain);                                  \
  XCTAssertEqual(error.code, expectedError.code);                                             \
  XCTAssertEqualObjects(error.localizedDescription, expectedError.localizedDescription)

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

#define AssertTextClassifierResultHasOneHead(textClassifierResult)                    \
  XCTAssertNotNil(textClassifierResult);                                              \
  XCTAssertNotNil(textClassifierResult.classificationResult);                         \
  XCTAssertEqual(textClassifierResult.classificationResult.classifications.count, 1); \
  XCTAssertEqual(textClassifierResult.classificationResult.classifications[0].headIndex, 0);

@interface MPPLanguageDetectorTests : XCTestCase
@end

@implementation MPPLanguageDetectorTests

// + (NSArray<MPPCategory *> *)expectedBertResultCategoriesForNegativeText {
//   return @[
//     [[MPPCategory alloc] initWithIndex:0 score:0.956187f categoryName:@"negative" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:1 score:0.043812f categoryName:@"positive" displayName:nil]
//   ];
// }

// + (NSArray<MPPCategory *> *)expectedBertResultCategoriesForPositiveText {
//   return @[
//     [[MPPCategory alloc] initWithIndex:1 score:0.999945f categoryName:@"positive" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:0 score:0.000055f categoryName:@"negative" displayName:nil]
//   ];
// }

// + (NSArray<MPPCategory *> *)expectedRegexResultCategoriesForNegativeText {
//   return @[
//     [[MPPCategory alloc] initWithIndex:0 score:0.6647746f categoryName:@"Negative" displayName:nil],
//     [[MPPCategory alloc] initWithIndex:1 score:0.33522537 categoryName:@"Positive" displayName:nil]
//   ];
// }

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

- (MPPLanguageDetectorOptions *)languageDetectorOptionsWithModelFileInfo:(MPPFileInfo *)fileInfo {
  MPPLanguageDetectorOptions *options = [[MPPLanguageDetectorOptions alloc] init];
  options.baseOptions.modelAssetPath = fileInfo.path;
  return options;
}

- (MPPLanguageDetectorOptions *)createLanguageDetectorWithOptionsSucceeds:(MPPLanguageDetectorOptions *)options {
  NSError *error;
  MPPLanguageDetectorOptions *languageDetector = [[MPPLanguageDetector alloc] initWithOptions:options
                                                                           error:&error];
  XCTAssertNotNil(languageDetector);
  XCTAssertNil(error);

  return languageDetector;
}

- (void)assertCreateLanguageDetectorWithOptions:(MPPLanguageDetectorOptions *)options
                       failsWithExpectedError:(NSError *)expectedError {
  NSError *error = nil;
  MPPLanguageDetector *languageDetector =
      [[MPPLanguageDetector alloc] initWithOptions:options error:&error];
  XCTAssertNil(languageDetector);
  AssertEqualErrors(error, expectedError);
}

// - (void)assertResultsOfClassifyText:(NSString *)text
//                 usingTextClassifier:(MPPTextClassifier *)textClassifier
//                    equalsCategories:(NSArray<MPPCategory *> *)expectedCategories {
//   MPPTextClassifierResult *negativeResult = [textClassifier classifyText:text error:nil];
//   AssertTextClassifierResultHasOneHead(negativeResult);
//   AssertEqualCategoryArrays(negativeResult.classificationResult.classifications[0].categories,
//                             expectedCategories);
// }

- (void)testCreateLanguageDetectorFailsWithMissingModelPath {
  NSString *modelPath = [self filePathWithName:@"" extension:@""];

  NSError *error = nil;
  MPPLanguageDetector *languageDetector = [[MPPLanguageDetector alloc] initWithModelPath:modelPath
                                                                             error:&error];
  XCTAssertNil(languageDetector);

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

- (void)testCreateLanguageDetectorFailsWithBothAllowlistAndDenylist {
  MPPLanguageDetector *options =
      [self languageDetectorOptionsWithModelFileInfo:kLanguageDetectorModelFileInfo];
  options.categoryAllowlist = @[ @"en" ];
  options.categoryDenylist = @[ @"en" ];

  [self assertCreateLanguageDetectorWithOptions:options
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

- (void)testCreateLanguageDetectorFailsWithInvalidMaxResults {
  MPPLanguageDetectorOptions *options =
      [self languageDetectorOptionsWithModelFileInfo:kLanguageDetectorModelFileInfo];
  options.maxResults = 0;

  [self assertCreateLanguageDetectorWithOptions:options
                       failsWithExpectedError:
                           [NSError errorWithDomain:kExpectedErrorDomain
                                               code:MPPTasksErrorCodeInvalidArgumentError
                                           userInfo:@{
                                             NSLocalizedDescriptionKey :
                                                 @"INVALID_ARGUMENT: Invalid `max_results` option: "
                                                 @"value must be != 0."
                                           }]];
}

// - (void)testClassifyWithBertSucceeds {
//   MPPTextClassifier *textClassifier =
//       [self textClassifierFromModelFileWithName:kBertTextClassifierModelName];

//   [self assertResultsOfClassifyText:kNegativeText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedBertResultCategoriesForNegativeText]];

//   [self assertResultsOfClassifyText:kPositiveText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedBertResultCategoriesForPositiveText]];
// }

// - (void)testClassifyWithRegexSucceeds {
//   MPPTextClassifier *textClassifier =
//       [self textClassifierFromModelFileWithName:kRegexTextClassifierModelName];

//   [self assertResultsOfClassifyText:kNegativeText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedRegexResultCategoriesForNegativeText]];
//   [self assertResultsOfClassifyText:kPositiveText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedRegexResultCategoriesForPositiveText]];
// }

// - (void)testClassifyWithMaxResultsSucceeds {
//   MPPTextClassifierOptions *options =
//       [self textClassifierOptionsWithModelName:kBertTextClassifierModelName];
//   options.maxResults = 1;

//   MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(textClassifier);

//   [self assertResultsOfClassifyText:kNegativeText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedBertResultCategoriesForEdgeCaseTests]];
// }

// - (void)testClassifyWithCategoryAllowlistSucceeds {
//   MPPTextClassifierOptions *options =
//       [self textClassifierOptionsWithModelName:kBertTextClassifierModelName];
//   options.categoryAllowlist = @[ @"negative" ];

//   NSError *error = nil;
//   MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithOptions:options
//                                                                            error:&error];
//   XCTAssertNotNil(textClassifier);
//   XCTAssertNil(error);

//   [self assertResultsOfClassifyText:kNegativeText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedBertResultCategoriesForEdgeCaseTests]];
// }

// - (void)testClassifyWithCategoryDenylistSucceeds {
//   MPPTextClassifierOptions *options =
//       [self textClassifierOptionsWithModelName:kBertTextClassifierModelName];
//   options.categoryDenylist = @[ @"positive" ];

//   MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(textClassifier);

//   [self assertResultsOfClassifyText:kNegativeText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedBertResultCategoriesForEdgeCaseTests]];
// }

// - (void)testClassifyWithScoreThresholdSucceeds {
//   MPPTextClassifierOptions *options =
//       [self textClassifierOptionsWithModelName:kBertTextClassifierModelName];
//   options.scoreThreshold = 0.5f;

//   MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithOptions:options error:nil];
//   XCTAssertNotNil(textClassifier);

//   [self assertResultsOfClassifyText:kNegativeText
//                 usingTextClassifier:textClassifier
//                    equalsCategories:[MPPTextClassifierTests
//                                         expectedBertResultCategoriesForEdgeCaseTests]];
// }

@end
