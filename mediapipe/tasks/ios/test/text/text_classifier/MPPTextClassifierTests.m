/* Copyright 2022 The TensorFlow Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ==============================================================================*/

#import <XCTest/XCTest.h>

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/text/text_classifier/sources/MPPTextClassifier.h"

static NSString *const kBertTextClassifierModelName = @"bert_text_classifier";
static NSString *const kRegexTextClassifierModelName = @"test_model_text_classifier_with_regex_tokenizer";
static NSString *const kNegativeText = @"unflinchingly bleak and desperate";
static NSString *const kPositiveText = @"it's a charming and often affecting journey";
static NSString *const kExpectedErrorDomain = @"com.google.mediapipe.tasks";

#define AssertEqualErrors(error, expectedError) \
  XCTAssertNotNil(error);                                                                \
  XCTAssertEqualObjects(error.domain, expectedError.domain);                                   \
  XCTAssertEqual(error.code, expectedError.code);                                              \
  XCTAssertNotEqual(                                                                     \
      [error.localizedDescription rangeOfString:expectedError.localizedDescription].location,  \
      NSNotFound)             

#define AssertEqualCategoryArrays(categories, expectedCategories) \
  XCTAssertEqual(categories.count, expectedCategories.count); \
  for (int i = 0; i < categories.count; i++) { \
    XCTAssertEqual(categories[i].index, expectedCategories[i].index);                                                   \
    XCTAssertEqualWithAccuracy(categories[i].score, expectedCategories[i].score, 1e-6);                                 \
    XCTAssertEqualObjects(categories[i].categoryName, expectedCategories[i].categoryName);                                            \
    XCTAssertEqualObjects(categories[i].displayName, expectedCategories[i].displayName); \
  }              

#define AssertTextClassifierResultHasOneHead(textClassifierResult) \
  XCTAssertNotNil(textClassifierResult);                           \              
  XCTAssertNotNil(textClassifierResult.classificationResult);      \
  XCTAssertEqual(textClassifierResult.classificationResult.classifications.count, 1);   \
  XCTAssertEqual(textClassifierResult.classificationResult.classifications[0].headIndex, 0);   

@interface MPPTextClassifierTests : XCTestCase
@end

@implementation MPPTextClassifierTests

- (void)setUp {
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (NSString *)filePathWithName:(NSString *)fileName extension:(NSString *)extension {
  NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:fileName
                                                                      ofType:extension];
  return filePath;
}

- (MPPTextClassifierOptions *)textClassifierOptionsWithModelName:(NSString *)modelName {
  NSString *modelPath = [self filePathWithName:modelName extension:@"tflite"];
  MPPTextClassifierOptions *textClassifierOptions =
      [[MPPTextClassifierOptions alloc] init];
  textClassifierOptions.baseOptions.modelAssetPath = modelPath;

  return textClassifierOptions;
}

- (MPPTextClassifier *)textClassifierFromOptionsWithModelName:(NSString *)modelName {
  MPPTextClassifierOptions *options = [self textClassifierOptionsWithModelName:modelName];
  MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithOptions:options error:nil];
  XCTAssertNotNil(textClassifier);

  return textClassifier;
}

- (MPPTextClassifier *)textClassifierFromModelFileWithName:(NSString *)modelName {
  NSString *modelPath = [self filePathWithName:modelName extension:@"tflite"];
  MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithModelPath:modelPath error:nil];
  XCTAssertNotNil(textClassifier);

  return textClassifier;
}

- (void)testCreateTextClassifierFailsWithMissingModelPath {
  NSString *modelPath = [self filePathWithName:@"" extension:@""];

  NSError *error = nil;
  MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithModelPath:modelPath error:&error];
  XCTAssertNil(textClassifier);

  NSError *expectedError = [NSError errorWithDomain:kExpectedErrorDomain
                                 code:MPPTasksErrorCodeInvalidArgumentError
                             userInfo:@{NSLocalizedDescriptionKey : @"INVALID_ARGUMENT: ExternalFile must specify at least one of 'file_content', 'file_name', 'file_pointer_meta' or 'file_descriptor_meta'."}];
  AssertEqualErrors(error, expectedError);
}

- (void)testCreateTextClassifierFailsWithBothAllowListAndDenyList {
  MPPTextClassifierOptions *options = [self textClassifierOptionsWithModelName:kBertTextClassifierModelName];
  options.categoryAllowlist = @[@"positive"];
  options.categoryDenylist = @[@"negative"];

  NSError *error = nil;
  MPPTextClassifier *textClassifier = [[MPPTextClassifier alloc] initWithOptions:options error:&error];
  XCTAssertNil(textClassifier);
  
  NSLog(@"Error %@", error.localizedDescription);
  NSLog(@"Error Code %d", error.code);
  NSError *expectedError = [NSError errorWithDomain:kExpectedErrorDomain
                                 code:MPPTasksErrorCodeInvalidArgumentError
                             userInfo:@{NSLocalizedDescriptionKey : @"INVALID_ARGUMENT: ExternalFile must specify at least one of 'file_content', 'file_name', 'file_pointer_meta' or 'file_descriptor_meta'."}];
  AssertEqualErrors(error, expectedError);
 }

- (void)testClassifyWithBertSucceeds {
  MPPTextClassifier *textClassifier = [self textClassifierFromModelFileWithName:kBertTextClassifierModelName];
   
  MPPTextClassifierResult *negativeResult = [textClassifier classifyText:kNegativeText error:nil];
  AssertTextClassifierResultHasOneHead(negativeResult);
  
  NSArray<MPPCategory *> *expectedNegativeCategories = @[[[MPPCategory alloc] initWithIndex:0
                                 score:0.956187f
                                 categoryName:@"negative"
                           displayName:nil],
    [[MPPCategory alloc] initWithIndex:1
                                 score:0.043812f
                                 categoryName:@"positive"
                           displayName:nil]];
  
  AssertEqualCategoryArrays(negativeResult.classificationResult.classifications[0].categories,
                      expectedNegativeCategories
  );

  MPPTextClassifierResult *positiveResult = [textClassifier classifyText:kPositiveText error:nil];
  AssertTextClassifierResultHasOneHead(positiveResult);
  NSArray<MPPCategory *> *expectedPositiveCategories = @[[[MPPCategory alloc] initWithIndex:1
                                 score:0.999945f
                                 categoryName:@"positive"
                           displayName:nil],
    [[MPPCategory alloc] initWithIndex:0
                                 score:0.000055f
                                 categoryName:@"negative"
                           displayName:nil]];
  AssertEqualCategoryArrays(positiveResult.classificationResult.classifications[0].categories,
                      expectedPositiveCategories
  );

}

- (void)testClassifyWithRegexSucceeds {
  MPPTextClassifier *textClassifier = [self textClassifierFromModelFileWithName:kRegexTextClassifierModelName];
   
  MPPTextClassifierResult *negativeResult = [textClassifier classifyText:kNegativeText error:nil];
  AssertTextClassifierResultHasOneHead(negativeResult);
  
  NSArray<MPPCategory *> *expectedNegativeCategories = @[[[MPPCategory alloc] initWithIndex:0
                                 score:0.6647746f
                                 categoryName:@"Negative"
                           displayName:nil],
    [[MPPCategory alloc] initWithIndex:1
                                 score:0.33522537
                                 categoryName:@"Positive"
                           displayName:nil]];
  
  AssertEqualCategoryArrays(negativeResult.classificationResult.classifications[0].categories,
                      expectedNegativeCategories
  );

  MPPTextClassifierResult *positiveResult = [textClassifier classifyText:kPositiveText error:nil];
  AssertTextClassifierResultHasOneHead(positiveResult);
  NSArray<MPPCategory *> *expectedPositiveCategories = @[[[MPPCategory alloc] initWithIndex:0
                                 score:0.5120041f
                                 categoryName:@"Negative"
                           displayName:nil],
    [[MPPCategory alloc] initWithIndex:1
                                 score:0.48799595
                                 categoryName:@"Positive"
                           displayName:nil]];
  AssertEqualCategoryArrays(positiveResult.classificationResult.classifications[0].categories,
                      expectedPositiveCategories
  );

}

@end
