/* Copyright 2022 The MediaPipe Authors. All Rights Reserved.

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

#ifndef MEDIAPIPE_TASKS_CC_COMPONENTS_CALCULATORS_CLASSIFICATION_POSTPROCESSING_CALCULATOR_H_
#define MEDIAPIPE_TASKS_CC_COMPONENTS_CALCULATORS_CLASSIFICATION_POSTPROCESSING_CALCULATOR_H_

#include "absl/status/status.h"
#include "mediapipe/tasks/cc/components/processors/proto/classification_postprocessing_graph_options.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/classifier_options.pb.h"
#include "mediapipe/tasks/cc/core/model_resources.h"
#include "mediapipe/tasks/cc/metadata/metadata_extractor.h"

namespace mediapipe {
namespace api2 {
void register_classification_aggregation_calculator();
}  // namespace tasks
}  // namespace mediapipe

#endif  // MEDIAPIPE_TASKS_CC_COMPONENTS_PROCESSORS_CLASSIFICATION_POSTPROCESSING_GRAPH_H_
