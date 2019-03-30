#import "DepictionMarkdownView.h"
#import "ModernDepictionDelegate.h"
#import "../Extensions/NSMutableString+RegEx.h"
#import "../Extensions/NSAttributedString+Markdown.h"

@implementation DepictionMarkdownView

- (CGFloat)height {
	return UITableViewAutomaticDimension;
}

- (void)setUseRawFormat:(bool)shouldUseRawFormat {
	_useRawFormat = shouldUseRawFormat;
	if (_markdown) [self setMarkdown:_markdown];
}

- (void)setMarkdown:(NSString *)newText {
	NSAttributedString *attributedString = [NSAttributedString attributedStringWithHTML:newText newlines:(_useRawFormat ? @"<br/>" : @"\n") allowMarkdown:!_useRawFormat extraCSS:@"a { text-decoration: none }"];
	textView.attributedText = attributedString;
	[textView sizeToFit];
	_markdown = newText;
}

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	textView = [[UITextView alloc] init];
	textView.translatesAutoresizingMaskIntoConstraints = NO;
	textView.scrollEnabled = NO;
	textView.layer.borderWidth = 0.0;
	textView.backgroundColor = [UIColor clearColor];
	textView.textContainer.lineFragmentPadding = 0.0;
	textView.textContainerInset = UIEdgeInsetsZero;
	textView.layoutManager.usesFontLeading = NO;
	textView.editable = NO;
	textView.linkTextAttributes = @{
		NSForegroundColorAttributeName : ModernDepictionDelegate.defaultTintColor
	};
	if (@available(iOS 11.0, *)) textView.textDragInteraction.enabled = NO;
	[self.contentView addSubview:textView];
	NSDictionary *views = @{ @"label" : textView };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|-15-[label]-15-|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:textView
			attribute:NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationGreaterThanOrEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:textView
			attribute:NSLayoutAttributeTop
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeTop
			multiplier:1.0
			constant:7.5
		],
		[NSLayoutConstraint
			constraintWithItem:self.contentView
			attribute:NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationEqual
			toItem:textView
			attribute:NSLayoutAttributeHeight
			multiplier:1.0
			constant:15.0
		]
	]];
	return self;
}

@end