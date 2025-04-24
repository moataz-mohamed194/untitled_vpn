#import "OpenvpnFlutterPlugin.h"
#if __has_include(<oneconnect_flutter/oneconnect_flutter-Swift.h>)
#import <oneconnect_flutter/oneconnect_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "oneconnect_flutter-Swift.h"
#endif

@implementation OpenVPNFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenVPNFlutterPlugin registerWithRegistrar:registrar];
}
@end
