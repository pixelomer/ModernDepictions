#import "GetPackageCell.h"
#import "DepictionRootView.h"
#import "SmartDepictionDelegate.h"
#import "QueueButton.h"
#import "AuthorButton.h"

@implementation GetPackageCell

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	_depictionDelegate = delegate;
	queueButton = [[QueueButton alloc] init];
	queueButton.backgroundColor = delegate.tintColor;
	queueButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0);
	[queueButton addTarget:self action:@selector(queueButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 92);
	self.contentView.frame = self.frame;
	iconView = [[UIImageView alloc] init];
	iconView.layer.masksToBounds = YES;
	iconView.layer.cornerRadius = 15.0;
	packageNameLabel = [[UILabel alloc] init];
	packageNameLabel.font = [UIFont boldSystemFontOfSize:20];
	authorButton = [[AuthorButton alloc] initWithMIMEAddress:delegate.package.author];
	self.package = delegate.package;
	queueButton.translatesAutoresizingMaskIntoConstraints = NO;
	packageNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	authorButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:packageNameLabel];
	[self.contentView addSubview:iconView];
	[self.contentView addSubview:authorButton];
	NSDictionary *views = @{ @"pn" : packageNameLabel, @"icon" : iconView, @"ab" : authorButton};
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-16-[icon(==60)]-10-[pn]"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|-21-[pn]-4-[ab(==19.5)]"
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
	@autoreleasepool {
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
}

- (void)setDepictionTintColor:(UIColor *)color {
	queueButton.backgroundColor = color;
	[queueButton setNeedsDisplay];
}

- (void)setButtonTitle:(NSString *)text {
	NSLog(@"setButtonTitle:\"%@\"", text);
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
			[self.contentView addConstraints:@[
				[NSLayoutConstraint
					constraintWithItem:queueButton
					attribute:NSLayoutAttributeCenterY
					relatedBy:NSLayoutRelationEqual
					toItem:self.contentView
					attribute:NSLayoutAttributeCenterY
					multiplier:1.0
					constant:0.0
				],
				[NSLayoutConstraint
					constraintWithItem:queueButton
					attribute:NSLayoutAttributeHeight
					relatedBy:NSLayoutRelationEqual
					toItem:nil
					attribute:NSLayoutAttributeNotAnAttribute
					multiplier:0.0
					constant:32.0
				]
			]];
		}
	}
	else if ([self.contentView.subviews containsObject:queueButton]) {
		[queueButton removeFromSuperview];
	}
}

- (NSString *)buttonTitle {
	return queueButton.titleLabel.text;
}

@end