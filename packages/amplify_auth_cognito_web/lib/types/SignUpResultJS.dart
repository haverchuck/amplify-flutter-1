import 'package:amplify_core/interop/object.dart';

class SignUpResultJS {
  String signUpStep;
  bool isSignUpComplete;
  Map additionalInfo = {};
  Map codeDeliveryDetails = {};
  SignUpResultJS.init(Map res) {
    var codeMap = jsToMap(res["codeDeliveryDetails"]);
    isSignUpComplete = res["userConfirmed"];
    signUpStep = res["userConfirmed"] ? "DONE" : "CONFIRM_SIGN_UP_STEP";
    codeDeliveryDetails["attributeName"] = codeMap["AttributeName"];
    codeDeliveryDetails["deliveryMedium"] = codeMap["DeliveryMedium"];
    codeDeliveryDetails["destination"] = codeMap["Destination"];
  }

  Map<String, dynamic> serializeAsMap() {
    final Map<String, dynamic> pendingRequest = <String, dynamic>{};
    final Map<String, dynamic> nextStep = <String, dynamic>{};
    nextStep['signUpStep'] = signUpStep;
    nextStep['additionalInfo'] = additionalInfo;
    nextStep['codeDeliveryDetails'] = codeDeliveryDetails;
    pendingRequest['isSignUpComplete'] = isSignUpComplete;
    pendingRequest['nextStep'] = nextStep;
    return pendingRequest;
  }
}