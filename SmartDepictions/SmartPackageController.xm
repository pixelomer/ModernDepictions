#import "SmartPackageController.h"
#import "../Extensions/UINavigationController+Opacity.h"

@implementation SmartPackageController

- (void)handleGetButton {
	NSLog(@"Handling modification button for %@", self.package);
	[self.delegate performSelector:@selector(installPackage:) withObject:self.package];
}

- (void)reloadData {
	if (_package) [_package release];
    _package = [[self.database packageWithName:self.packageName] retain];
    NSArray *versions = [self.package downgrades];

	if (modificationButtons) [modificationButtons release];
	modificationButtons = [[NSMutableArray alloc] init];

    if (self.package != nil) {
        [(Package *) self.package parse];

        if ([self.package mode] != nil)
            [modificationButtons addObject:@"CLEAR"];
        if ([self.package source] == nil);
        else if ([self.package upgradableAndEssential:NO])
            [modificationButtons addObject:@"UPGRADE"];
        else if ([self.package uninstalled])
            [modificationButtons addObject:@"INSTALL"];
        else
            [modificationButtons addObject:@"REINSTALL"];
        if (![self.package uninstalled])
            [modificationButtons addObject:@"REMOVE"];
        if ([versions count] != 0)
            [modificationButtons addObject:@"DOWNGRADE"];
    }
    switch ([modificationButtons count]) {
        case 0: modificationButtonTitle = nil; break;
        case 1: modificationButtonTitle = modificationButtons[0]; break;
        default: modificationButtonTitle = @"MODIFY"; break;
    }
}

- (SmartPackageController *)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID referrer:(NSString *)referrer {
	PerformSelector(UIViewController, self, @selector(init));
	_database = [database retain];
	_packageName = [packageID copy];

	depiction = [dict copy];
	isiPad = ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]
		&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);

	// Replace its delegate with self in order to make certain things work
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
	NSLog(@"-[super viewDidLoad] completed.");
	[self reloadData];
	NSLog(@"Reloaded data.");
	// Initialize the table view
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame];
	self.tableView.delegate = (id<UITableViewDelegate>)self;
	[self.view addSubview:self.tableView];

	// Disable auto contentInset adjustment
	if (@available(iOS 11.0, *)) self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	else self.automaticallyAdjustsScrollViewInsets = false;

	// Make the navigation bar translucent
	self.navigationController.clear = YES;
#if !DEBUG
	// Hide the seperators
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif

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
	self.tableView.contentInset = UIEdgeInsetsMake(origImageHeight, 0, 0, 0);

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
		imageView.center = CGPointMake(w/2 - ((h - origImageHeight) * WHRatio)/2, h/2);
	}
	else {
		imageView.center = CGPointMake(origImageWidth / 2, (origImageHeight / 2) - offsetY);
		self.navigationController.opacity = min(offsetY / origImageHeight, 1.0);
	}
}

@end