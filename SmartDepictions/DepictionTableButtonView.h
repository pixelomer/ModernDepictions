#import "DepictionBaseView.h"

@interface DepictionTableButtonView : DepictionBaseView
@property (nonatomic, retain, setter=setTitle:) NSString *title;
- (void)setTitle:(NSString *)newTitle;
@end