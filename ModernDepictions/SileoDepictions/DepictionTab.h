#import <UIKit/UIKit.h>

@interface DepictionTab : UIButton
@property (nonatomic, strong, setter=setTabName:) NSString *tabName;
- (void)setTabName:(NSString *)newName;
@end