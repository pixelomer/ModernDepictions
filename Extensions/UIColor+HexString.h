#import <UIKit/UIKit.h>

// Source: https://stackoverflow.com/a/7180905/7085621
@interface UIColor(HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end