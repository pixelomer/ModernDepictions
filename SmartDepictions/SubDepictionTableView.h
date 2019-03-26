#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class SmartDepictionDelegate;

@interface SubDepictionTableView : UITableView<UITableViewDataSource, UITableViewDelegate> {
	@private
	NSArray *cells;
}
- (void)setViews:(NSArray *)views delegate:(SmartDepictionDelegate *)delegate;
- (instancetype)init;
@end