#import "DepictionSubheaderView.h"

@interface DepictionHeaderView : DepictionSubheaderView
@property (nonatomic, retain, setter=setTitle:) NSString *title;
- (void)setTitle:(NSString *)title;
@end