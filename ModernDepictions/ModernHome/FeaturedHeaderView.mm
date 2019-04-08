#import "FeaturedHeaderView.h"

@implementation FeaturedHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)ri {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ri];
	label = [UILabel new];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	label.font = [UIFont boldSystemFontOfSize:22.0];
	label.numberOfLines = 1;
	[self.contentView addSubview:label];
	NSDictionary *views = @{ @"label" : label };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-16-[label]-16-|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-8-[label(==26)]-8-|"
		options:0
		metrics:nil
		views:views
	]];
	return self;
}

- (void)setText:(NSString *)text {
	label.text = _text = text;
}

@end