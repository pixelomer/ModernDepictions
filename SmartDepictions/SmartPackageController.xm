#import "SmartPackageController.h"
#import "../Extensions/UINavigationController+Opacity.h"

@implementation SmartPackageController

- (void)handleGetButton {
	NSLog(@"Handling modification button for %@", self.package);
	[self.delegate performSelector:@selector(installPackage:) withObject:self.package];
}

- (SmartPackageController *)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID referrer:(NSString *)referrer {
	[super init];
	_database = [database retain];
	_packageName = [packageID copy];
	depiction = [dict copy];
	isiPad = ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]
		&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	_depictionRootView = [[DepictionRootView alloc] initWithDepiction:depiction database:database packageID:packageID];
	self.depictionRootView.frame = self.view.frame;
	//self.depictionRootView.delegate = (id<UITableViewDelegate>)self;
	//self.depictionRootView.dataSource = self.depictionRootView;
	return self;
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

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationController.clear = YES;
	
	// Get the header image and show it
	NSData *rawImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[depiction objectForKey:@"headerImage"]]];
	NSLog(@"%@: %@", [depiction objectForKey:@"headerImage"], rawImage);
	if (rawImage) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:rawImage]];
	}
	else imageView = [[UIImageView alloc] init];

	// Set the image's frame
	imageView.frame = CGRectMake(0, 0, origImageWidth = UIScreen.mainScreen.bounds.size.width,
		origImageHeight = UIScreen.mainScreen.bounds.size.width * (imageView.image.size.height / imageView.image.size.width));

	// Set the content inset to make place for the image
	self.depictionRootView.contentInset = UIEdgeInsetsMake(origImageHeight, 0, 0, 0);
	self.depictionRootView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

	// Show the DepictionRootView
	[self.view addSubview:self.depictionRootView];

	// Prepare and show the image view
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	[self.view addSubview:imageView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	double offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
	NSLog(@"Received: %f, Calculated: %f", scrollView.contentOffset.y, offsetY);
	if (offsetY <= 0.0) {
		double h = max(origImageHeight - offsetY, origImageHeight);
		double WHRatio = (origImageWidth / origImageHeight);
		double w = origImageWidth + ((h - origImageHeight) * WHRatio);
		imageView.bounds = CGRectMake(0, 0, w, h);
	}
	else {
		imageView.center = CGPointMake(origImageWidth / 2, (origImageHeight / 2) - offsetY);
		self.navigationController.opacity = min(offsetY / origImageHeight, 1.0);
	}
}

@end