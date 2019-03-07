#import "SmartPackageController.h"
#import "../Extensions/UINavigationController+Opacity.h"
#import "SmartDepictionDelegate.h"
#import "DepictionRootView.h"

@implementation SmartPackageController

- (SmartPackageController *)initWithDepiction:(NSDictionary *)depiction database:(id)database packageID:(NSString *)packageID {
	[super init];
	_depictionDelegate = [[SmartDepictionDelegate alloc] initWithPackageController:self
		depiction:depiction
		database:database
		packageID:packageID
	];
	isiPad = ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]
		&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	_depictionRootView = [[DepictionRootView alloc] initWithDepictionDelegate:self.depictionDelegate];
	NSLog(@"Root view: %@", self.depictionRootView);
	return self;
}

// This method is called by Cydia itself
- (void)setDelegate:(Cydia *)delegate {
	self.depictionDelegate.cydiaDelegate = delegate;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.clear = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.clear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"View controller appeared, requesting a reload from %@", self.depictionDelegate);
	[self.depictionDelegate reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	navBarLowerY = 0.0;
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.clear = YES;
	
	// Get the header image and show it
	NSData *rawImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.depictionDelegate.depiction objectForKey:@"headerImage"]]];
	NSLog(@"%@: %@", [self.depictionDelegate.depiction objectForKey:@"headerImage"], rawImage);
	if (rawImage) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:rawImage]];
	}
	else imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)]; // TESTING

	// Show the DepictionRootView
	[self.view addSubview:self.depictionRootView];

	// Prepare and show the image view
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	[self.view addSubview:imageView];
	[self resetViews];
	[self resetDepictionRootView];
}

- (void)resetViews {
	imageView.frame = CGRectMake(0, 0, origImageWidth = UIScreen.mainScreen.bounds.size.width,
		origImageHeight = UIScreen.mainScreen.bounds.size.width * (imageView.image.size.height / imageView.image.size.width));
}

- (void)resetDepictionRootView {
	self.depictionRootView.frame = self.view.frame;
	self.depictionRootView.contentInset = UIEdgeInsetsMake(origImageHeight, 0, 0, 0);
	self.depictionRootView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        // First reset - Makes the transition smooth.
		[self resetViews];

    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        // Second reset - Fixes the DepictionRootView.
		[self resetDepictionRootView];

    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (navBarLowerY == 0.0)
		navBarLowerY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
	double offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
	NSLog(@"Received: %f, Calculated: %f", scrollView.contentOffset.y, offsetY);
	if (offsetY <= 0.0) {
		double h = max(origImageHeight - offsetY, origImageHeight);
		double WHRatio = (origImageWidth / origImageHeight);
		double w = origImageWidth + ((h - origImageHeight) * WHRatio);
		imageView.bounds = CGRectMake(0, 0, w, h);
		imageView.center = CGPointMake(origImageWidth / 2, imageView.bounds.size.height / 2);
	}
	else {
		imageView.center = CGPointMake(origImageWidth / 2, (origImageHeight / 2) - offsetY);
		self.navigationController.opacity = min(offsetY / (origImageHeight - navBarLowerY), 1.0);
	}
}

@end