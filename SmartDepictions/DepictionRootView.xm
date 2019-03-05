#import "DepictionRootView.h"
#import "GetPackageCell.h"
#import "../Extensions/UINavigationController+Opacity.h"

@implementation DepictionRootView

// TESTING
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		NSLog(@"%@", _getPackageCell);
		return _getPackageCell;
	}
	else return nil;
}

// TESTING
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < topCells.count) {
		return [topCells[indexPath.row] height];
	}
	else {
		// TESTING
		return 20.0;
	}
}

- (void)reloadData {
	if (_package) [_package release];
    _package = [[self.database packageWithName:self.packageName] retain];
    NSArray *versions = [self.package downgrades];

	if (_modificationButtons) [_modificationButtons release];
	_modificationButtons = [[NSMutableArray alloc] init];

    if (self.package != nil) {
        [(Package *) self.package parse];

        if ([self.package mode] != nil)
            [_modificationButtons addObject:@"CLEAR"];
        if ([self.package source] == nil);
        else if ([self.package upgradableAndEssential:NO])
            [_modificationButtons addObject:@"UPGRADE"];
        else if ([self.package uninstalled])
            [_modificationButtons addObject:@"INSTALL"];
        else
            [_modificationButtons addObject:@"REINSTALL"];
        if (![self.package uninstalled])
            [_modificationButtons addObject:@"REMOVE"];
        if ([versions count] != 0)
            [_modificationButtons addObject:@"DOWNGRADE"];
    }
    switch ([_modificationButtons count]) {
        case 0: modificationButtonTitle = nil; break;
        case 1: modificationButtonTitle = _modificationButtons[0]; break;
        default: modificationButtonTitle = @"MODIFY"; break;
    }
	self.getPackageCell.buttonTitle = UCLocalize(modificationButtonTitle);
}

- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID {
	[super init];
	topCells = [[NSMutableArray alloc] init];
	_database = [database retain];
	_packageName = [packageID retain];
	depiction = [dict retain];
	[self reloadData];
	self.dataSource = self;
	self.delegate = self;
	self.allowsSelection = NO;
	_getPackageCell = [[GetPackageCell alloc] initWithPackage:self.package reuseIdentifier:@"getpackagecell"];
	[topCells addObject:self.getPackageCell];
#if !DEBUG
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	id pvc = [self _viewControllerForAncestor];
	if (pvc && [pvc respondsToSelector:@selector(scrollViewDidScroll:)]) {
		[pvc performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
	}
}

@end