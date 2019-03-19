#import "DepictionMarkdownView.h"
#import "../Extensions/NSMutableString+RegEx.h"
#import "../Extensions/NSAttributedString+Markdown.h"

@implementation DepictionMarkdownView

- (CGFloat)height {
	return UITableViewAutomaticDimension;
}

- (void)setMarkdown:(NSString *)newText {
	NSAttributedString *attributedString = [NSAttributedString attributedStringWithMarkdown:newText];
	self.label.attributedText = attributedString;
	[self.label sizeToFit];
	_markdown = newText;
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	_label = [[UILabel alloc] init];
	self.label.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:self.label];
	NSDictionary *views = @{ @"label" : self.label };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-15-[label]-15-|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:@[
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
			attribute:NSLayoutAttributeTop
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeTop
			multiplier:1.0
			constant:7.5
		],
		[NSLayoutConstraint
			constraintWithItem:self.label
			attribute:NSLayoutAttributeBottom
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeBottom
			multiplier:1.0
			constant:-7.5
		]
	]];
	self.label.numberOfLines = 0;
	self.label.lineBreakMode = NSLineBreakByWordWrapping;
	return self;
}

@end