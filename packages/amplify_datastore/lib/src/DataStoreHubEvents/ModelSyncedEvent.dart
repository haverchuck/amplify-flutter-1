/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'package:amplify_datastore/src/DataStoreHubEvents/DataStoreHubEvent.dart';

class ModelSyncedEvent extends DataStoreHubEvent {
  String modelName;
  bool isFullSync;
  bool isDeltaSync;
  int added;
  int updated;
  int deleted;
  ModelSyncedEvent(Map<String, dynamic> serializedData) {
    modelName = serializedData["modelName"];
    isFullSync = serializedData["isFullSync"];
    isDeltaSync = serializedData["isDeltaSync"];
    added = serializedData["added"];
    updated = serializedData["updated"];
    deleted = serializedData["deleted"];
  }
}