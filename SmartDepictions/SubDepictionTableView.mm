#import "SubDepictionTableView.h"
#import "ContentCellFactory.h"

@implementation SubDepictionTableView

- (instancetype)init {
	self = [super init];
	self.dataSource = self;
	self.delegate = self;
#if !DEBUG
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
	return self;
}

- (NSInteger)numberOfCells {
	return cells.count;
}

- (id)cellForRow:(NSInteger)row {
	return (row < cells.count) ? cells[row] : nil;
}

- (void)setViews:(NSArray *)views delegate:(SmartDepictionDelegate *)delegate {
	cells = [ContentCellFactory createCellsFromArray:views delegate:delegate reuseIdentifierPrefix:@"stackitem"];
	[self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell<SmartCell> *cell = [self cellForRow:indexPath.row];
	if ([cell respondsToSelector:@selector(didGetSelected)]) {
		[tableView deselectRowAtIndexPath:indexPath animated:NO]; // Sileo doesn't have actual cells but its behaviour is like this
		[cell didGetSelected];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.numberOfCells;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell<SmartCell> * _Nullable cell = [self cellForRow:indexPath.row];
	return cell ? [cell height] : 44.0;
}

@end