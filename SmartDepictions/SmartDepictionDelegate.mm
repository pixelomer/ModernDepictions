#import "SmartDepictionDelegate.h"
#import "DepictionRootView.h"
#import "SmartPackageController.h"
#import "GetPackageCell.h"

@implementation SmartDepictionDelegate

- (NSString *)modificationButtonTitle {
	return modificationButtonTitle;
}

- (void)setModificationButtonTitle:(NSString *)newTitle {
	modificationButtonTitle = newTitle;
	self.packageController.depictionRootView.getPackageCell.buttonTitle = newTitle;
}

- (instancetype)initWithPackageController:(SmartPackageController *)packageController
	depictionURL:(NSURL *)depictionURL
	database:(Database *)database
	packageID:(NSString *)packageID
{
	self = [super init];
	_packageController = packageController;
	_packageID = packageID;
	_depictionURL = depictionURL;
	if (@available(iOS 7.0, *)) _iOS6 = false;
	else _iOS6 = true;
	[self setPackageWithID:packageID database:database];
	return self;
}

- (void)handleModifyButton {
	// TESTING
	[self.cydiaDelegate installPackage:self.package];
}

- (void)downloadDepiction {
	if (!_depictionURL) return;
	[self downloadDataFromURL:_depictionURL completion:^(NSData *data, NSError *error){
		if (!data) return;
		_depiction = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		NSLog(@"Depiction: %@", _depiction);
		if (_depiction) {
			NSLog(@"-[%@ loadDepiction]", self.packageController);
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.packageController loadDepiction];
			});
		}
	}];
}

- (void)setPackageWithID:(NSString *)packageID database:(Database *)database {
	_database = database;
	_packageID = packageID;
	[self reloadData];
}

- (void)reloadData {
	NSLog(@"Reloading data");
	_package = [self.database packageWithName:self.packageID];
	NSArray *versions = [self.package downgrades];

	NSMutableArray *modificationButtons = [[NSMutableArray alloc] init];
	if (self.package != nil) {
		[self.package parse];

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
	NSLog(@"Package Controller: %@\nRoot view: %@\nGet Package Cell: %@", self.packageController, self.packageController.depictionRootView, self.packageController.depictionRootView);
	self.packageController.depictionRootView.getPackageCell.package = self.package;
	self.packageController.depictionRootView.getPackageCell.buttonTitle = UCLocalize(modificationButtonTitle);
	
	_modificationButtons = [modificationButtons copy];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.packageController scrollViewDidScroll:scrollView];
}

- (void)downloadDataFromURL:(NSURL *)url completion:(void (^)(NSData *, NSError *))completionHandler {
	if (!url) return;
	@autoreleasepool {
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		NSLog(@"Asynchronously downloading data from URL: %@", url);
		[NSURLConnection sendAsynchronousRequest:request
			queue:queue
			completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
				completionHandler(data, error);
			}
		];
	}
}

// Only allows NULL. Used to deallocate the package controller.
- (void)setPackageController:(SmartPackageController *)newPackageController {
	if (!newPackageController) _packageController = nil;
}

@end