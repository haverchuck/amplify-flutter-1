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

import 'dart:async';
import 'package:amplify_datastore/src/DataStoreHubEvents/DataStoreHubEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/ModelSyncedEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/NetworkStatusEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/OutboxMutationProcessedEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/ReadyEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/SubscriptionsEstablishedEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/SyncQueriesReadyEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/SyncQueriesStartedEvent.dart';
import 'package:amplify_datastore/src/DataStoreHubEvents/OutboxMutationEnqueuedEvent.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';

import 'package:flutter/services.dart';

EventChannel channel = const EventChannel("com.amazonaws.amplify/datastore_hub_events");
ModelProviderInterface modelProvider;
StreamSubscription eventStream;

class StreamControllerWithModels {
  
  StreamController get datastoreStreamController {
    return controller;
  }

  void registerModelsForHub(ModelProviderInterface models) {
    modelProvider = models;
  }
}

StreamController controller = StreamController<DataStoreHubEvent>.broadcast(
  onListen: onListen,
  onCancel: onCancel,
);

onListen() {
  if (eventStream == null ) {
    eventStream = channel.receiveBroadcastStream(1).listen((event) {
      print(event);
      switch(event["eventName"]) {
        case "ready": {
          controller.add(ReadyEvent());
        }
        break;
        case "networkStatus": {
          controller.add(NetworkStatusEvent(event));
        }
        break;
        case 'subscriptionsEstablished': {
          controller.add(SubscriptionsEstablishedEvent());
        }
        break;
        case "syncQueriesStarted": {
          controller.add(SyncQueriesStartedEvent(event));
        }
        break;
        case "modelSynced": {
          controller.add(ModelSyncedEvent(event));
        }
        break;
        case "syncQueriesReadyEvent": {
          controller.add(SyncQueriesReadyEvent());
        }
        break;
        case "outboxMutationEnqueued": {
          controller.add(OutboxMutationEnqueuedEvent(event, modelProvider));
        }
        break;
        case "outboxMutationProcessed": {
          controller.add(OutboxMutationProcessedEvent(event, modelProvider));
        }
        break;
      // default: {
      //   authStreamController.add(AuthHubEvent());
      // }
      }
    });
  }
}

onCancel() {
  if (!controller.hasListener) {
    eventStream.cancel();
    print(eventStream);
  }
}