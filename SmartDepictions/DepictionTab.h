#import <UIKit/UIKit.h>

@interface DepictionTab : UIButton
@property (nonatomic, retain, setter=setTabName:) NSString *tabName;
- (void)setTabName:(NSString *)newName;
@end