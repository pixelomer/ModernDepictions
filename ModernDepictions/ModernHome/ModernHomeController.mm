#import "ModernHomeController.h"
#import <ModernDepictions/Shared/ModernPackageCell.h>

@implementation ModernHomeController

- (instancetype)init {
	self = [self initWithStyle:UITableViewStylePlain];
	self.title = @"Cydia";
	return self;
}

- (Cydia *)delegate {
	return _cydiaDelegate;
}

- (void)setDelegate:(Cydia *)newDelegate {
	_cydiaDelegate = newDelegate;
}

// TESTING
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Package"];
	if (!cell) cell = [[ModernPackageCell alloc] initWithIconSize:65.0 reuseIdentifier:@"Package"];
	if (![cell isKindOfClass:[ModernPackageCell class]]) cell.selectionStyle = UITableViewCellSelectionStyleNone;
	else {
		
	}
	return cell;
}

// TESTING
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

@end