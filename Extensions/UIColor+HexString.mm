#import "UIColor+HexString.h"

@implementation UIColor(ModernDepictions)

+ (UIColor *)cscp_colorFromHexString:(NSString *)hexString fallback:(NSString *)fallbackHex {
	NSString *hex = hexString;
	if (![UIColor cscp_isValidHexString:hex]) {
		if (!fallbackHex || ![UIColor cscp_isValidHexString:fallbackHex]) {
			[NSException raise:NSInvalidArgumentException format:@"Both the default hex and the fallback was invalid."];
		}
		hex = fallbackHex;
	}
	return [UIColor cscp_colorFromHexString:hex];
}

@end