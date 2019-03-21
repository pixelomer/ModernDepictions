#import "DepictionRootView.h"
#import "GetPackageCell.h"
#import "SmartDepictionDelegate.h"
#import "DepictionTabView.h"
#import "ContentCellFactory.h"
#import "../Extensions/UINavigationController+Opacity.h"

@implementation DepictionRootView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < topCells.count)
		return (UITableViewCell *)topCells[indexPath.row];
	else if (indexPath.row < tabCells[self.tabController.currentTab].count + topCells.count)
		return (UITableViewCell *)tabCells[self.tabController.currentTab][indexPath.row - topCells.count];
	else if (indexPath.row < tabCells[self.tabController.currentTab].count + topCells.count + footerCells.count)
		return (UITableViewCell *)footerCells[indexPath.row - topCells.count - tabCells[self.tabController.currentTab].count];
	return nil;
}

- (void)didSelectTabNamed:(NSString *)name {
	[self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return topCells.count + tabCells[self.tabController.currentTab].count + footerCells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell<SmartCell> * _Nullable cell = nil;
	if (indexPath.row < topCells.count)
		cell = topCells[indexPath.row];
	else if (indexPath.row < tabCells[self.tabController.currentTab].count + topCells.count)
		cell = (UITableViewCell<SmartCell> *)tabCells[self.tabController.currentTab][indexPath.row - topCells.count];
	else if (indexPath.row < tabCells[self.tabController.currentTab].count + topCells.count + footerCells.count)
		cell = (UITableViewCell<SmartCell> *)footerCells[indexPath.row - topCells.count - tabCells[self.tabController.currentTab].count];
	return cell ? [cell height] : 44.0;
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate {
	self = [super init];
	topCells = [[NSMutableArray alloc] init];
	footerCells = [[NSMutableArray alloc] init];
	_depictionDelegate = delegate;
	self.dataSource = self;
	self.delegate = self;
	self.allowsSelection = NO;
	_getPackageCell = [[GetPackageCell alloc] initWithDepictionDelegate:self.depictionDelegate reuseIdentifier:@"getpackagecell"];
	[topCells addObject:self.getPackageCell];
	_tabController = [[DepictionTabView alloc] initWithDelegate:self reuseIdentifier:@"tabControl"];
	[topCells addObject:_tabController];
	NSArray *dummyTabs = @[
		@{
			@"tabname" : @"Details",
			@"views" : @[
				@{
					@"class" : @"SmartContentCell",
					@"labelText" : self.depictionDelegate.package.longDescription ?: self.depictionDelegate.package.shortDescription ?: @""
				}
			]
		}
	];
	NSString *versionString = [self.depictionDelegate.package getField:@"version"];
	if (![versionString isKindOfClass:[NSString class]]) {
		versionString = @"?";
	}
	NSArray *footerCellDict = @[
		@{
		 @"markdown" : [NSString stringWithFormat:@"<small style=\"color: #aaa;\">%@ (%@)</small><style>body { text-align: center; }</style>", self.depictionDelegate.package.id, versionString],
		 @"class" : @"DepictionMarkdownView"
		}
	];
	footerCells = [[ContentCellFactory createCellsFromArray:footerCellDict delegate:self.depictionDelegate reuseIdentifierPrefix:@"footer"] copy];
	self.tabController.tabs = dummyTabs;
	tabCells = [ContentCellFactory createCellsFromTabArray:dummyTabs delegate:self.depictionDelegate];
#if !DEBUG
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
	return self;
}

- (void)loadDepiction {
	self.tabController.tabs = self.depictionDelegate.depiction[@"tabs"];
	tabCells = [ContentCellFactory createCellsFromTabArray:self.depictionDelegate.depiction[@"tabs"] delegate:self.depictionDelegate];
	NSLog(@"Tab Cells: %@", tabCells);
	[self reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.depictionDelegate scrollViewDidScroll:scrollView];
}

@end