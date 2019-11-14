/*
 * That's the trash can. Feel free to visit it any time.
 * ~ Papyrus
 */

#import <UIKit/UIKit.h>
#import <ModernDepictions.h>

%ctor {
	NSSet *set = [NSSet setWithArray:@[
		@"com.saurik.Cydia"
	]];
	if (![set containsObject:NSBundle.mainBundle.bundleIdentifier]) {
		// You never know what the end user will do.
		return;
	}
	MDInitializeCore();
	MDInitializeDepictions();
}