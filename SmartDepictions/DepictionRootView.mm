#import "DepictionRootView.h"
#import "GetPackageCell.h"
#import "SmartDepictionDelegate.h"
#import "DepictionTabView.h"
#import "../Extensions/UINavigationController+Opacity.h"

@implementation DepictionRootView

// TESTING
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < topCells.count) {
		return topCells[indexPath.row];
	}
	return nil;
}

// TESTING
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return topCells.count;
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
	self = [super init];
	topCells = [[NSMutableArray alloc] init];
	_depictionDelegate = delegate;
	self.dataSource = self;
	self.delegate = self;
	self.allowsSelection = NO;
	_getPackageCell = [[GetPackageCell alloc] initWithDepictionDelegate:self.depictionDelegate reuseIdentifier:@"getpackagecell"];
	[topCells addObject:self.getPackageCell];
	_tabController = [[DepictionTabView alloc] initWithReuseIdentifier:@"tabControl"];
	if (_tabController) [topCells addObject:_tabController];
#if !DEBUG
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
	return self;
}

- (void)loadDepiction {
	self.tabController.tabs = self.depictionDelegate.depiction[@"tabs"];
	[self reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.depictionDelegate scrollViewDidScroll:scrollView];
}

@end