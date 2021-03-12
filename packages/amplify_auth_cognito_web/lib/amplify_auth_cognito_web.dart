import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:collection';
import 'package:js/js_util.dart';
import 'package:amplify_core/types/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:amplify_core/interop/object.dart';
import 'interop/amplify_auth_js_interop.dart';
import './types/types.dart';


/// A web implementation of the AmplifyAuthCognitoWeb plugin.
class AmplifyAuthCognitoWebWeb extends AmplifyPluginInterface   {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'com.amazonaws.amplify/auth_cognito',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = AmplifyAuthCognitoWebWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'addPlugin':
        return true;
        break;
      case 'signUp':
        return onSignUp(call.arguments);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amplify_auth_cognito_web for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  Future<Map<String, dynamic>> onSignUp(LinkedHashMap<dynamic, dynamic> arguments) async {
      var res = await promiseToFuture(AuthJS.signUp(SignUpParams(
        username: arguments["data"]["username"],
        password: arguments["data"]["password"],
        attributes: Attributes(
          email: arguments["data"]["options"]["userAttributes"]["email"]
        )
      )));
      var signUpResult = SignUpResultJS.init(jsToMap(res)).serializeAsMap();
      return Future.value(signUpResult);
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}
