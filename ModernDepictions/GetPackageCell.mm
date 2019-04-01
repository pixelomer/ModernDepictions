#import "GetPackageCell.h"
#import "DepictionRootView.h"
#import "ModernDepictionDelegate.h"
#import "QueueButton.h"
#import "AuthorButton.h"

@implementation GetPackageCell

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_depictionDelegate = delegate;
	textContainerView = [[UIView alloc] init];
	queueButton = [[QueueButton alloc] init];
	queueButton.backgroundColor = delegate.tintColor;
	[queueButton addTarget:self action:@selector(queueButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 92);
	self.contentView.frame = self.frame;
	iconView = [[UIImageView alloc] init];
	iconView.layer.masksToBounds = YES;
	iconView.layer.cornerRadius = 15.0;
	packageNameLabel = [[UILabel alloc] init];
	packageNameLabel.font = [UIFont boldSystemFontOfSize:20];
	packageNameLabel.textAlignment = NSTextAlignmentNatural;
	authorButton = [[AuthorButton alloc] initWithMIMEAddress:delegate.package.author];
	authorButton.titleLabel.textAlignment = NSTextAlignmentNatural;
	self.package = delegate.package;
	textContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	queueButton.translatesAutoresizingMaskIntoConstraints = NO;
	packageNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	authorButton.translatesAutoresizingMaskIntoConstraints = NO;
	[textContainerView addSubview:authorButton];
	[textContainerView addSubview:packageNameLabel];
	[self.contentView addSubview:textContainerView];
	[self.contentView addSubview:iconView];
	NSDictionary *views = @{ @"textContainer" : textContainerView, @"icon" : iconView, @"pn" : packageNameLabel, @"ab" : authorButton };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-16-[icon(==60)]-10-[textContainer]"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-21-[textContainer]"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-16-[icon(==60)]"
		options:0
		metrics:nil
		views:views
	]];
	[textContainerView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[pn(==24.0)]-4-[ab(==19.5)]|"
		options:0
		metrics:nil
		views:views
	]];
	[textContainerView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:authorButton
			attribute:NSLayoutAttributeLeading
			relatedBy:NSLayoutRelationEqual
			toItem:textContainerView
			attribute:NSLayoutAttributeLeading
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:packageNameLabel
			attribute:NSLayoutAttributeLeading
			relatedBy:NSLayoutRelationEqual
			toItem:textContainerView
			attribute:NSLayoutAttributeLeading
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:authorButton
			attribute:NSLayoutAttributeTrailing
			relatedBy:NSLayoutRelationEqual
			toItem:textContainerView
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:packageNameLabel
			attribute:NSLayoutAttributeTrailing
			relatedBy:NSLayoutRelationEqual
			toItem:textContainerView
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:0.0
		]
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
	NSString *rawIconURL = [package getField:@"icon"];
	if (rawIconURL && ![rawIconURL isKindOfClass:[NSNull class]]) {
		NSURL *iconURL = [NSURL URLWithString:rawIconURL];
		if (iconURL && iconURL.scheme && ![iconURL.scheme isEqualToString:@"file"]) {
			[self.depictionDelegate downloadDataFromURL:iconURL completion:^(NSData *data, NSError *error){
				if (!error && data) {
					UIImage *remoteImage = [UIImage imageWithData:data];
					if (remoteImage) {
						dispatch_sync(dispatch_get_main_queue(), ^{
							iconView.image = remoteImage;
							[iconView setNeedsDisplay];
						});
					}
				}
			}];
		}
	}
}

- (void)setDepictionTintColor:(UIColor *)color {
	queueButton.backgroundColor = color;
	[queueButton setNeedsDisplay];
}

- (void)setButtonTitle:(NSString *)text {
	if (textLocked) return;
	NSLog(@"setButtonTitle:\"%@\"", text);
	if (textContainerConstraints) [self.contentView removeConstraints:textContainerConstraints];
	if (text) {
		[queueButton
			setTitle:text.uppercaseString
			forState:UIControlStateNormal
		];
		[queueButton sizeToFit];
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
		textContainerConstraints = @[
			[NSLayoutConstraint
				constraintWithItem:textContainerView
				attribute:NSLayoutAttributeTrailing
				relatedBy:NSLayoutRelationLessThanOrEqual
				toItem:queueButton
				attribute:NSLayoutAttributeLeading
				multiplier:1.0
				constant:0.0
			]
		];
	}
	else {
		textContainerConstraints = @[
			[NSLayoutConstraint
				constraintWithItem:textContainerView
				attribute:NSLayoutAttributeTrailing
				relatedBy:NSLayoutRelationEqual
				toItem:self.contentView
				attribute:NSLayoutAttributeTrailing
				multiplier:1.0
				constant:0.0
			]
		];
		if ([self.contentView.subviews containsObject:queueButton]) {
			[queueButton removeFromSuperview];
		}
	}
	[self.contentView addConstraints:textContainerConstraints];
}

- (void)lockText {
	textLocked = true;
}

- (NSString *)buttonTitle {
	return queueButton.titleLabel.text;
}

@end