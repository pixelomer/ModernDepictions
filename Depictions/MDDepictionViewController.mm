#import "MDDepictionViewController.h"
#import "MDSileoDepictionStackView.h"
#import "Depictions.h"
#import "MDTabView.h"
#import <WebKit/WebKit.h>

@implementation MDDepictionViewController

- (NSString *)packageDescription {
	return (
		MDGetFieldFromPackage(self.package, @"description") ?:
		MDGetFieldFromPackage(self.package, @"name") ?:
		MDGetFieldFromPackage(self.package, @"package") ?:
		@"Invalid Package"
	);
}

- (id)package {
	switch (MDCurrentPackageManager) {
		case MDPackageManagerZebra:
			return (
				_package ?:
				[[objc_getClass("ZBDatabaseManager") sharedInstance]
					topVersionForPackageID:_packageID
					inRepo:_repo
				]
			);
		case MDPackageManagerCydia:
			return [[objc_getClass("Database") sharedInstance]
				packageWithName:_packageID
			];
	}
	return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_initialImageHeight = self.sileoDepictionURL ? 200.0 : 100.0;
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.view.backgroundColor = [UIColor whiteColor];
	for (UIView *view in self.view.subviews) {
		// We don't want the views added by Zebra
		[view removeFromSuperview];
	}
	self.edgesForExtendedLayout = UIRectEdgeTop;
	
	// Header Image View
	UIView *containerView = [UIView new];
	containerView.clipsToBounds = YES;
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	_headerImageView = [UIImageView new];
	_headerImageView.contentMode =(
		self.sileoDepictionURL ?
		UIViewContentModeScaleAspectFill :
		UIViewContentModeCenter
	);
	_headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	_headerImageView.backgroundColor = [UIColor redColor];
	[containerView addSubview:_headerImageView];
	[self.view addSubview:containerView];
	containerView.layer.zPosition = 1.0;
	_headerImageHeight = [NSLayoutConstraint
		constraintWithItem:_headerImageView
		attribute:NSLayoutAttributeHeight
		relatedBy:NSLayoutRelationEqual
		toItem:nil
		attribute:NSLayoutAttributeNotAnAttribute
		multiplier:1.0
		constant:_initialImageHeight
	];
	_headerImageWidth = [NSLayoutConstraint
		constraintWithItem:_headerImageView
		attribute:NSLayoutAttributeWidth
		relatedBy:NSLayoutRelationEqual
		toItem:containerView
		attribute:NSLayoutAttributeWidth
		multiplier:1.0
		constant:0.0
	];
	[containerView addConstraints:@[
		_headerImageHeight,
		_headerImageWidth,
		[NSLayoutConstraint
			constraintWithItem:_headerImageView
			attribute:NSLayoutAttributeTop
			relatedBy:NSLayoutRelationEqual
			toItem:containerView
			attribute:NSLayoutAttributeTop
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:_headerImageView
			attribute:NSLayoutAttributeCenterX
			relatedBy:NSLayoutRelationEqual
			toItem:containerView
			attribute:NSLayoutAttributeCenterX
			multiplier:1.0
			constant:0.0
		]
	]];
	[self.view addConstraint:(_headerPosition = [NSLayoutConstraint
		constraintWithItem:containerView
		attribute:NSLayoutAttributeTop
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeTop
		multiplier:1.0
		constant:0.0
	])];
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[container]|"
		options:0
		metrics:nil
		views:@{ @"container" : containerView }
	]];

	// Shadow
	UIImageView *shadowView = [UIImageView new];
	shadowView.translatesAutoresizingMaskIntoConstraints = NO;
	shadowView.image = MDGetShadowImage();
	[_headerImageView addSubview:shadowView];
	NSDictionary *views = @{ @"shadow" : shadowView };
	[_headerImageView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[shadow]|"
		options:0
		metrics:nil
		views:views
	]];
	[_headerImageView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[shadow]|"
		options:0
		metrics:nil
		views:views
	]];
	
	if (self.sileoDepictionURL) {
		// Scroll View and Image Container Layout
		_depictionScrollView = [UIScrollView new];
		_depictionScrollView.delegate = self;
		_depictionScrollView.scrollEnabled = YES;
		_depictionScrollView.pagingEnabled = NO;
		_depictionScrollView.directionalLockEnabled = YES;
		_depictionScrollView.alwaysBounceHorizontal = NO;
		_depictionScrollView.alwaysBounceVertical = NO;
		_depictionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:_depictionScrollView];
		_depictionScrollView.layer.zPosition = 0.0;
		views = @{ @"scroll" : _depictionScrollView, @"container" : containerView };
		[self.view addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[scroll]|"
			options:0
			metrics:nil
			views:views
		]];
		[self.view addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[scroll]|"
			options:0
			metrics:nil
			views:views
		]];

		// Tabs
		_tabView = [MDTabView new];
		_tabView.translatesAutoresizingMaskIntoConstraints = NO;
		[containerView addSubview:_tabView];
		views = @{ @"tabs" : _tabView, @"image" : _headerImageView };
		[containerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:[image][tabs]|"
			options:0
			metrics:nil
			views:views
		]];
		[containerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[tabs]|"
			options:0
			metrics:nil
			views:views
		]];
	}
	else {
		// WebView
		WKWebView *webView = [[WKWebView alloc]
			initWithFrame:CGRectZero 
			configuration:[WKWebViewConfiguration new]
		];
		_depictionScrollView = webView.scrollView;
		_depictionScrollView.delegate = self;
		webView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:webView];
		views = @{ @"header" : containerView, @"image" : _headerImageView, @"web" : webView };
		[self.view addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[web]|"
			options:0
			metrics:nil
			views:views
		]];
		[containerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:[image]|"
			options:0
			metrics:nil
			views:views
		]];
		[self.view addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[web]|"
			options:0
			metrics:nil
			views:views
		]];
		NSString *depiction = MDGetFieldFromPackage(self.package, @"depiction");
		[webView loadRequest:[NSURLRequest
			requestWithURL:[NSURL
				URLWithString:depiction
			]
		]];
	}

	[self reloadData];
}

- (void)parseDepiction {
	NSArray *parsed = MDParseSileoDepiction(_sileoDepiction);
	if (parsed.count > 0) {
		_depictionStackViews = parsed;
		_tabView.tabs = parsed;
		for (UIView *view in _depictionScrollView.subviews) {
			// We don't want the views added by Zebra
			[view removeFromSuperview];
		}
		UIView *prevView = _depictionScrollView;
		for (MDSileoDepictionStackView *stackView in _depictionStackViews) {
			stackView.translatesAutoresizingMaskIntoConstraints = NO;
			[_depictionScrollView addSubview:stackView];
			#define EQUAL_CONSTRAINT(item1, item2, attr) [NSLayoutConstraint \
				constraintWithItem: item1 \
				attribute: attr \
				relatedBy:NSLayoutRelationEqual \
				toItem: item2 \
				attribute: attr \
				multiplier:1.0 \
				constant:0.0 \
			]
			#define EQUAL_ATTR(attr) EQUAL_CONSTRAINT(stackView, _depictionScrollView, attr)
			NSLayoutAttribute attr = (
				(prevView == _depictionScrollView) ?
				NSLayoutAttributeLeading :
				NSLayoutAttributeTrailing
			);
			[_depictionScrollView addConstraints:@[
				[NSLayoutConstraint
					constraintWithItem:stackView
					attribute:NSLayoutAttributeLeading
					relatedBy:NSLayoutRelationEqual
					toItem:prevView
					attribute:attr
					multiplier:1.0
					constant:0.0
				],
				EQUAL_ATTR(NSLayoutAttributeWidth),
				EQUAL_ATTR(NSLayoutAttributeTop),
				EQUAL_ATTR(NSLayoutAttributeBottom),
				EQUAL_ATTR(NSLayoutAttributeHeight)
			]];
			#undef EQUAL_ATTR
			#undef EQUAL_CONSTRAINT
			prevView = (id)stackView;
		}
		[_depictionScrollView addConstraint:[NSLayoutConstraint
			constraintWithItem:prevView
			attribute:NSLayoutAttributeTrailing
			relatedBy:NSLayoutRelationEqual
			toItem:_depictionScrollView
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:0.0
		]];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	UIEdgeInsets insets = scrollView.contentInset;
	CGFloat y = scrollView.contentOffset.y + insets.top;
	NSLog(@"[Scroll] y:%f", y);
	if (y <= 0) {
		_headerImageHeight.constant = _initialImageHeight+(-y);
		_headerImageWidth.constant = _initialImageHeight+((-y)*2.0);
		_headerPosition.constant = 0.0;
	}
	else {
		_headerImageHeight.constant = _initialImageHeight;
		_headerImageWidth.constant = _initialImageHeight;
		_headerPosition.constant = (-y);
	}
}

- (void)viewDidLayoutSubviews {
	if (!_didLayoutSubviews) {
		_didLayoutSubviews = YES;
		UIView *containerView = _headerPosition.firstItem;
		CGFloat top = containerView.frame.origin.y + containerView.frame.size.height;
		_depictionScrollView.layer.masksToBounds = NO;
		_depictionScrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
	}
}

- (void)setSileoDepiction:(NSDictionary *)depiction {
	_sileoDepiction = depiction;
	[self parseDepiction];
}

- (NSURL *)sileoDepictionURL {
	NSString *URLString = MDGetFieldFromPackage(self.package, @"sileodepiction");
	NSString *HTMLURLString = MDGetFieldFromPackage(self.package, @"depiction");
	if (!URLString && !HTMLURLString) URLString = @"http://0.0.0.0";
	return URLString ? [NSURL URLWithString:URLString] : nil;
}

- (void)reloadData {
	if (self.sileoDepictionURL) {
		self.sileoDepiction = @{
			@"minVersion" : @"0.1",
			@"tabs" : @[
				@{
					@"tabname" : @"Details",
					@"views" : @[
						@{
							@"class" : @"DepictionMarkdownView",
							@"markdown" : self.packageDescription,
							@"useRawFormat" : @NO
						}
					],
					@"class" : @"DepictionStackView"
				}
			],
			@"class" : @"DepictionTabView"
		};
		__block __weak typeof(self) _self = self;
		MDGetDataFromURL(self.sileoDepictionURL, NO, ^(NSData *data, NSError *error, NSInteger status){
			NSLog(@"[Download] Completed. Status:%ld, Self:%@", (long)status, _self);
			if (data && (status == 200) && _self) {
				NSDictionary *newDepiction = [NSJSONSerialization
					JSONObjectWithData:data
					options:0
					error:nil
				];
				if (![newDepiction isKindOfClass:[NSDictionary class]]) return;
				__block __weak typeof(self) __self = _self;
				dispatch_async(dispatch_get_main_queue(), ^{
					__self.sileoDepiction = newDepiction;
				});
			}
		});
	}
}

#pragma mark - Methods for ignoring errors
- (void)forwardInvocation:(NSInvocation *)invocation {
	invocation.target = nil;
	NSLog(@"[Ignored] Selector: %@", NSStringFromSelector(invocation.selector));
	[invocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
	return [super methodSignatureForSelector:selector] ?: 
		[NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)setValue:(id)value forUndefinedKey:(id)key {
	NSLog(@"[SetFailure] Key: %@, Value: %@", key, value);
}

- (void)setValue:(id)value forKey:(id)key {
	NSLog(@"[SetAttempt] Key: %@, Value: %@", key, value);
	[super setValue:value forKey:key];
}

#pragma mark - Methods for Cydia
- (id)initWithDatabase:(Database *)database
	forPackage:(NSString *)name
	withReferrer:(NSString *)referrer
{
	_packageID = name;
	if (!self.package) return nil;
	self = [self init];
	return self;
}

#pragma mark - Methods for Zebra
- (id)initWithPackageID:(NSString *)packageID fromRepo:(ZBRepo *)repo {
	NSLog(@"[Zebra] Initializing the proper way...");
	_packageID = packageID;
	_repo = repo;
	if (!self.package) return nil;
	self = [self init];
	return self;
}

// This is necessary to trick Zebra into giving a ZBPackage instance in some cases
- (BOOL)isKindOfClass:(Class)_class {
	return [super isKindOfClass:_class] || (_class == objc_getClass("ZBPackageDepictionViewController"));
}

- (void)setPackage:(ZBPackage *)package {
	_package = package;
	_packageID = package.identifier;
	_repo = package.repo;
}

@end