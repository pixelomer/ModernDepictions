#import "DepictionRootView.h"
#import "GetPackageCell.h"
#import "SmartDepictionDelegate.h"
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

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate {
	[super init];
	topCells = [[NSMutableArray alloc] init];
	_depictionDelegate = [delegate retain];
	[self reloadData];
	self.dataSource = self;
	self.delegate = self;
	self.allowsSelection = NO;
	_getPackageCell = [[GetPackageCell alloc] initWithDepictionDelegate:self.depictionDelegate reuseIdentifier:@"getpackagecell"];
	[topCells addObject:self.getPackageCell];
#if !DEBUG
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.depictionDelegate scrollViewDidScroll:scrollView];
}

@end