#import "SmartPackageController.h"
#import "../Extensions/UINavigationController+Opacity.h"
#import "../Extensions/UIImage+ImageWithColor.h"
#import "SmartDepictionDelegate.h"
#import "DepictionRootView.h"
#import "DepictionTabView.h"

@implementation SmartPackageController

- (SmartPackageController *)initWithDepictionURL:(NSURL *)depictionURL database:(id)database packageID:(NSString *)packageID {
	self = [super init];
	_packageController = self;
	_depictionDelegate = [[SmartDepictionDelegate alloc] initWithPackageController:self
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

// This method is called by Cydia itself
- (void)setDelegate:(Cydia *)delegate {
	self.depictionDelegate.cydiaDelegate = delegate;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.clear = NO;
	self.navigationController.navigationBar.translucent = NO;
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
	self.navigationController.clear = YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	navBarLowerY = 0.0;
	
	// The intended image will be shown after the depiction data is downloaded.
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	imageView.image = [UIImage imageWithColor:[UIColor cyanColor]];
	
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
}

- (void)dealloc {
	NSLog(@"Deallocating package controller...");
}

@end