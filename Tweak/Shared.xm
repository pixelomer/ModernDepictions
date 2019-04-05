#import <Foundation/Foundation.h>
#import <Headers/Headers.h>

int ModernDepictionsGetPreferenceValue(NSString *prefKey, int defaultValue) {
	NSNumber *val = [[NSUserDefaults standardUserDefaults] objectForKey:prefKey inDomain:@"com.pixelomer.moderndepictions.prefs"];
	return val ? val.intValue : defaultValue;
}