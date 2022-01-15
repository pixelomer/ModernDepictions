#import <Foundation/Foundation.h>
#import <Tweak/Tweak.h>

%ctor {
	%init;
	if ([%c(Package) instancesRespondToSelector:@selector(getField:)] &&
		ModernDepictionsGetPreferenceValue(@"EnableModernDepictions", 1))
	{
		NSLog(@"init");
		ModernDepictionsInitializeCore();
		if (ModernDepictionsGetPreferenceValue(@"EnableSileoDepictions", 1)) {
			ModernDepictionsInitializeDepictions();
		}
		if (ModernDepictionsGetPreferenceValue(@"EnableModernHomeController", 1)) {
			ModernDepictionsInitializeHome();
		}
		if (ModernDepictionsGetPreferenceValue(@"EnableModernPackageCells", 0)) {
			ModernDepictionsInitializeCells();
		}
	}
}