#import "MDSileoDepictionMarkdownView.h"
#import <MMMarkdown/Source/MMMarkdown.h>

@implementation MDSileoDepictionMarkdownView

+ (BOOL)shouldAssignPropertiesSeparately {
	return YES;
}

- (void)setDepictionTintColor:(NSString *)newTintColor {
	_depictionTintColor = newTintColor;
	/*
	_textView.linkTextAttributes = @{
		NSForegroundColorAttributeName : color
	};
	*/
}

- (void)reloadText {
	NSString *parsedString = _depictionMarkdown;
	if (!_depictionUseRawFormat) {
		parsedString = (
			[MMMarkdown
				HTMLStringWithMarkdown:parsedString
				extensions:MMMarkdownExtensionsGitHubFlavored
				error:nil
			] ?:
			@"<p style=\"color:red\">"
			"ERROR: Failed to parse markdown. Please contact the repository maintainer."
			"</p>"
		);
	}
	parsedString = [NSString stringWithFormat:@"%@%@",
		@"<meta charset=\"UTF-8\">"
		"<style>"
		"body {"
		"	font-family: '-apple-system', 'HelveticaNeue';"
		"	font-size: 16px;"
		"}"
		"a { text-decoration: none }"
		"</style>",
		parsedString
	];
	NSMutableAttributedString *finalObject = [[NSMutableAttributedString alloc]
		initWithData:[parsedString dataUsingEncoding:NSUTF8StringEncoding]
		options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
		documentAttributes:nil
		error:nil
	];
	for (NSUInteger i = finalObject.mutableString.length-1; i > 0; i--) {
		if (finalObject.mutableString.length > 0 && [finalObject.mutableString characterAtIndex:i] == '\n') {
			[finalObject deleteCharactersInRange:NSMakeRange(i, 1)];
		}
		else break;
	}
	_textView.attributedText = finalObject.copy;
	[_textView sizeToFit];
}

- (void)setDepictionMarkdown:(NSString *)markdown {
	_depictionMarkdown = markdown;
	[self reloadText];
}

- (void)setDepictionUseRawFormat:(BOOL)useRawFormat {
	_depictionUseRawFormat = useRawFormat;
	[self reloadText];
}

- (instancetype)initWithProperties:(NSDictionary *)properties {
	if ((self = [super init])) {
		_textView = [[UITextView alloc] init];
		_textView.translatesAutoresizingMaskIntoConstraints = NO;
		_textView.scrollEnabled = NO;
		_textView.layer.borderWidth = 0.0;
		_textView.backgroundColor = [UIColor clearColor];
		_textView.textContainer.lineFragmentPadding = 0.0;
		_textView.textContainerInset = UIEdgeInsetsZero;
		_textView.layoutManager.usesFontLeading = NO;
		_textView.linkTextAttributes = @{
			NSForegroundColorAttributeName : [UIColor redColor]
		};
		_textView.editable = NO;
		if (@available(iOS 11.0, *)) _textView.textDragInteraction.enabled = NO;
		[self addSubview:_textView];
		NSDictionary *views = @{ @"label" : _textView };
		[self addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|-15-[label]-15-|"
			options:0
			metrics:nil
			views:views
		]];
		[self addConstraints:@[
			[NSLayoutConstraint
				constraintWithItem:_textView
				attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationGreaterThanOrEqual
				toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute
				multiplier:1.0
				constant:0.0
			],
			[NSLayoutConstraint
				constraintWithItem:_textView
				attribute:NSLayoutAttributeTop
				relatedBy:NSLayoutRelationEqual
				toItem:self
				attribute:NSLayoutAttributeTop
				multiplier:1.0
				constant:7.5
			],
			[NSLayoutConstraint
				constraintWithItem:_textView
				attribute:NSLayoutAttributeBottom
				relatedBy:NSLayoutRelationEqual
				toItem:self
				attribute:NSLayoutAttributeBottom
				multiplier:1.0
				constant:-7.5
			]
		]];
	}
	return self;
}

@end