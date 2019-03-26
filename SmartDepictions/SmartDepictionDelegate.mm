#import "SmartDepictionDelegate.h"
#import "DepictionRootView.h"
#import "SmartPackageController.h"
#import "GetPackageCell.h"
#import "DepictionImageView.h"
#import "DepictionStackView.h"
#import "../Extensions/UIColor+HexString.h"

@implementation SmartDepictionDelegate

NSArray *resizableCellClasses;
UIColor *defaultTintColor;

+ (UIColor *)defaultTintColor {
	return defaultTintColor;
}

+ (void)initialize {
	if ([self class] == [SmartDepictionDelegate class]) {
		resizableCellClasses = @[
			[DepictionImageView class],
			[DepictionStackView class]
		];
		defaultTintColor = [UIColor colorWithRed:0.173 green:0.694 blue:0.745 alpha:1.0];
	}
}

- (void)updateCells {
	[self.packageController.depictionRootView beginUpdates];
	[self.packageController.depictionRootView endUpdates];
}

- (void)handleRotation {
	[self updateCells];
}

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
	_tintColor = self.class.defaultTintColor;
	_packageController = packageController;
	_packageID = packageID;
	_depictionURL = depictionURL;
	_operationQueue = [[NSOperationQueue alloc] init];
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
		if ([_depiction isKindOfClass:[NSDictionary class]]) {
			NSLog(@"-[%@ loadDepiction]", self.packageController);
			if (_depiction[@"tintColor"]) {
				_tintColor = [UIColor colorWithHexString:_depiction[@"tintColor"]];
			}
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
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		NSLog(@"Asynchronously downloading data from URL: %@", url);
		[NSURLConnection sendAsynchronousRequest:request
			queue:self.operationQueue
			completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
				NSLog(@"Downloaded completed for \"%@\" with error: %@", url, error);
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