#import "DepictionWebView.h"
#import <Headers/Headers.h>

@implementation DepictionWebView

static bool isWebViewCellEnabled;

+ (void)initialize {
	if ([self class] == [DepictionWebView class]) {
		NSNumber *isEnabled = [[NSUserDefaults standardUserDefaults] objectForKey:@"EnableDepictionWebView" inDomain:@"com.pixelomer.moderndepictions.prefs"];
		isWebViewCellEnabled = (
			[isEnabled isKindOfClass:[NSNumber class]] &&
			[isEnabled isEqual:@YES]
		);
	}
}

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	if (!isWebViewCellEnabled) return nil;
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	_height = 0.0;
	_width = 0.0;
	webView = [[UIWebView alloc] init];
	webView.translatesAutoresizingMaskIntoConstraints = NO;
	webView.scrollView.scrollEnabled = NO;
	webView.scalesPageToFit = NO;
	webView.autoresizesSubviews = NO;
	[self.contentView addSubview:webView];
	[self.contentView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:webView
			attribute:NSLayoutAttributeCenterY
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeCenterY
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:webView
			attribute:NSLayoutAttributeCenterX
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeCenterX
			multiplier:1.0
			constant:0.0
		]
	]];
	return self;
}

- (void)setHeight:(CGFloat)height {
	if (heightConstraints) [self.contentView removeConstraints:heightConstraints];
	heightConstraints = @[
		[NSLayoutConstraint
			constraintWithItem:webView
			attribute:NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:0.0
			constant:height
		]
	];
	[self.contentView addConstraints:heightConstraints];
	_height = height;
}

- (CGFloat)height {
	return _height;
}

- (void)setWidth:(CGFloat)width {
	if (widthConstraints) [self.contentView removeConstraints:widthConstraints];
	widthConstraints = @[
		[NSLayoutConstraint
			constraintWithItem:webView
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:0.0
			constant:width
		]
	];
	[self.contentView addConstraints:widthConstraints];
	_width = width;
}

- (void)setAlignment:(AlignEnum)alignment {
	_alignment = alignment;
}

- (void)cellWillAppear {
	[webView reload];
}

- (void)setURL:(NSString *)URL {
	targetURL = [NSURL URLWithString:URL];
	if (targetURL) {
		NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
		[webView loadRequest:request];
	}
	_URL = URL;
}

@end