@JS('aws_amplify')
library amplifycore;

import 'package:js/js.dart';


@JS('Amplify')
abstract class AmplifyJS {
  external static num get length;
  external static AmplifyJS configure(ConfigOptions config);
}


@JS()
@anonymous // needed along with factory constructor
class ConfigOptions {
  external factory ConfigOptions({ auth });
  external AuthOptions get auth;
}

@JS()
@anonymous // needed along with factory constructor
class AuthOptions {
  external factory AuthOptions({ aws_project_region });
  external String get aws_project_region;
}