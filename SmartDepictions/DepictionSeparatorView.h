#import "DepictionBaseView.h"

@interface DepictionSeparatorView : DepictionBaseView
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)height;
@end