// Copyright 2022 The MediaPipe Authors. All Rights Reserved.
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

#import "mediapipe/tasks/ios/components/utils/sources/MPPCosineSimilarity.h"

#import "mediapipe/tasks/ios/common/sources/MPPCommon.h"
#import "mediapipe/tasks/ios/common/utils/sources/MPPCommonUtils.h"

#include <math.h>

@implementation MPPCosineSimilarity

+ (double)computeFloatBetweenVecotr1:(NSArray<NSNumber *> *)u andVector2:(NSArray<NSNumber *> *)v error:(NSError **)error {
    if (u.count != v.count) {
        [MPPCommonUtils
        createCustomError:error
                 withCode:MPPTasksErrorCodeInvalidArgumentError
              description:[NSString stringWithFormat:@"Cannot compute cosine similarity between embeddings of different sizes (%d vs %d)", u.count, v.count]];
    }

    double dotProduct = 0.0;
    double normU = 0.0;
    double normV = 0.0;

  [u enumerateObjectsUsingBlock:^(NSNumber num, NSUInteger idx, BOOL *stop) {
      uFloat = num.floatValue;
      vFloat = v[idx].floatValue;
      
      dotProduct += uFloat * vFloat;
      normU += uFloat * uFloat;
      normV = vFloat * vFloat;
  }];

  return dotProduct / sqrt(normU, normV);
}

+ (double)computeBetweenVector1:(NSArray<NSNumber *> *)u andVector2:(NSArray<NSNumber *> *)v isFloat:(BOOL) error:(NSError **)error {
    if (u.count != v.count) {
        [MPPCommonUtils
        createCustomError:error
                 withCode:MPPTasksErrorCodeInvalidArgumentError
              description:[NSString stringWithFormat:@"Cannot compute cosine similarity between embeddings of different sizes (%d vs %d)", u.count, v.count]];
    }

    double dotProduct = 0.0;
    double normU = 0.0;
    double normV = 0.0;

  [u enumerateObjectsUsingBlock:^(NSNumber num, NSUInteger idx, BOOL *stop) {
      uFloat = num.floatValue;
      vFloat = v[idx].floatValue;

      dotProduct += uFloat * vFloat;
      normU += uFloat * uFloat;
      normV = vFloat * vFloat;
  }];

  return dotProduct / sqrt(normU, normV);
}

+ (double)computeBetweenEmbedding1:(MPPEmbedding *)embedding1 andEmbedding2:(MPPEmbedding *)embedding2 error:(NSError **)error {

  BOOL isFloat;

  if ((embedding1.floatEmbedding && embedding2.quantizedEmbedding) || (embedding1.quantizedEmbedding && embedding2.floatEmbedding)) {
      [MPPCommonUtils
        createCustomError:error
                 withCode:MPPTasksErrorCodeInvalidArgumentError
              description:[NSString stringWithFormat:@"Cannot compute cosine similarity between embeddings of different sizes (%d vs %d)", u.count, v.count]];
      return 0.0;
  }

}


@end
