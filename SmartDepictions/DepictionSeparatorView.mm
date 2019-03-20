#import "DepictionSeparatorView.h"

@implementation DepictionSeparatorView

- (CGFloat)height { return 2.0; }

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	self.contentView.backgroundColor = [UIColor lightGrayColor];
	return self;
}

@end