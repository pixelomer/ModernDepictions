#import "DepictionTableTextView.h"

@implementation DepictionTableTextView

- (CGFloat)height {
	return 44.0;
}

- (NSString *)title {
	return titleLabel.text;
}

- (void)setTitle:(NSString *)title {
	titleLabel.text = title;
}

- (NSString *)text {
	return textLabel.text;
}

- (void)setText:(NSString *)text {
	textLabel.text = text;
}

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	titleLabel = [[UILabel alloc] init];
	titleLabel.textColor = [UIColor colorWithRed:0.686 green:0.686 blue:0.686 alpha:1.0];
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	titleLabel.textAlignment = NSTextAlignmentNatural;
	titleLabel.numberOfLines = 1;
	textLabel = [[UILabel alloc] init];
	textLabel.textColor = [UIColor blackColor];
	textLabel.translatesAutoresizingMaskIntoConstraints = NO;
	textLabel.textAlignment = NSTextAlignmentNaturalInverse;
	textLabel.numberOfLines = 1;
	[self.contentView addSubview:textLabel];
	[self.contentView addSubview:titleLabel];
	NSDictionary *views = @{
		@"textLabel" : textLabel,
		@"titleLabel" : titleLabel
	};
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-16-[titleLabel][textLabel]-16-|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-12-[titleLabel(==20)]"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-12-[textLabel(==20)]"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:textLabel
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeWidth
			multiplier:0.5
			constant:-16.0
		],
		[NSLayoutConstraint
			constraintWithItem:titleLabel
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeWidth
			multiplier:0.5
			constant:-16.0
		]
	]];
	return self;
}

@end