import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth_cognito_web/amplify_auth_cognito_web.dart';

void main() {
  const MethodChannel channel = MethodChannel('amplify_auth_cognito_web');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AmplifyAuthCognitoWeb.platformVersion, '42');
  });
}
