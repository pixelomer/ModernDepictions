#import "DepictionBaseView.h"

@interface DepictionSeparatorView : DepictionBaseView
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)height;
@end