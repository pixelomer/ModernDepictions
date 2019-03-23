#import <UIKit/UIKit.h>

@protocol SmartCell
@required
- (CGFloat)height;
@optional
- (void)didSelectCell;
- (void)setDepictionTintColor:(UIColor *)newColor;
@end