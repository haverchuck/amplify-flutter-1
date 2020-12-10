import 'dart:async';

import 'package:flutter/services.dart';
import 'src/CognitoHubEvents/AuthHubEvent.dart';
import 'src/CognitoHubEvents/SessionExpiredHubEvent.dart';
import 'src/CognitoHubEvents/SignedInHubEvent.dart';
import 'src/CognitoHubEvents/SignedOutHubEvent.dart';

EventChannel channel = const EventChannel("com.amazonaws.amplify/auth_cognito_events");
var eventStream;

StreamController authStreamController = StreamController<AuthHubEvent>.broadcast(
  onListen: onListen,
  onCancel: onCancel,
);


onListen() {
  if (eventStream == null ) {
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
}

onCancel() {
  if (!authStreamController.hasListener) {
    eventStream.cancel();
  }
}