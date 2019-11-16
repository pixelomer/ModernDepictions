#import "MDDepictionViewController.h"
#import "MDStackView.h"

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
	// BEGIN: MDStackView tests
	MDStackView *testView = [MDStackView new];
	for (int i = 0; i <= 2; i++) {
		UIView *newView = [UIView new];
		UIView *subview = [UIView new];
		[newView addSubview:subview];
		subview.translatesAutoresizingMaskIntoConstraints = NO;
		newView.translatesAutoresizingMaskIntoConstraints = NO;
		[newView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[subview(50)]|"
			options:0
			metrics:nil
			views:@{ @"subview" : subview }
		]];
		newView.backgroundColor = [UIColor colorWithRed:(i * 50.0)/255.0 green:0.0 blue:0.0 alpha:1.0];
		[testView insertView:newView];
	}
	[self.view addSubview:testView];
	testView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[view]|"
		options:0
		metrics:nil
		views:@{ @"view" : testView }
	]];
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[view]|"
		options:0
		metrics:nil
		views:@{ @"view" : testView }
	]];
	// END: MDStackView tests
}

@end