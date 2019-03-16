#import "GetPackageCell.h"
#import "DepictionRootView.h"
#import "SmartDepictionDelegate.h"
#import "QueueButton.h"
#import "AuthorButton.h"

@implementation GetPackageCell

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	_depictionDelegate = [delegate retain];
	queueButton = [[QueueButton alloc] init];
	[queueButton addTarget:self action:@selector(queueButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 92);
	self.contentView.frame = self.frame;
	iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 60, 60)];
	iconView.layer.masksToBounds = YES;
	iconView.layer.cornerRadius = 15.0;
	packageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(
		0, 0,
		self.contentView.frame.size.width - (iconView.frame.origin.x + iconView.frame.size.width + 10),
		24
	)];
	packageNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
	authorButton = [[AuthorButton alloc] initWithMIMEAddress:delegate.package.author];
	authorButton.frame = CGRectMake(
		0, 0,
		packageNameLabel.frame.size.width,
		19.5
	);
	self.package = delegate.package;
	queueButton.translatesAutoresizingMaskIntoConstraints = NO;
	packageNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	authorButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:packageNameLabel];
	[self.contentView addSubview:iconView];
	[self.contentView addSubview:authorButton];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-16-[icon(==60)]-10-[pn]"
		options:0
		metrics:nil
		views:@{ @"pn" : packageNameLabel, @"icon" : iconView }
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-21-[pn]-4-[ab(==19.5)]"
		options:0
		metrics:nil
		views:@{ @"pn" : packageNameLabel, @"ab" : authorButton }
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-16-[icon(==60)]"
		options:0
		metrics:nil
		views:@{ @"icon" : iconView }
	]];
	[self.contentView addConstraint:[NSLayoutConstraint
		constraintWithItem:iconView
      	attribute:NSLayoutAttributeCenterY
      	relatedBy:NSLayoutRelationEqual
       	toItem:self.contentView
       	attribute:NSLayoutAttributeCenterY
       	multiplier:1.0
       	constant:0.0
	]];
	[self.contentView addConstraint:[NSLayoutConstraint
		constraintWithItem:packageNameLabel
      	attribute:NSLayoutAttributeLeading
      	relatedBy:NSLayoutRelationEqual
       	toItem:authorButton
       	attribute:NSLayoutAttributeLeading
       	multiplier:1.0
       	constant:0.0
	]];
	return self;
}

- (void)queueButtonTouchUpInside:(id)sender {
	[self.depictionDelegate handleModifyButton];
}

- (CGFloat)height {
	return 92.0;
}

- (void)setPackage:(Package *)package {
	if (!package) {
		packageNameLabel.text = @"?";
		return;
	}
	packageNameLabel.text = package.name;
	authorButton.MIMEAddress = package.author;
	iconView.image = package.icon;
}

- (void)setButtonTitle:(NSString *)text {
	NSLog(@"setButtonTitle:\"%@\"", text);
	if (text) {
		if (![self.contentView.subviews containsObject:queueButton]) {
			[self.contentView addSubview:queueButton];
			[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:[qb]-23-|"
				options:0
				metrics:nil
				views:@{ @"qb" : queueButton }
			]];
			[self.contentView addConstraint:[NSLayoutConstraint
				constraintWithItem:queueButton
            	attribute:NSLayoutAttributeCenterY
            	relatedBy:NSLayoutRelationEqual
            	toItem:self.contentView
            	attribute:NSLayoutAttributeCenterY
            	multiplier:1.0
            	constant:0.0
			]];
		}
		[queueButton
			setTitle:[NSString stringWithFormat:@"    %@    ", text.uppercaseString]
			forState:UIControlStateNormal
		];
		[queueButton sizeToFit];
	}
	else if ([self.contentView.subviews containsObject:queueButton]) {
		[[queueButton retain] removeFromSuperview];
		packageNameLabel.frame = CGRectMake(
			packageNameLabel.frame.origin.x,
			packageNameLabel.frame.origin.y,
			self.contentView.frame.size.width  - (iconView.frame.origin.x + iconView.frame.size.width + 10),
			packageNameLabel.frame.size.height
		);
	}
}

- (NSString *)buttonTitle {
	return queueButton.titleLabel.text;
}

@end