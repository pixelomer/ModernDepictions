#import "MDDepictionViewController.h"
#import "MDSileoDepictionStackView.h"
#import <Extensions/UIImage+ImageWithColor.h>
#import "Depictions.h"

@implementation MDDepictionViewController

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
	self.view.backgroundColor = [UIColor whiteColor];
	for (UIView *view in self.view.subviews) {
		// We don't want the views added by Zebra
		[view removeFromSuperview];
	}
	self.edgesForExtendedLayout = UIRectEdgeTop;
	
	// Header Image View
	UIView *containerView = [UIView new];
	containerView.clipsToBounds = NO;
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	_headerImageView = [UIImageView new];
	_headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	_headerImageView.image = [UIImage imageWithColor:[UIColor redColor]];
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
		constant:200.0
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
	_headerImagePosition = [NSLayoutConstraint
		constraintWithItem:_headerImageView
		attribute:NSLayoutAttributeTop
		relatedBy:NSLayoutRelationEqual
		toItem:containerView
		attribute:NSLayoutAttributeTop
		multiplier:1.0
		constant:0.0
	];
	[containerView addConstraints:@[
		_headerImageHeight,
		_headerImageWidth,
		_headerImagePosition,
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

	// Scroll View and Image Container Layout
	_depictionScrollView = [UIScrollView new];
	//_depictionScrollView.scrollEnabled = NO;
	_depictionScrollView.pagingEnabled = YES;
	_depictionScrollView.directionalLockEnabled = YES;
	_depictionScrollView.alwaysBounceHorizontal = NO;
	_depictionScrollView.alwaysBounceVertical = NO;
	_depictionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_depictionScrollView];
	_depictionScrollView.layer.zPosition = 0.0;
	NSDictionary *views = @{ @"scroll" : _depictionScrollView, @"image" : containerView };
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[image]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[scroll]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[image(200)][scroll]|"
		options:0
		metrics:nil
		views:views
	]];

	[self reloadData];
}

- (void)parseDepiction {
	NSArray *parsed = MDParseSileoDepiction(_sileoDepiction);
	if (parsed.count > 0) {
		_depictionStackViews = parsed;
		for (UIView *view in _depictionScrollView.subviews) {
			// We don't want the views added by Zebra
			[view removeFromSuperview];
		}
		UIView *prevView = _depictionScrollView;
		for (MDSileoDepictionStackView *stackView in _depictionStackViews) {
			stackView.translatesAutoresizingMaskIntoConstraints = NO;
			UIScrollView *stackViewContainer = [UIScrollView new];
			stackViewContainer.directionalLockEnabled = YES;
			stackViewContainer.alwaysBounceVertical = YES;
			stackViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
			[stackViewContainer addSubview:stackView];
			#define EQUAL_CONSTRAINT(item1, item2, attr) [NSLayoutConstraint \
				constraintWithItem: item1 \
				attribute: attr \
				relatedBy:NSLayoutRelationEqual \
				toItem: item2 \
				attribute: attr \
				multiplier:1.0 \
				constant:0.0 \
			]
			#define EQUAL_ATTR(attr) EQUAL_CONSTRAINT(stackView, stackViewContainer, attr)
			[stackViewContainer addConstraints:@[
				EQUAL_ATTR(NSLayoutAttributeLeft),
				EQUAL_ATTR(NSLayoutAttributeRight),
				EQUAL_ATTR(NSLayoutAttributeTop),
				EQUAL_ATTR(NSLayoutAttributeBottom),
				EQUAL_ATTR(NSLayoutAttributeHeight),
				EQUAL_ATTR(NSLayoutAttributeWidth)
			]];
			[_depictionScrollView addSubview:stackViewContainer];
			#undef EQUAL_ATTR
			#define EQUAL_ATTR(attr) EQUAL_CONSTRAINT(stackViewContainer, _depictionScrollView, attr)
			NSLayoutAttribute attr = (
				(prevView == _depictionScrollView) ?
				NSLayoutAttributeLeading :
				NSLayoutAttributeTrailing
			);
			[_depictionScrollView addConstraints:@[
				[NSLayoutConstraint
					constraintWithItem:stackViewContainer
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
			prevView = (id)stackViewContainer;
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

- (void)setSileoDepiction:(NSDictionary *)depiction {
	_sileoDepiction = depiction;
	[self parseDepiction];
}

- (NSURL *)sileoDepictionURL {
	NSString *URLString = MDGetFieldFromPackage(self.package, @"sileodepiction");
	return URLString ? [NSURL URLWithString:URLString] : nil;
}

- (void)reloadData {
	NSString *markdown = (
		MDGetFieldFromPackage(self.package, @"description") ?:
		MDGetFieldFromPackage(self.package, @"name") ?:
		MDGetFieldFromPackage(self.package, @"package") ?:
		@"Invalid Package"
	);
	self.sileoDepiction = @{
		@"minVersion" : @"0.1",
		@"tabs" : @[
			@{
				@"tabname" : @"Details",
				@"views" : @[
					@{
						@"class" : @"DepictionMarkdownView",
						@"markdown" : markdown,
						@"useRawFormat" : @NO
					}
				],
				@"class" : @"DepictionStackView"
			}
		],
		@"class" : @"DepictionTabView"
	};
	if (self.sileoDepictionURL) {
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