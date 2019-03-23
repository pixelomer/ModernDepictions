#import <UIKit/UIKit.h>

@protocol SmartCell
@required
- (CGFloat)height;
@optional
- (void)didSelectCell;
@end