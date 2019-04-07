#import "ModernPackageController.h"
#import <Extensions/UINavigationController+Opacity.h>
#import <Extensions/UIImage+ImageWithColor.h>
#import "ModernDepictionDelegate.h"
#import "DepictionRootView.h"
#import "DepictionTabView.h"

@implementation ModernPackageController

static UIImage *shadowImage;
static UIColor *origTintColor;

+ (void)load {
	if ([self class] == [ModernPackageController class]) {
		unsigned char shadowImageBytes[] = {
			0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
			0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x56,
			0x08, 0x06, 0x00, 0x00, 0x00, 0x0e, 0x9e, 0xfc, 0xc6, 0x00, 0x00, 0x00,
			0x01, 0x73, 0x52, 0x47, 0x42, 0x00, 0xae, 0xce, 0x1c, 0xe9, 0x00, 0x00,
			0x01, 0x59, 0x69, 0x54, 0x58, 0x74, 0x58, 0x4d, 0x4c, 0x3a, 0x63, 0x6f,
			0x6d, 0x2e, 0x61, 0x64, 0x6f, 0x62, 0x65, 0x2e, 0x78, 0x6d, 0x70, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x3c, 0x78, 0x3a, 0x78, 0x6d, 0x70, 0x6d, 0x65,
			0x74, 0x61, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x78, 0x3d, 0x22,
			0x61, 0x64, 0x6f, 0x62, 0x65, 0x3a, 0x6e, 0x73, 0x3a, 0x6d, 0x65, 0x74,
			0x61, 0x2f, 0x22, 0x20, 0x78, 0x3a, 0x78, 0x6d, 0x70, 0x74, 0x6b, 0x3d,
			0x22, 0x58, 0x4d, 0x50, 0x20, 0x43, 0x6f, 0x72, 0x65, 0x20, 0x35, 0x2e,
			0x34, 0x2e, 0x30, 0x22, 0x3e, 0x0a, 0x20, 0x20, 0x20, 0x3c, 0x72, 0x64,
			0x66, 0x3a, 0x52, 0x44, 0x46, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a,
			0x72, 0x64, 0x66, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f,
			0x77, 0x77, 0x77, 0x2e, 0x77, 0x33, 0x2e, 0x6f, 0x72, 0x67, 0x2f, 0x31,
			0x39, 0x39, 0x39, 0x2f, 0x30, 0x32, 0x2f, 0x32, 0x32, 0x2d, 0x72, 0x64,
			0x66, 0x2d, 0x73, 0x79, 0x6e, 0x74, 0x61, 0x78, 0x2d, 0x6e, 0x73, 0x23,
			0x22, 0x3e, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3c, 0x72, 0x64,
			0x66, 0x3a, 0x44, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6f,
			0x6e, 0x20, 0x72, 0x64, 0x66, 0x3a, 0x61, 0x62, 0x6f, 0x75, 0x74, 0x3d,
			0x22, 0x22, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x74, 0x69, 0x66,
			0x66, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x6e, 0x73,
			0x2e, 0x61, 0x64, 0x6f, 0x62, 0x65, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x74,
			0x69, 0x66, 0x66, 0x2f, 0x31, 0x2e, 0x30, 0x2f, 0x22, 0x3e, 0x0a, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x3c, 0x74, 0x69, 0x66,
			0x66, 0x3a, 0x4f, 0x72, 0x69, 0x65, 0x6e, 0x74, 0x61, 0x74, 0x69, 0x6f,
			0x6e, 0x3e, 0x31, 0x3c, 0x2f, 0x74, 0x69, 0x66, 0x66, 0x3a, 0x4f, 0x72,
			0x69, 0x65, 0x6e, 0x74, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x3e, 0x0a, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x3c, 0x2f, 0x72, 0x64, 0x66, 0x3a, 0x44,
			0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x3e, 0x0a,
			0x20, 0x20, 0x20, 0x3c, 0x2f, 0x72, 0x64, 0x66, 0x3a, 0x52, 0x44, 0x46,
			0x3e, 0x0a, 0x3c, 0x2f, 0x78, 0x3a, 0x78, 0x6d, 0x70, 0x6d, 0x65, 0x74,
			0x61, 0x3e, 0x0a, 0x4c, 0xc2, 0x27, 0x59, 0x00, 0x00, 0x00, 0x9e, 0x49,
			0x44, 0x41, 0x54, 0x18, 0x19, 0x65, 0x50, 0x41, 0x0e, 0x03, 0x21, 0x08,
			0x54, 0xd4, 0x35, 0x26, 0xa6, 0xaf, 0xf2, 0x53, 0xfd, 0xb0, 0x5f, 0xe8,
			0xc1, 0x04, 0x0a, 0xb3, 0xb6, 0x34, 0xd6, 0xc3, 0x64, 0x86, 0x61, 0x58,
			0xd8, 0x10, 0x42, 0x78, 0x92, 0xbe, 0x87, 0xc1, 0x8b, 0x54, 0xb2, 0x31,
			0x31, 0x60, 0x4a, 0x29, 0xc9, 0xb7, 0xf6, 0x2b, 0xb5, 0x4f, 0xcc, 0xdd,
			0xcd, 0x2e, 0x9d, 0xc5, 0x18, 0xf9, 0xce, 0x62, 0x0a, 0xa4, 0xb3, 0x4f,
			0x9f, 0x10, 0x0c, 0x85, 0xcd, 0xbc, 0xe5, 0x30, 0x72, 0xce, 0x68, 0xf9,
			0x4b, 0x20, 0x8b, 0x75, 0x01, 0x2e, 0x0f, 0x06, 0x89, 0x9d, 0x9d, 0xb1,
			0x3e, 0x3b, 0x75, 0x1f, 0x03, 0x43, 0x3f, 0xc4, 0xe4, 0x06, 0x5c, 0x00,
			0x6a, 0xa5, 0x14, 0xa6, 0xeb, 0xba, 0x98, 0xd6, 0x5a, 0x72, 0x32, 0xb4,
			0x60, 0x53, 0x3d, 0x30, 0x50, 0x6b, 0x6d, 0x8f, 0xd2, 0x84, 0xdc, 0x43,
			0x45, 0x84, 0xa9, 0xd6, 0x2a, 0x04, 0x86, 0x44, 0xef, 0x7d, 0xff, 0x67,
			0xc4, 0x14, 0x98, 0xe6, 0x9c, 0x42, 0x63, 0x0c, 0xb6, 0x52, 0x34, 0x08,
			0x6f, 0xb1, 0x62, 0x76, 0xa9, 0x94, 0x22, 0x3e, 0x94, 0x00, 0x00, 0x00,
			0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
		};
		shadowImage = [UIImage imageWithData:[NSData dataWithBytes:shadowImageBytes length:sizeof(shadowImageBytes)]];
		origTintColor = nil;
	}
}

+ (void)setOriginalNavBarTintColor:(UIColor *)newColor {
	if (!origTintColor) origTintColor = newColor;
}

- (ModernPackageController *)initWithDepictionURL:(NSURL *)depictionURL database:(id)database packageID:(NSString *)packageID {
	self = [super init];
	_packageController = self;
	_depictionDelegate = [[ModernDepictionDelegate alloc] initWithPackageController:self
		depictionURL:depictionURL
		database:database
		packageID:packageID
	];
	_depictionRootView = [[DepictionRootView alloc] initWithDepictionDelegate:self.depictionDelegate];
	self.depictionRootView.translatesAutoresizingMaskIntoConstraints = NO;
	if (@available(iOS 11.0, *)) self.depictionRootView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	else if (@available(iOS 7.0, *)) self.automaticallyAdjustsScrollViewInsets = NO;
	NSLog(@"Root view: %@", self.depictionRootView);
	[self.depictionDelegate downloadDepiction];
	return self;
}

- (void)setOriginalInvocation:(NSInvocation *)originalInvocation {
	self.depictionDelegate.originalInvocation = originalInvocation;
}

- (void)setReferrer:(NSString *)referrer {
	self.depictionDelegate.referrer = referrer;
}

// This method is called by Cydia itself
- (void)setDelegate:(Cydia *)delegate {
	self.depictionDelegate.cydiaDelegate = delegate;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.clear = NO;
	self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
	self.navigationController.navigationBar.tintColor = origTintColor;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
	[super didMoveToParentViewController:parent];
	if (!parent) {
		// It's time to deallocate, the view controller has completely disappeared
		NSLog(@"Package controller disappeared, releasing self...");
		self.depictionDelegate.packageController = nil;
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.translucent = YES;
	[self.depictionDelegate reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self scrollViewDidScroll:self.depictionRootView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	navBarLowerY = 0.0;
	
	// The intended image will be shown after the depiction data is downloaded.
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	imageView.image = [UIImage imageWithColor:ModernDepictionDelegate.defaultTintColor];
	
	// Show the DepictionRootView
	[self.view addSubview:self.depictionRootView];
	NSDictionary *views = @{ @"drw" : self.depictionRootView };
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[drw]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[drw]|"
		options:0
		metrics:nil
		views:views
	]];

	// Prepare and show the image view
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	[self.view addSubview:imageView];
	[self resetViews];

	// Prepare and show the shadow view
	UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadowImage];
	shadowView.translatesAutoresizingMaskIntoConstraints = NO;
	shadowView.contentMode = UIViewContentModeScaleToFill;
	shadowView.clipsToBounds = YES;
	[self.view addSubview:shadowView];
	[self.view addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:shadowView
			attribute:NSLayoutAttributeLeft
			relatedBy:NSLayoutRelationEqual
			toItem:imageView
			attribute:NSLayoutAttributeLeft
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:shadowView
			attribute:NSLayoutAttributeBottom
			relatedBy:NSLayoutRelationEqual
			toItem:imageView
			attribute:NSLayoutAttributeBottom
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:shadowView
			attribute:NSLayoutAttributeTop
			relatedBy:NSLayoutRelationEqual
			toItem:imageView
			attribute:NSLayoutAttributeTop
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:shadowView
			attribute:NSLayoutAttributeRight
			relatedBy:NSLayoutRelationEqual
			toItem:imageView
			attribute:NSLayoutAttributeRight
			multiplier:1.0
			constant:0.0
		]
	]];

	self.navigationController.clear = NO;
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
	[self.class setOriginalNavBarTintColor:self.navigationController.navigationBar.tintColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)resetViews {
	imageView.frame = CGRectMake(0, imageView.frame.origin.y, origImageWidth = UIScreen.mainScreen.bounds.size.width, origImageHeight = 200);
	self.depictionRootView.contentInset = UIEdgeInsetsMake(origImageHeight, 0, self.tabBarController.tabBar.frame.size.height, 0);
	[self.depictionDelegate handleRotation];
}

- (void)loadDepiction {
	if (!self.depictionDelegate.depiction) return;
	NSLog(@"Loading the depiction...");
	NSURL *headerURL = [NSURL URLWithString:self.depictionDelegate.depiction[@"headerImage"]];
	NSLog(@"Got header URL: %@", headerURL);
	if (headerURL) [self.depictionDelegate downloadDataFromURL:headerURL completion:^(NSData *data, NSError *error) {
		if (!data || error) return;
		UIImage *remoteImage = [UIImage imageWithData:data];
		if (remoteImage) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				imageView.image = remoteImage;
				[self resetViews];
				[imageView setNeedsDisplay];
			});
		}
	}];
	[self.depictionRootView loadDepiction];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    // Code to execute before rotation.

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        // Code to execute during rotation.
		[self resetViews];

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        // Code to execute after rotation.

    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (navBarLowerY == 0.0) navBarLowerY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
	double offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
	NSLog(@"Received: %f, Calculated: %f", scrollView.contentOffset.y, offsetY);
	if (offsetY <= 0.0) {
		double h = max(origImageHeight - offsetY, origImageHeight);
		double WHRatio = (origImageWidth / origImageHeight);
		double w = origImageWidth + ((h - origImageHeight) * WHRatio);
		imageView.bounds = CGRectMake(0, 0, w, h);
		imageView.center = CGPointMake(origImageWidth / 2, imageView.bounds.size.height / 2);
		self.navigationController.opacity = 0.0;
	}
	else {
		imageView.center = CGPointMake(origImageWidth / 2, (origImageHeight / 2) - offsetY);
		self.navigationController.opacity = min(offsetY / (origImageHeight - navBarLowerY), 1.0);
	}
	if (offsetY > (origImageHeight / 3)) {
		self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
		self.navigationController.navigationBar.tintColor = origTintColor;
	}
	else {
		self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	}
}

- (void)dealloc {
	NSLog(@"Deallocating %@...", self);
}

@end