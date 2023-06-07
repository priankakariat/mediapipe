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

#import <Foundation/Foundation.h>
#import "mediapipe/tasks/ios/components/containers/sources/MPPConnection.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The enum containing the 21 hand landmarks.
 */
static NSArray<MPPConnection *> *const kHandPalmConnections = @[
  [[MPPConnection alloc] initWithStart:0 end:1],
  [[MPPConnection alloc] initWithStart:0 end:5],
  [[MPPConnection alloc] initWithStart:9 end:13],
  [[MPPConnection alloc] initWithStart:13 end:17],
  [[MPPConnection alloc] initWithStart:5 end:9],
  [[MPPConnection alloc] initWithStart:0 end:17]
];

static NSArray<MPPConnection *> *const kHandThumbConnections = @[
  [[MPPConnection alloc] initWithStart:1 end:2],
  [[MPPConnection alloc] initWithStart:2 end:3],
  [[MPPConnection alloc] initWithStart:3 end:4]
];

static NSArray<MPPConnection *> *const kHandIndexFingerConnections = @[
  [[MPPConnection alloc] initWithStart:5 end:6],
  [[MPPConnection alloc] initWithStart:6 end:7],
  [[MPPConnection alloc] initWithStart:7 end:8]
];

static NSArray<MPPConnection *> *const kHandMiddleFingerConnections = @[
  [[MPPConnection alloc] initWithStart:9 end:10],
  [[MPPConnection alloc] initWithStart:10 end:11],
  [[MPPConnection alloc] initWithStart:11 end:12]
];

static NSArray<MPPConnection *> *const kHandRingFingerConnections = @[
  [[MPPConnection alloc] initWithStart:13 end:14],
  [[MPPConnection alloc] initWithStart:14 end:15],
  [[MPPConnection alloc] initWithStart:15 end:16]
];

static NSArray<MPPConnection *> *const kHandPinkyConnections = @[
  [[MPPConnection alloc] initWithStart:16 end:17],
  [[MPPConnection alloc] initWithStart:17 end:18],
  [[MPPConnection alloc] initWithStart:18 end:19]
];

static NSArray<MPPConnection *> *const kHandConnections = @[
  [[MPPConnection alloc] initWithStart:16 end:17],
  [[MPPConnection alloc] initWithStart:17 end:18],
  [[MPPConnection alloc] initWithStart:18 end:19]
];

static 

NS_ASSUME_NONNULL_END
