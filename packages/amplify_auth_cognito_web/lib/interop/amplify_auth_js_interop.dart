@JS('aws_amplify')
library amplifycore;

import 'package:js/js.dart';

@JS('Auth')
abstract class AuthJS {
  external static AuthJS signUp(SignUpParams signUpParams);
}

@JS()
@anonymous // needed along with factory constructor
class SignUpParams {
  external Attributes get attributes;
  external factory SignUpParams({
    username,
    password,
    attributes
  });
}

@JS()
@anonymous // needed along with factory constructor
class Attributes {
  external factory Attributes({
    email
  });
}

