#import <UIKit/UIKit.h>

@protocol SmartCell
@required
- (CGFloat)height;
@optional
- (void)didGetSelected;
- (void)setDepictionTintColor:(UIColor *)newColor;
@end