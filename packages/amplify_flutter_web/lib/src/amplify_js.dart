@JS('aws_amplify')
library amplifycore;

import 'package:js/js.dart';


@JS('Amplify')
abstract class AmplifyJS {
  external static AmplifyJS configure(ConfigOptions config);
}


@JS()
@anonymous // needed along with factory constructor
class ConfigOptions {
  external factory ConfigOptions({ Auth });
  external AuthOptions get Auth;
}

@JS()
@anonymous // needed along with factory constructor
class AuthOptions {
  external factory AuthOptions({
    identityPoolRegion,
    identityPoolId,
    region,
    userPoolId,
    userPoolWebClientId
  });
}

// @JS('Auth')
// abstract class AuthJS {
//   external static AuthJS signUp(SignUpParams signUpParams);
// }

// @JS()
// @anonymous // needed along with factory constructor
// class SignUpParams {
//   external Attributes get attributes;
//   external factory SignUpParams({
//     username,
//     password,
//     attributes
//   });
// }

// @JS()
// @anonymous // needed along with factory constructor
// class Attributes {
//   external factory Attributes({
//     email
//   });
// }

