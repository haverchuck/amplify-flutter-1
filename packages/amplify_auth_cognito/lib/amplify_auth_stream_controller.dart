import 'dart:async';

import 'package:flutter/services.dart';

import 'package:amplify_hub/categories_types/auth/AuthHubEvent.dart';
import 'package:amplify_hub/categories_types/auth/SignedInHubEvent.dart';
import 'package:amplify_hub/categories_types/auth/SignedOutHubEvent.dart';
import 'package:amplify_hub/categories_types/auth/SessionExpiredHubEvent.dart';
import 'package:amplify_hub/categories_types/HubEvent.dart';

EventChannel channel = const EventChannel("com.amazonaws.amplify/auth_cognito_events");
var eventStream;

StreamController authStreamController = StreamController<AuthHubEvent>.broadcast(
  onListen: onListen,
  onCancel: onCancel,
);


onListen() {
  eventStream = channel.receiveBroadcastStream(1).listen((event) {
    switch(event["eventName"]) {
      case "SIGNED_IN": {
        authStreamController.add(SignedInHubEvent());
      }
      break;
      case "SIGNED_OUT": {
        authStreamController.add(SignedOutHubEvent());
      }
      break;
      case "SESSION_EXPIRED": {
        authStreamController.add(SessionExpiredHubEvent());
      }
      break;
      // default: {
      //   authStreamController.add(AuthHubEvent());
      // }
    }
  });
}

onCancel() {
  if (authStreamController.hasListener) {
    eventStream.cancel();
  }
}