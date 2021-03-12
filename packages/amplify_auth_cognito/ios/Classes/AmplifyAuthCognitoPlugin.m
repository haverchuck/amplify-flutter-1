#import "AmplifyAuthCognitoPlugin.h"
#if __has_include(<amplify_auth_cognito/amplify_auth_cognito-Swift.h>)
#import <amplify_auth_cognito/amplify_auth_cognito-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amplify_auth_cognito-Swift.h"
#endif

@implementation AmplifyAuthCognitoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmplifyAuthCognitoPlugin registerWithRegistrar:registrar];
}
@end
