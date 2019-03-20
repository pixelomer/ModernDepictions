#import "DepictionSeparatorView.h"

@implementation DepictionSeparatorView

- (CGFloat)height { return 3.0; }

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	UIView *separatorView = [[UIView alloc] init];
	separatorView.translatesAutoresizingMaskIntoConstraints = NO;
	separatorView.backgroundColor = [UIColor lightGrayColor];
	[self.contentView addSubview:separatorView];
	NSDictionary *views = @{ @"separator" : separatorView };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-15-[separator]-15-|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-1-[separator(==1)]"
		options:0
		metrics:nil
		views:views
	]];
	return self;
}

@end