#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "ModernCell.h"

@class ModernDepictionDelegate;

@interface SubDepictionTableView : UITableView<UITableViewDataSource, UITableViewDelegate> {
	@private
	NSArray *cells;
}
- (void)setViews:(NSArray *)views delegate:(ModernDepictionDelegate *)delegate;
- (instancetype)init;
@end