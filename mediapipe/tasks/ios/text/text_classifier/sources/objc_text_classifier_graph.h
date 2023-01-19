/* Copyright 2023 The MediaPipe Authors. All Rights Reserved.

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

#ifndef MEDIAPIPE_TASKS_CC_TEXT_TEXT_CLASSIFIER_TEXT_CLASSIFIER_H_
#define MEDIAPIPE_TASKS_CC_TEXT_TEXT_CLASSIFIER_TEXT_CLASSIFIER_H_

#include "absl/status/statusor.h"
#include "mediapipe/framework/calculator.pb.h"
#include "mediapipe/tasks/cc/components/containers/proto/classifications.pb.h"
#include "mediapipe/tasks/cc/core/model_task_graph.h"
#include "mediapipe/tasks/cc/core/model_resources.h"
#include "mediapipe/tasks/cc/text/text_classifier/proto/text_classifier_graph_options.pb.h"


namespace mediapipe {
namespace tasks {
namespace text {
namespace text_classifier {

using ::mediapipe::api2::builder::Graph;
using ::mediapipe::api2::builder::Source;
using ::mediapipe::tasks::components::containers::proto::ClassificationResult;
using ::mediapipe::tasks::core::ModelResources;

// A "TextClassifierGraph" performs Natural Language classification (including
// BERT-based text classification).
// - Accepts input text and outputs classification results on CPU.
//
// Inputs:
//   TEXT - std::string
//     Input text to perform classification on.
//
// Outputs:
//   CLASSIFICATIONS - ClassificationResult @Optional
//     The classification results aggregated by classifier head.
//
// Example:
// node {
//   calculator: "mediapipe.tasks.text.text_classifier.TextClassifierGraph"
//   input_stream: "TEXT:text_in"
//   output_stream: "CLASSIFICATIONS:classifications_out"
//   options {
//     [mediapipe.tasks.text.text_classifier.proto.TextClassifierGraphOptions.ext]
//     {
//       base_options {
//         model_asset {
//           file_name: "/path/to/model.tflite"
//         }
//       }
//     }
//   }
// }
class ObjcTextClassifierGraph : public core::ModelTaskGraph {
 public:
  absl::StatusOr<CalculatorGraphConfig> GetConfig(SubgraphContext* sc) override;
  static void register_graph() {
    REGISTER_MEDIAPIPE_GRAPH(
    ::mediapipe::tasks::text::text_classifier::ObjcTextClassifierGraph);
  }

private:
  // Adds a mediapipe TextClassifier task graph into the provided
  // builder::Graph instance. The TextClassifier task takes an input
  // text (std::string) and returns one classification result per output head
  // specified by the model.
  //
  // task_options: the mediapipe tasks TextClassifierGraphOptions proto.
  // model_resources: the ModelResources object initialized from a
  //   TextClassifier model file with model metadata.
  // text_in: (std::string) stream to run text classification on.
  // graph: the mediapipe builder::Graph instance to be updated.
  absl::StatusOr<Source<ClassificationResult>> BuildTextClassifierTask(
      const proto::TextClassifierGraphOptions& task_options,
      const ModelResources& model_resources, Source<std::string> text_in,
      Graph& graph);
};

}  // namespace text_classifier
}  // namespace text
}  // namespace tasks
}  // namespace mediapipe

#endif  // MEDIAPIPE_TASKS_CC_TEXT_TEXT_CLASSIFIER_TEXT_CLASSIFIER_H_
