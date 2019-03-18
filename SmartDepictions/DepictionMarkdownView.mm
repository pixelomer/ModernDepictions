#import "DepictionMarkdownView.h"

@implementation DepictionMarkdownView

- (CGFloat)height {
	return UITableViewAutomaticDimension;
}

- (void)setMarkdown:(NSString *)newText {
	self.label.text = newText;
	[self.label sizeToFit];
	_markdown = newText;
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	_label = [[UILabel alloc] init];
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:self.label];
	//NSDictionary *views = @{ @"label" : self.label };
	[self.contentView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeWidth
			multiplier:1.0
			constant:-30.0
		],
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationGreaterThanOrEqual
			toItem:nil
			attribute:0
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeLeading
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeLeading
			multiplier:1.0
			constant:15.0
		],
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeTrailing
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:-15.0
		],
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeTop
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeTop
			multiplier:1.0
			constant:15.0
		],
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeBottom
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeBottom
			multiplier:1.0
			constant:-15.0
		]
	]];
	self.label.numberOfLines = 0;
	self.label.lineBreakMode = NSLineBreakByWordWrapping;
	return self;
}

@end