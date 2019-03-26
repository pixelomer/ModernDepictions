#import "DepictionRootView.h"
#import "GetPackageCell.h"
#import "SmartDepictionDelegate.h"
#import "DepictionTabView.h"
#import "ContentCellFactory.h"
#import "DepictionImageView.h"
#import "../Extensions/UINavigationController+Opacity.h"
#import "../Extensions/UIColor+HexString.h"

@implementation DepictionRootView

- (NSInteger)numberOfCells {
	return topCells.count + tabCells[self.tabController.currentTab].count + footerCells.count;
}

- (id)cellForRow:(NSInteger)row {
	if (row < topCells.count)
		return topCells[row];
	else if (row < tabCells[self.tabController.currentTab].count + topCells.count)
		return tabCells[self.tabController.currentTab][row - topCells.count];
	else if (row < tabCells[self.tabController.currentTab].count + topCells.count + footerCells.count)
		return footerCells[row - topCells.count - tabCells[self.tabController.currentTab].count];
	return nil;
}

- (instancetype)init {
	@throw [NSException exceptionWithName:NSGenericException reason:@"You have to use -[initWithDepictionDelegate:] for this class." userInfo:nil];
	return nil;
}

- (void)setViews:(NSArray *)views delegate:(SmartDepictionDelegate *)delegate {
	// This method does nothing.
}

- (void)didSelectTabNamed:(NSString *)name {
	[self reloadData];
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate {
	self = PerformSelector(UITableView, self, @selector(init));
	topCells = [[NSMutableArray alloc] init];
	footerCells = [[NSMutableArray alloc] init];
	_depictionDelegate = delegate;
	self.dataSource = self;
	self.delegate = self;
	_getPackageCell = [[GetPackageCell alloc] initWithDepictionDelegate:self.depictionDelegate reuseIdentifier:@"getpackagecell"];
	[topCells addObject:self.getPackageCell];
	_tabController = [[DepictionTabView alloc] initWithDepictionDelegate:delegate reuseIdentifier:@"tabControl"];
	_tabController.tabViewDelegate = self;
	[topCells addObject:_tabController];
	NSArray *dummyTabs = @[
		@{
			@"tabname" : @"Details",
			@"views" : @[
				@{
					@"class" : @"DepictionBaseView",
					@"labelText" : self.depictionDelegate.package.longDescription ?: self.depictionDelegate.package.shortDescription ?: @"",
					@"numberOfLines" : @(0)
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
		 @"markdown" : [NSString stringWithFormat:@"<br/><small style=\"color: #aaa;\">%@ (%@)</small><style>body { text-align: center; }</style><br/>", self.depictionDelegate.package.id, versionString],
		 @"useRawFormat" : @YES,
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
	if (self.depictionDelegate.tintColor) {
		for (int i = 0; i < self.numberOfCells; i++) {
			UITableViewCell<SmartCell> *cell = [self cellForRow:i];
			if ([cell respondsToSelector:@selector(setDepictionTintColor:)]) {
				[cell setDepictionTintColor:self.depictionDelegate.tintColor];
			}
		}
	}
	[self reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.depictionDelegate scrollViewDidScroll:scrollView];
}

@end