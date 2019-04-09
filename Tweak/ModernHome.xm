#import <UIKit/UIKit.h>
#import <Headers/Headers.h>
#import <ModernDepictions/ModernHome/ModernHomeController.h>
#import "Tweak.h"

@interface HomeController : CyteViewController
@end

static void _logos_method$ModernHome$Shared$didSelectPackage$(UIViewController *self, SEL _cmd, NSString *packageID) {
	Package *package = [[%c(Database) sharedInstance] packageWithName:packageID];
	NSLog(@"Did select: %@", package);
	[self.navigationController
		pushViewController:[(Cydia *)[UIApplication sharedApplication]
			pageForPackage:[package id]
			withReferrer:ModernDepictionsGeneratePackageURL([package id])
		]
		animated:YES
	];
}

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
	class_addMethod(
		objc_getClass("ModernHomeController"),
		@selector(didSelectPackage:),
		(IMP)_logos_method$ModernHome$Shared$didSelectPackage$,
		"@:@"
	);
	class_addMethod(
		objc_getClass("SectionController"),
		@selector(didSelectPackage:),
		(IMP)_logos_method$ModernHome$Shared$didSelectPackage$,
		"@:@"
	);
}