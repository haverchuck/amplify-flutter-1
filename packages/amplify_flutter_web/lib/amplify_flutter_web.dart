import 'dart:js' as js;
import "dart:convert";
import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'src/amplify_js.dart';
import 'package:amplify_core/interop/object.dart';
import 'package:js/js_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the AmplifyFlutterWeb plugin.
class AmplifyFlutterWebWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'com.amazonaws.amplify/amplify',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = AmplifyFlutterWebWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'configure':
        return onConfigure();
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'amplify_flutter_web for web doesn\'t implement \'${call.method}\''
        );
    }
  }


  Future<bool> onConfigure() async {
    try {
      AmplifyJS.configure(ConfigOptions(Auth: AuthOptions(
        region: 'us-west-2',
        identityPoolId: '',
        identityPoolRegion: 'us-west-2',
        userPoolId: 'us-west-',
        userPoolWebClientId: ''
      )));

      return Future.value(true);
    } catch (e) {
      print(jsToMap(e));
      return false;
    }
  }
}