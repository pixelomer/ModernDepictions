#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class GetPackageCell;
@class SmartDepictionDelegate;

@interface DepictionRootView : UITableView<UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray<__kindof UITableViewCell<SmartCell> *> *topCells;
	NSMutableDictionary<NSString *, NSArray<__kindof UITableViewCell<SmartCell> *> *> *tabCells;
	NSString *currentTab;
}
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate; 
@property (nonatomic, readonly) GetPackageCell *getPackageCell;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate;
@end