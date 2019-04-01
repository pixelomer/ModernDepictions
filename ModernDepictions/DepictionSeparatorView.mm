#import "DepictionSeparatorView.h"

@implementation DepictionSeparatorView

static UIColor *separatorColor;

+ (void)load {
	if ([self class] == [DepictionSeparatorView class]) {
		separatorColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.925 alpha:1.0];
	}
}

- (CGFloat)height { return 3.0; }

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	UIView *separatorView = [[UIView alloc] init];
	separatorView.translatesAutoresizingMaskIntoConstraints = NO;
	separatorView.backgroundColor = separatorColor;
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