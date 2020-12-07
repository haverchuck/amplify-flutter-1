library amplify_hub;

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

import 'package:amplify_hub/categories_types/auth/AuthHubEvent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import 'categories_types/HubEvent.dart';

typedef Listener = void Function(HubEvent msg);
typedef void ErrorHandler(dynamic err);
typedef void CancelListening();


class HubChannel {

  StreamController controller;
  String name;
  Stream controllerStream;
  HubChannel(StreamController streamController, String name) {
    controller = streamController;
    controllerStream = streamController.stream;
  }
  

  StreamSubscription listen(Listener listener) {
    return controllerStream.listen(listener);
  }

  void onListen() {
    controller.onListen();
  }

  void onPause() {
    controller.onPause();
  }

  void onResume() {
    controller.onResume();
  }


  void add(event) {
    if (controller.add != null) {
      controller.add(event);
    } else {
      throw UnimplementedError("add is not inmplmented on ${name} HubChannel");
    }
  }

  void addError(Object error, [StackTrace stackTrace]) {
    if (controller.addError != null) {
      controller.addError(error, stackTrace);
    } else {
      throw UnimplementedError("addError is not inmplmented on ${name} HubChannel");
    }
  }
  
  void addStream(Stream source, {bool cancelOnError = false}) {
    if (controller.addStream != null) {
      controller.addStream(source, cancelOnError: cancelOnError);
    } else {
      throw UnimplementedError("addStream is not inmplmented on ${name} HubChannel");
    }
  }

  void close() {
    if (controller.close != null) {
      controller.close();
    } else {
      throw UnimplementedError("close is not inmplmented on ${name} HubChannel");
    }
  }

  // TODO: Finish these!

  // @override
  // // TODO: implement done
  // Future get done => throw UnimplementedError();

  // @override
  // // TODO: implement hasListener
  bool get hasListener => throw UnimplementedError("getter hasListener is not inmplmented on ${name} HubChannel");

  // @override
  // // TODO: implement isClosed
  // bool get isClosed => throw UnimplementedError();

  // @override
  // // TODO: implement isPaused
  // bool get isPaused => throw UnimplementedError();

  // @override
  // // TODO: implement sink
  // StreamSink get sink => throw UnimplementedError();

  // @override
  // // TODO: implement stream
  // Stream get stream => throw UnimplementedError();

} 
