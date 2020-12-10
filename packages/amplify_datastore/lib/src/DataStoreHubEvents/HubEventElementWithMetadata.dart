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

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'HubEventElement.dart';

class HubEventElementWithMetadata extends HubEventElement {
  int _version;
  int _lastChangedAt;
  bool _deleted;
  HubEventElementWithMetadata(Map<dynamic, dynamic> serializedData, ModelProviderInterface provider) : super(serializedData, provider) {
    Map<String, dynamic> serializedElement = new Map<String, dynamic>.from(serializedData["element"]);
    _version = serializedElement["_version"];
    _lastChangedAt = serializedElement["_lastChangedAt"]; 
    _deleted = serializedElement["_deleted"];
  }
}