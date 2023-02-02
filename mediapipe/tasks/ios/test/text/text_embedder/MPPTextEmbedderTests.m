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
#import "mediapipe/tasks/ios/text/text_embedder/sources/MPPTextEmbedder.h"

static NSString *const kBertTextEmbedderModelName = @"mobilebert_embedding_with_metadata";
static NSString *const kRegexTextEmbedderModelName =
    @"regex_one_embedding_with_metadata";
// static NSString *const kNegativeText = @"unflinchingly bleak and desperate";
// static NSString *const kPositiveText = @"it's a charming and often affecting journey";
static NSString *const kExpectedErrorDomain = @"com.google.mediapipe.tasks";
static const float kFloatDiffTolerance = 1e-4;
static const float kDoubleDiffTolerance = 1e-4;

#define AssertEqualErrors(error, expectedError)                                               \
  XCTAssertNotNil(error);                                                                     \
  XCTAssertEqualObjects(error.domain, expectedError.domain);                                  \
  XCTAssertEqual(error.code, expectedError.code);                                             \
  XCTAssertNotEqual(                                                                          \
      [error.localizedDescription rangeOfString:expectedError.localizedDescription].location, \
      NSNotFound)

// #define AssertEqualCategoryArrays(categories, expectedCategories)                         \
//   XCTAssertEqual(categories.count, expectedCategories.count);                             \
//   for (int i = 0; i < categories.count; i++) {                                            \
//     XCTAssertEqual(categories[i].index, expectedCategories[i].index, @"index i = %d", i); \
//     XCTAssertEqualWithAccuracy(categories[i].score, expectedCategories[i].score, 1e-3,    \
//                                @"index i = %d", i);                                       \
//     XCTAssertEqualObjects(categories[i].categoryName, expectedCategories[i].categoryName, \
//                           @"index i = %d", i);                                            \
//     XCTAssertEqualObjects(categories[i].displayName, expectedCategories[i].displayName,   \
//                           @"index i = %d", i);                                            \
//   }

#define AssertTextEmbedderResultHasOneEmbedding(textEmbedderResult)                    \
  XCTAssertNotNil(textEmbedderResult);                                              \
  XCTAssertNotNil(textEmbedderResult.embeddingResult);                         \
  XCTAssertEqual(textEmbedderResult.embeddingResult.embeddings.count, 1); \

#define AssertEmbeddingIsFloat(embedding)                    \
  XCTAssertNotNil(embedding.floatEmbedding);                                              \
  XCTAssertNil(embedding.quantizedEmbedding);        

#define AssertEmbeddingIsQuantized(embedding)                    \
  XCTAssertNil(embedding.floatEmbedding);                                              \
  XCTAssertNotNil(embedding.quantizedEmbedding);                    

#define AssertFloatEmbeddingHasExpectedValues(floatEmbedding, expectedLength, expectedFirstValue)                    \
  XCTAssertEqual(floatEmbedding.count, expectedLength); \
  XCTAssertEqualWithAccuracy(floatEmbedding[0].floatValue, expectedFirstValue, 1e-4f); 

#define AssertQuantizedEmbeddingHasExpectedValues(quantizedEmbedding, expectedLength, expectedFirstValue)                    \
  XCTAssertEqual(quantizedEmbedding.count, expectedLength); \
  XCTAssertEqual(quantizedEmbedding[0].charValue, expectedFirstValue); 

@interface MPPTextEmbedderTests : XCTestCase
@end

@implementation MPPTextEmbedderTests

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

- (NSString *)filePathWithName:(NSString *)fileName extension:(NSString *)extension {
  NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:fileName
                                                                      ofType:extension];
  return filePath;
}

- (MPPTextEmbedderOptions *)textEmbedderOptionsWithModelName:(NSString *)modelName {
  NSString *modelPath = [self filePathWithName:modelName extension:@"tflite"];
  MPPTextEmbedderOptions *textEmbedderOptions = [[MPPTextEmbedderOptions alloc] init];
  textEmbedderOptions.baseOptions.modelAssetPath = modelPath;

  return textEmbedderOptions;
}

- (MPPTextEmbedder *)textEmbedderFromModelFileWithName:(NSString *)modelName {
  NSString *modelPath = [self filePathWithName:modelName extension:@"tflite"];

  NSError *error = nil;
  MPPTextEmbedder *textEmbedder = [[MPPTextEmbedder alloc] initWithModelPath:modelPath
                                                                             error:&error];
                                                                    
  XCTAssertNotNil(textEmbedder);

  return textEmbedder;
}

- (void)assertCreateTextEmbedderWithOptions:(MPPTextEmbedderOptions *)textEmbedderOptions
                       failsWithExpectedError:(NSError *)expectedError {
  NSError *error = nil;
  MPPTextEmbedder *textEmbedder =
      [[MPPTextEmbedder alloc] initWithOptions:textEmbedderOptions error:&error];
  XCTAssertNil(textEmbedder);
  AssertEqualErrors(error, expectedError);
}

- (NSArray<NSNumber *>*)assertFloatEmbeddingResultsOfEmbedText:(NSString *)text
                usingTextEmbedder:(MPPTextEmbedder *)textEmbedder
                   hasCount:(NSUInteger)embeddingCount 
                   firstValue:(float)firstValue {
  MPPTextEmbedderResult *embedderResult = [textEmbedder embedText:text error:nil];
  AssertTextEmbedderResultHasOneEmbedding(embedderResult);
  AssertEmbeddingIsFloat(embedderResult.embeddingResult.embeddings[0]);
  AssertFloatEmbeddingHasExpectedValues(embedderResult.embeddingResult.embeddings[0].floatEmbedding,
                            embeddingCount, firstValue);
  return embedderResult.embeddingResult.embeddings[0];
}

- (NSArray<NSNumber *>*)assertQuantizedEmbeddingResultsOfEmbedText:(NSString *)text
                usingTextEmbedder:(MPPTextEmbedder *)textEmbedder
                   hasCount:(NSUInteger)embeddingCount 
                   firstValue:(char)firstValue {
  MPPTextEmbedderResult *embedderResult = [textEmbedder embedText:text error:nil];
  AssertTextEmbedderResultHasOneEmbedding(embedderResult);
  AssertEmbeddingIsQuantized(embedderResult.embeddingResult.embeddings[0]);
  AssertQuantizedEmbeddingHasExpectedValues(embedderResult.embeddingResult.embeddings[0].quantizedEmbedding,
                            embeddingCount, firstValue);
  return embedderResult.embeddingResult.embeddings[0];
}

- (void)testCreateTextEmbedderFailsWithMissingModelPath {
  NSString *modelPath = [self filePathWithName:@"" extension:@""];

  NSError *error = nil;
  MPPTextEmbedder *textEmbedder = [[MPPTextEmbedder alloc] initWithModelPath:modelPath
                                                                             error:&error];
  XCTAssertNil(textEmbedder);

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

- (void)testEmbedWithBertSucceeds {
  MPPTextEmbedder *textEmbedder =
      [self textEmbedderFromModelFileWithName:kBertTextEmbedderModelName];

  MPPEmbedding *embedding1 = [self assertFloatEmbeddingResultsOfEmbedText:@"it's a charming and often affecting journey"
                usingTextEmbedder:textEmbedder
                   hasCount:512
                   firstValue:20.057026f];

  MPPEmbedding *embedding2 = [self assertFloatEmbeddingResultsOfEmbedText:@"what a great and fantastic trip"
                usingTextEmbedder:textEmbedder
                   hasCount:512
                   firstValue:21.254150f];
  NSNumber *cosineSimilarity = [MPPTextEmbedder cosineSimilarityBetweenEmbedding1:embedding1 andEmbedding2:embedding2 error:nil];  
  XCTAssertEqualWithAccuracy(cosineSimilarity.doubleValue, 0.96386, 1e-4f); 
}

- (void)testEmbedWithRegexSucceeds {
  MPPTextEmbedder *textEmbedder =
      [self textEmbedderFromModelFileWithName:kRegexTextEmbedderModelName];

  MPPEmbedding *embedding1 = [self assertFloatEmbeddingResultsOfEmbedText:@"it's a charming and often affecting journey"
                usingTextEmbedder:textEmbedder
                   hasCount:16
                   firstValue:0.030935612f];

  MPPEmbedding *embedding2 = [self assertFloatEmbeddingResultsOfEmbedText:@"what a great and fantastic trip"
                usingTextEmbedder:textEmbedder
                   hasCount:16
                   firstValue:0.0312863f];

  NSNumber *cosineSimilarity = [MPPTextEmbedder cosineSimilarityBetweenEmbedding1:embedding1 andEmbedding2:embedding2 error:nil];  
  XCTAssertEqualWithAccuracy(cosineSimilarity.doubleValue, 0.999937f, 1e-4f); 
}

- (void)testedEMbWithQuantizeSucceeds {
  MPPTextEmbedderOptions *options =
      [self textEmbedderOptionsWithModelName:kBertTextEmbedderModelName];
  options.quantize = YES;

  MPPTextEmbedder *textEmbedder = [[MPPTextEmbedder alloc] initWithOptions:options error:nil];
  XCTAssertNotNil(textEmbedder);

  MPPEmbedding *embedding1 = [self assertQuantizedEmbeddingResultsOfEmbedText:@"it's a charming and often affecting journey"
                usingTextEmbedder:textEmbedder
                   hasCount:512
                   firstValue:0];

  MPPEmbedding *embedding2 = [self assertQuantizedEmbeddingResultsOfEmbedText:@"what a great and fantastic trip"
                usingTextEmbedder:textEmbedder
                   hasCount:512
                   firstValue:0];
  NSNumber *cosineSimilarity = [MPPTextEmbedder cosineSimilarityBetweenEmbedding1:embedding1 andEmbedding2:embedding2 error:nil];  
  XCTAssertEqualWithAccuracy(cosineSimilarity.doubleValue, 0.0, 1e-4f); 
}

@end
