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

#import "mediapipe/tasks/ios/common/utils/sources/NSString+Helpers.h"
#import "mediapipe/tasks/ios/components/containers/utils/sources/MPPEmbedding+Helpers.h"

#include <memory>

namespace {
using EmbeddingProto = ::mediapipe::tasks::components::containers::proto::Embedding;
}

@implementation MPPEmbedding (Helpers)

+ (MPPEmbedding *)embeddingWithProto:(const EmbeddingProto &)embeddingProto {
  NSString *categoryName;
  NSString *displayName;

  float *floatEmbedding = nullptr;
  char *quantizedEmbedding = nullptr;

  if (embeddingProto.has_float_embedding()) {
    floatEmbedding = new float(embeddingProto.float_embedding().values_size());
    std::memcpy(
            floatEmbedding,
            reinterpret_cast<const float*>(embeddingProto.float_embedding()
                                               .values()
                                               .data()),
            embeddingProto.float_embedding().values_size() * sizeof(float));
  }

  if (embeddingProto.has_quantized_embedding()) {
    const std::string& cppQuantizedEmbedding =
        embeddingProto.quantized_embedding().values().data();
    
    const int cppQuantizedEmbeddingLength = cppQuantizedEmbedding.length() + 1;
    
    quantizedEmbedding = new char(cppQuantizedEmbeddingLength);
    std::memcpy(
            quantizedEmbedding,
            reinterpret_cast<const char*>(cppQuantizedEmbedding.c_str()),
            cppQuantizedEmbeddingLength * sizeof(char));
  }

  NSString *headName;

  if (embeddingProto.has_head_name()) {
    headName = [NSString stringWithCppString:embeddingProto.head_name()];
  }

  return [[MPPEmbedding alloc] initWithFloatEmbedding:floatEmbedding
                        quantizedEmbedding:quantizedEmbedding
                             headIndex:embeddingProto.head_index()
                             headName:headName];
}

@end
