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

#include "mediapipe/tasks/ios/text/text_classifier/sources/objc_text_classifier_graph.h"

#include <cstdint>
#include <string>
#include <type_traits>

#include "absl/status/status.h"
#include "mediapipe/framework/api2/builder.h"
#include "mediapipe/framework/api2/port.h"
#include "mediapipe/framework/calculator_framework.h"
#include "mediapipe/tasks/cc/components/processors/classification_postprocessing_graph.h"
#include "mediapipe/tasks/cc/components/processors/proto/classification_postprocessing_graph_options.pb.h"
#include "mediapipe/tasks/cc/components/processors/proto/text_preprocessing_graph_options.pb.h"
#include "mediapipe/tasks/cc/components/processors/text_preprocessing_graph.h"
#include "mediapipe/tasks/cc/core/proto/model_resources_calculator.pb.h"

namespace mediapipe {
namespace tasks {
namespace text {
namespace text_classifier {

namespace {

using ::mediapipe::api2::Input;
using ::mediapipe::api2::Output;

constexpr char kClassificationsTag[] = "CLASSIFICATIONS";
constexpr char kTextTag[] = "TEXT";
constexpr char kMetadataExtractorTag[] = "METADATA_EXTRACTOR";
constexpr char kTensorsTag[] = "TENSORS";

}  // namespace

absl::StatusOr<CalculatorGraphConfig> ObjcTextClassifierGraph::GetConfig(
      SubgraphContext* sc) {
    ASSIGN_OR_RETURN(
        const ModelResources* model_resources,
        CreateModelResources<proto::TextClassifierGraphOptions>(sc));
    Graph graph;
    ASSIGN_OR_RETURN(
        auto classifications,
        BuildTextClassifierTask(
            sc->Options<proto::TextClassifierGraphOptions>(), *model_resources,
            graph[Input<std::string>(kTextTag)], graph));
    classifications >> graph[Output<ClassificationResult>(kClassificationsTag)];
    return graph.GetConfig();
  }
 
  absl::StatusOr<Source<ClassificationResult>> ObjcTextClassifierGraph::BuildTextClassifierTask(
      const proto::TextClassifierGraphOptions& task_options,
      const ModelResources& model_resources, Source<std::string> text_in,
      Graph& graph) {
    // Adds preprocessing calculators and connects them to the text input
    // stream.
    auto& preprocessing = graph.AddNode(
        "mediapipe.tasks.components.processors.TextPreprocessingGraph");
    MP_RETURN_IF_ERROR(components::processors::ConfigureTextPreprocessingGraph(
        model_resources,
        preprocessing.GetOptions<
            components::processors::proto::TextPreprocessingGraphOptions>()));
    text_in >> preprocessing.In(kTextTag);

    // Adds both InferenceCalculator and ModelResourcesCalculator.
    auto& inference = AddInference(
        model_resources, task_options.base_options().acceleration(), graph);
    // The metadata extractor side-output comes from the
    // ModelResourcesCalculator.
    inference.SideOut(kMetadataExtractorTag) >>
        preprocessing.SideIn(kMetadataExtractorTag);
    preprocessing.Out(kTensorsTag) >> inference.In(kTensorsTag);

    // Adds postprocessing calculators and connects them to the graph output.
    auto& postprocessing = graph.AddNode(
        "mediapipe.tasks.components.processors."
        "ClassificationPostprocessingGraph");
    MP_RETURN_IF_ERROR(
        components::processors::ConfigureClassificationPostprocessingGraph(
            model_resources, task_options.classifier_options(),
            &postprocessing
                 .GetOptions<components::processors::proto::
                                 ClassificationPostprocessingGraphOptions>()));
    inference.Out(kTensorsTag) >> postprocessing.In(kTensorsTag);

    // Outputs the aggregated classification result as the subgraph output
    // stream.
    return postprocessing[Output<ClassificationResult>(kClassificationsTag)];
  }

}  // namespace text_classifier
}  // namespace text
}  // namespace tasks
}  // namespace mediapipe
