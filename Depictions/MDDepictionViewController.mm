#import "MDDepictionViewController.h"
#import "MDStackView.h"
#import <Extensions/UIImage+ImageWithColor.h>
#import "Depictions.h"

@implementation MDDepictionViewController

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
		for (UIView *stackView in _depictionStackViews) {
			// NOTE TO PIXEL: Continue from here...
		}
	}
}

- (void)setSileoDepiction:(NSDictionary *)depiction {
	_sileoDepiction = depiction;
	[self parseDepiction];
}

- (NSURL *)sileoDepictionURL {
	NSString *URLString = MDGetFieldFromPackage(_package, @"sileodepiction");
	return URLString ? [NSURL URLWithString:URLString] : nil;
}

- (void)reloadData {
	NSString *markdown = (
		MDGetFieldFromPackage(_package, @"description") ?:
		MDGetFieldFromPackage(_package, @"name") ?:
		MDGetFieldFromPackage(_package, @"package") ?:
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
		]
	};
	if (self.sileoDepictionURL) {
		__weak typeof(self) _self = self;
		MDGetDataFromURL(self.sileoDepictionURL, NO, ^(NSData *data, NSError *error, NSInteger status){
			if (data && (status == 200)) {
				NSDictionary *newDepiction = [NSJSONSerialization
					JSONObjectWithData:data
					options:0
					error:nil
				];
				if (![newDepiction isKindOfClass:[NSDictionary class]]) return;
				_self.sileoDepiction = newDepiction;
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
	NSLog(@"[Ignored] Key: %@, Value: %@", key, value);
}

#pragma mark - Methods for Cydia
- (id)initWithDatabase:(Database *)database
	forPackage:(NSString *)name
	withReferrer:(NSString *)referrer
{
	self = [self init];
	self.package = [database packageWithName:name];
	return self;
}

#pragma mark - Methods for Zebra
- (id)initWithPackageID:(NSString *)packageID fromRepo:(ZBRepo *)repo {
	self = [self init];
	ZBDatabaseManager *databaseManager = [objc_getClass("ZBDatabaseManager") sharedInstance];
	self.package = [databaseManager topVersionForPackageID:packageID inRepo:repo];
	return self;
}

- (void)setPackage:(id)package {
	_package = package;
	//self.title = MDGetFieldFromPackage(package, @"name");
	NSLog(@"Package: %@ (%@)", package, NSStringFromClass([package class]));
}

@end