#import "SmartDepictionDelegate.h"
#import "DepictionRootView.h"
#import "SmartPackageController.h"
#import "GetPackageCell.h"

@implementation SmartDepictionDelegate

- (NSString *)modificationButtonTitle {
	return modificationButtonTitle;
}

- (void)setModificationButtonTitle:(NSString *)newTitle {
	if (modificationButtonTitle) [modificationButtonTitle release];
	modificationButtonTitle = [newTitle retain];
	self.packageController.depictionRootView.getPackageCell.buttonTitle = newTitle;
}

- (instancetype)initWithPackageController:(SmartPackageController *)packageController
	depiction:(NSDictionary *)depictionDict
	database:(Database *)database
	packageID:(NSString *)packageID
{
	[super init];
	_packageController = [packageController retain];
	_packageID = [packageID retain];
	_depiction = [depictionDict retain];
	[self setPackageWithID:packageID database:database];
	return self;
}

- (void)handleModifyButton {
	// TESTING
	[self.cydiaDelegate installPackage:self.package];
}

- (void)setPackageWithID:(NSString *)packageID database:(Database *)database {
	if (_database) [_database release];
	if (_packageID) [_packageID release];
	_database = [database retain];
	_packageID = [packageID retain];
	[self reloadData];
}

- (void)reloadData {
	NSLog(@"Reloading data");
	if (_package) [_package release];
    _package = [[self.database packageWithName:self.packageID] retain];
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
	
	if (_modificationButtons) [_modificationButtons release];
	_modificationButtons = [modificationButtons copy];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.packageController scrollViewDidScroll:scrollView];
}

@end