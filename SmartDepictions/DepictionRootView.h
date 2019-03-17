#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class DepictionTabView;
@class GetPackageCell;
@class SmartDepictionDelegate;

@interface DepictionRootView : UITableView<UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray<__kindof UITableViewCell<SmartCell> *> *topCells;
	NSMutableDictionary<NSString *, NSArray<__kindof UITableViewCell<SmartCell> *> *> *tabCells;
}
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate; 
@property (nonatomic, readonly) GetPackageCell *getPackageCell;
@property (nonatomic, readonly) DepictionTabView *tabController;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate;
- (void)loadDepiction;
@end