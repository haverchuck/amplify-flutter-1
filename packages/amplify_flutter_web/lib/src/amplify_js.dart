@JS()
library amplifycore;

import 'package:js/js.dart';


@JS('aws_amplify.Amplify')
class AmplifyJS {
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