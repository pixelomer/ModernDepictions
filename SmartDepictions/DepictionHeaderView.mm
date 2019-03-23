#import "DepictionHeaderView.h"

@implementation DepictionHeaderView

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	headerLabel = [[UILabel alloc] init];
	headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
	headerLabel.numberOfLines = 0;
	headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[self.contentView addSubview:headerLabel];
	NSDictionary *views = @{ @"header" : headerLabel };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-8-[header(>=0)]-8-|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-16-[header]-16-|"
		options:0
		metrics:nil
		views:views
	]];
	fontSize = 22.0;
	return self;
}

- (void)setUseBoldText:(bool)useBoldText {
	headerLabel.font = useBoldText ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
	_useBoldText = useBoldText;
}

- (void)setTitle:(NSString *)title {
	headerLabel.text = title;
	_title = title;
}

@end