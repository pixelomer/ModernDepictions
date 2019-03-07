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
		iconView.frame.origin.x + iconView.frame.size.width + 10,
		21,
		self.contentView.frame.size.width - (iconView.frame.origin.x + iconView.frame.size.width + 10),
		24
	)];
	packageNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
	authorButton = [[AuthorButton alloc] initWithMIMEAddress:delegate.package.author];
	authorButton.frame = CGRectMake(
		packageNameLabel.frame.origin.x,
		packageNameLabel.frame.origin.y + 28,
		packageNameLabel.frame.size.width,
		19.5
	);
	self.package = delegate.package;
	[self.contentView addSubview:packageNameLabel];
	[self.contentView addSubview:iconView];
	[self.contentView addSubview:authorButton];
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
		}
		[queueButton
			setTitle:[NSString stringWithFormat:@"    %@    ", text.uppercaseString]
			forState:UIControlStateNormal
		];
		[queueButton sizeToFit];
		queueButton.frame = CGRectMake(
			self.contentView.frame.size.width - queueButton.frame.size.width - 23,
			0,
			queueButton.frame.size.width,
			queueButton.frame.size.height
		);
		queueButton.center = CGPointMake(
			queueButton.center.x,
			self.contentView.center.y
		);
		packageNameLabel.frame = CGRectMake(
			packageNameLabel.frame.origin.x,
			packageNameLabel.frame.origin.y,
			self.contentView.frame.size.width - (self.contentView.frame.size.width - queueButton.frame.origin.x) - packageNameLabel.frame.origin.x,
			packageNameLabel.frame.size.height
		);
		authorButton.frame = CGRectMake(
			authorButton.frame.origin.x,
			authorButton.frame.origin.y,
			packageNameLabel.frame.size.width,
			authorButton.frame.size.height
		);

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