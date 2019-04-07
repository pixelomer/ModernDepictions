#import "ModernPackageCell.h"

@implementation ModernPackageCell

static UIFont *authorLabelFont;
static UIFont *packageNameLabelFont;
static UIFont *footerLabelFont;
static UIColor *infoLabelColor;
static UIColor *installQueueColor;
static UIColor *uninstallQueueColor;

+ (void)load {
	if ([self class] == [ModernPackageCell class]) {
		authorLabelFont = (
			[UIFont respondsToSelector:@selector(systemFontOfSize:weight:)] ?
			[UIFont systemFontOfSize:13 weight:UIFontWeightMedium] :
			[UIFont fontWithName:@".SFUIText-Medium" size:13]
		);
		installQueueColor = [UIColor colorWithRed:0.88f green:1.00f blue:0.88f alpha:1.00f];
    	uninstallQueueColor = [UIColor colorWithRed:1.00f green:0.88f blue:0.88f alpha:1.00f];
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
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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

	// Placard setup (I don't know what it stands for but it's the indicator that shows you that the package is installed/queued)
	placard = [[UIImageView alloc] init];
	placard.translatesAutoresizingMaskIntoConstraints = NO;
	[textContainerView addSubview:placard];

	// Text container layout setup
	NSDictionary *views = @{
		@"placard" : placard,
		@"title"   : packageNameLabel,
		@"author"  : authorLabel,
		@"footer"  : footerLabel,
		@"icon"    : iconView,
		@"text"    : textContainerView
	};
	[textContainerView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[title(==20.5)]-2-[author(==16)]-4-[footer(==13.5)]|"
		options:0
		metrics:nil
		views:views
	]];
	for (UILabel *label in @[packageNameLabel, authorLabel, footerLabel]) {
		[textContainerView addConstraint:[NSLayoutConstraint
			constraintWithItem:label
			attribute:NSLayoutAttributeLeading
			relatedBy:NSLayoutRelationEqual
			toItem:textContainerView
			attribute:NSLayoutAttributeLeading
			multiplier:1.0
			constant:0.0
		]];
		if (label != packageNameLabel) {
			[textContainerView addConstraint:[NSLayoutConstraint
				constraintWithItem:label
				attribute:NSLayoutAttributeTrailing
				relatedBy:NSLayoutRelationEqual
				toItem:textContainerView
				attribute:NSLayoutAttributeTrailing
				multiplier:1.0
				constant:0.0
			]];
		}
	}
	[textContainerView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[placard(==20.5)]"
		options:0
		metrics:nil
		views:views
	]];
	[textContainerView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:placard
			attribute:NSLayoutAttributeLeading
			relatedBy:NSLayoutRelationEqual
			toItem:packageNameLabel
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:8.0
		],
		[NSLayoutConstraint
			constraintWithItem:placard
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:1.0
			constant:20.5
		]
	]];


	// Content view layout setup
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-16-[icon(==%f)]-16-[text]-16-|", iconSize]
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-8-[icon(==%f)]", iconSize]
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

- (void)setPackage:(Package *)package {
	[package parse];
	if (packageNameLabelTrailingConstraint) {
		[textContainerView removeConstraint:packageNameLabelTrailingConstraint];
	}
	packageNameLabel.text = package.name;
	NSString *authorName = package.author.name;
	authorLabel.text = (
		(authorName && [authorName isKindOfClass:[NSString class]] && ![authorName isEqualToString:@""]) ?
		authorName : [NSString stringWithFormat:@"(%@)", UCLocalize(@"UNKNOWN")]
	);
	NSArray *placardImageInfo = nil;
	if (NSString *mode = package.mode) {
		placardImageInfo = (
			([mode isEqualToString:@"REMOVE"] || [mode isEqualToString:@"PURGE"]) ?
			@[@"removing", uninstallQueueColor] :
			@[@"installing", installQueueColor]
		);
	}
	else if (!package.uninstalled) {
		placardImageInfo = @[@"installed", [UIColor whiteColor]];
	}
	placard.image = placardImageInfo ? [UIImage imageNamed:placardImageInfo[0]] : nil;
	self.backgroundColor = placardImageInfo ? placardImageInfo[1] : [UIColor whiteColor];
	[placard setNeedsDisplay];
	[textContainerView addConstraint:(
		packageNameLabelTrailingConstraint = [NSLayoutConstraint
			constraintWithItem:packageNameLabel
			attribute:NSLayoutAttributeTrailing
			relatedBy:NSLayoutRelationLessThanOrEqual
			toItem:textContainerView
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:(!!placardImageInfo * -36.5)
		]
	)];
	self.footerText = package.shortDescription;
	iconView.image = package.icon;
	[iconView setNeedsDisplay];
	_package = package;
}

- (void)setPackage:(Package *)package asSummary:(bool)asSummary {
	[self setPackage:package];
}

- (instancetype)init {
	return [self initWithReuseIdentifier:nil];
}

- (void)setFooterText:(NSString *)newText {
	footerLabel.text = newText;
}

@end