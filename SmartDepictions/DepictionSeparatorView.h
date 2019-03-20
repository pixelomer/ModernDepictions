#import "SmartContentCell.h"

@interface DepictionSeparatorView : SmartContentCell
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)height;
@end