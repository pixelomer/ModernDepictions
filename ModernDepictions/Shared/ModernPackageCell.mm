#import "ModernPackageCell.h"

@implementation ModernPackageCell

static UIFont *authorLabelFont;
static UIFont *packageNameLabelFont;
static UIFont *footerLabelFont;
static UIColor *infoLabelColor;

+ (void)initialize {
	if ([self class] == [ModernPackageCell class]) {
		authorLabelFont = (
			[UIFont respondsToSelector:@selector(systemFontOfSize:weight:)] ?
			[UIFont systemFontOfSize:13 weight:UIFontWeightMedium] :
			[UIFont fontWithName:@".SFUIText-Medium" size:13]
		);
		packageNameLabelFont = (
			[UIFont respondsToSelector:@selector(systemFontOfSize:weight:)] ?
			[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold] :
			[UIFont fontWithName:@".SFUIText-Semibold" size:17]
		);
		footerLabelFont = [UIFont systemFontOfSize:11];
		infoLabelColor = [UIColor colorWithRed:0.561 green:0.557 blue:0.580 alpha:1.0];
	}
}

- (instancetype)initWithIconSize:(CGFloat)iconSize reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	self.preservesSuperviewLayoutMargins = NO;
	self.layoutMargins = UIEdgeInsetsZero;
	self.separatorInset = UIEdgeInsetsMake(iconSize + 32.0, 0, 0, 0);

	// Text container view setup
	textContainerView = [[UIView alloc] init];
	textContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	packageNameLabel = [[UILabel alloc] init];
	packageNameLabel.font = packageNameLabelFont;
	packageNameLabel.textColor = [UIColor blackColor];
	packageNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	packageNameLabel.numberOfLines = 1;
	authorLabel = [[UILabel alloc] init];
	authorLabel.font = authorLabelFont;
	authorLabel.textColor = infoLabelColor;
	authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
	authorLabel.numberOfLines = 1;
	footerLabel = [[UILabel alloc] init];
	footerLabel.font = footerLabelFont;
	footerLabel.textColor = infoLabelColor;
	footerLabel.translatesAutoresizingMaskIntoConstraints = NO;
	footerLabel.numberOfLines = 1;
	[textContainerView addSubview:packageNameLabel];
	[textContainerView addSubview:authorLabel];
	[textContainerView addSubview:footerLabel];
	[self.contentView addSubview:textContainerView];

	// Icon setup
	iconView = [[UIImageView alloc] init];
	iconView.layer.cornerRadius = iconSize / 4.0;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:iconView];

	// Text container layout setup
	[textContainerView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[title(==20.5)]-2-[author(==16)]-4-[footer(==13.5)]|"
		options:0
		metrics:nil
		views:@{ @"title" : packageNameLabel, @"author" : authorLabel, @"footer" : footerLabel }
	]];
	for (UILabel *label in @[packageNameLabel, authorLabel, footerLabel]) {
		[textContainerView addConstraints:@[
			[NSLayoutConstraint
				constraintWithItem:label
				attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual
				toItem:textContainerView
				attribute:NSLayoutAttributeLeft
				multiplier:1.0
				constant:0.0
			],
			[NSLayoutConstraint
				constraintWithItem:label
				attribute:NSLayoutAttributeRight
				relatedBy:NSLayoutRelationEqual
				toItem:textContainerView
				attribute:NSLayoutAttributeRight
				multiplier:1.0
				constant:0.0
			]
		]];
	}

	// Content view layout setup
	NSDictionary *views = @{ @"icon" : iconView, @"text" : textContainerView };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-16-[icon(==%f)]-16-[text]-16-|", iconSize]
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-8-[icon(==%f)]-8-|", iconSize]
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-8-[text]"
		options:0
		metrics:nil
		views:views
	]];

	return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	return [self initWithIconSize:40.0 reuseIdentifier:reuseIdentifier];
}

- (instancetype)init {
	return [self initWithReuseIdentifier:nil];
}

- (void)setFooterText:(NSString *)newText {
	footerLabel.text = newText;
}

@end