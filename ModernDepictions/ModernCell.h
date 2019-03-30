#import <UIKit/UIKit.h>

@protocol ModernCell
@required
- (CGFloat)height;
@optional
- (void)didGetSelected;
- (void)setDepictionTintColor:(UIColor *)newColor;
@end