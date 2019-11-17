#import "MDDepictionViewController.h"
#import "MDStackView.h"
#import <Extensions/UIImage+ImageWithColor.h>

@implementation MDDepictionViewController

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
- (id)initWithPackageID:(NSString *)packageID fromRepo:(ZBRepo *_Nullable)repo {
	return [self init];
}

- (void)setPackage:(id)package {
	_package = package;
	//self.title = MDGetFieldFromPackage(package, @"name");
	NSLog(@"Package: %@ (%@)", package, NSStringFromClass([package class]));
}

#pragma mark - The UI code
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	for (UIView *view in self.view.subviews) {
		// We don't want the views added by Zebra
		[view removeFromSuperview];
	}
	self.edgesForExtendedLayout = UIRectEdgeTop;
	
	// Header Image View
	_headerImageView = [UIImageView new];
	_headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	_headerImageView.image = [UIImage imageWithColor:[UIColor redColor]];
	[self.view addSubview:_headerImageView];
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
		toItem:self.view
		attribute:NSLayoutAttributeWidth
		multiplier:1.0
		constant:0.0
	];
	_headerImagePosition = [NSLayoutConstraint
		constraintWithItem:_headerImageView
		attribute:NSLayoutAttributeTop
		relatedBy:NSLayoutRelationEqual
		toItem:self.view
		attribute:NSLayoutAttributeTop
		multiplier:1.0
		constant:0.0
	];
	[self.view addConstraints:@[
		_headerImageHeight,
		_headerImageWidth,
		_headerImagePosition,
		[NSLayoutConstraint
			constraintWithItem:_headerImageView
			attribute:NSLayoutAttributeCenterX
			relatedBy:NSLayoutRelationEqual
			toItem:self.view
			attribute:NSLayoutAttributeCenterX
			multiplier:1.0
			constant:0.0
		]
	]];
}

@end