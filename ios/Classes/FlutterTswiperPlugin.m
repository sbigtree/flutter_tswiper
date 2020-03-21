#import "FlutterTswiperPlugin.h"
#if __has_include(<flutter_tswiper/flutter_tswiper-Swift.h>)
#import <flutter_tswiper/flutter_tswiper-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_tswiper-Swift.h"
#endif

@implementation FlutterTswiperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterTswiperPlugin registerWithRegistrar:registrar];
}
@end
