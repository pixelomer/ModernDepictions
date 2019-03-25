#import "SubDepictionTableView.h"
#import "ContentCellFactory.h"

@implementation SubDepictionTableView

- (instancetype)init {
	self = [super init];
	self.dataSource = self;
	self.delegate = self;
	return self;
}

- (void)setViews:(NSArray *)views delegate:(SmartDepictionDelegate *)delegate {
	cells = [ContentCellFactory createCellsFromArray:views delegate:delegate reuseIdentifierPrefix:@"stackitem"];
	[self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return cells.count > indexPath.row ? cells[indexPath.row] : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell<SmartCell> *cell = cells[indexPath.row];
	if ([cell respondsToSelector:@selector(didGetSelected)]) {
		[cell didGetSelected];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell<SmartCell> * _Nullable cell = cells.count > indexPath.row ? cells[indexPath.row] : nil;
	return cell ? [cell height] : 44.0;
}

@end