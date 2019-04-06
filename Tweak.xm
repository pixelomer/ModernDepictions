#import <Foundation/Foundation.h>
#import <Tweak/Tweak.h>

extern "C" void _CFEnableZombies();

%hook Cydia

// For some reason Cydia forgets its superclass when GADMobileAds exists
- (Class)superclass {
	return %c(CyteApplication);
}

%end

%ctor {
	%init;
	if ([%c(Package) instancesRespondToSelector:@selector(getField:)] &&
		ModernDepictionsGetPreferenceValue(@"EnableModernDepictions", 1))
	{
		NSLog(@"init");
		_CFEnableZombies();
		ModernDepictionsInitializeCore();
		if (ModernDepictionsGetPreferenceValue(@"EnableSileoDepictions", 1)) {
			ModernDepictionsInitializeDepictions();
		}
		if (ModernDepictionsGetPreferenceValue(@"EnableModernHomeController", 0)) {
			ModernDepictionsInitializeHome();
		}
		if (ModernDepictionsGetPreferenceValue(@"EnableModernPackageCells", 0)) {
			ModernDepictionsInitializeCells();
		}
	}
}