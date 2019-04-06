#import <UIKit/UIKit.h>
#import <Headers/Headers.h>
#import <ModernDepictions/ModernHome/ModernHomeController.h>

@interface HomeController : CyteViewController
@end

%group ModernHome
%hook Cydia

- (__kindof UIViewController *)pageForURL:(NSURL *)url forExternal:(BOOL)external withReferrer:(id)referrer {
	NSLog(@"pageForURL:\"%@\" forExternal:%d withReferrer:\"%@\"", url, external, referrer);
	if ([[url absoluteString] isEqualToString:@"cydia://home"]) return [ModernHomeController new];
	return %orig;
}

%end
%end

void ModernDepictionsInitializeHome(void) {
	%init(ModernHome);
}