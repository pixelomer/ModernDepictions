#import "SmartPackageController.h"
#import "../Extensions/UINavigationController+Clear.h"
#import <substrate.h>

@implementation SmartPackageController

- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID referrer:(NSString *)referrer {
	[super init];
	_depiction = [dict copy];

	// Create a dummy CYPackageController for the installation stuff
	_dummyController = [[%c(CYPackageController) alloc] initWithDatabase:database forPackage:packageID withReferrer:referrer];
	[_dummyController setSDDelegateOverride:self];
	[_dummyController reloadData];

	IsWildcat_ = ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]
		&& [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);

	// Replace its delegate with self in order to make certain things work
	return self;
}

- (void)showActionSheet:(UIActionSheet *)sheet fromItem:(UIBarButtonItem *)item {
	sheet.delegate = (id<UIActionSheetDelegate>)_dummyController;
	if (!IsWildcat_) {
       [sheet addButtonWithTitle:UCLocalize("CANCEL")];
       [sheet setCancelButtonIndex:[sheet numberOfButtons] - 1];
    }
    if (item != nil && IsWildcat_) {
        [sheet showFromBarButtonItem:item animated:YES];
    } else {
        [sheet showInView:[[[UIApplication sharedApplication] windows] firstObject]];
    }
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

	// Initialize the table view
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame];
	_tableView.delegate = (id<UITableViewDelegate>)self;
	[self.view addSubview:_tableView];
	
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
	NSData *rawImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_depiction objectForKey:@"headerImage"]]];
	NSLog(@"%@: %@", [_depiction objectForKey:@"headerImage"], rawImage);
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

	// Apply the right button
	[[self navigationItem] setRightBarButtonItem:[_dummyController rightButton]];
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
		self.navigationController.clearness = offsetY / origImageHeight;
	}
}

@end