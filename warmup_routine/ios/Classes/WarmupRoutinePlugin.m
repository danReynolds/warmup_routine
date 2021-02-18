#import "WarmupRoutinePlugin.h"
#if __has_include(<warmup_routine/warmup_routine-Swift.h>)
#import <warmup_routine/warmup_routine-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "warmup_routine-Swift.h"
#endif

@implementation WarmupRoutinePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWarmupRoutinePlugin registerWithRegistrar:registrar];
}
@end
