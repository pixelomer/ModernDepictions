#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"
#import "DepictionTabView.h"

@class DepictionTabView;
@class GetPackageCell;
@class DepictionBaseView;
@class SmartDepictionDelegate;

@interface DepictionRootView : UITableView<UITableViewDataSource, UITableViewDelegate, DepictionTabViewDelegate> {
	NSMutableArray<__kindof UITableViewCell<SmartCell> *> *topCells;
	NSDictionary<NSString *, NSArray<__kindof DepictionBaseView *> *> *tabCells;
	NSMutableArray<__kindof UITableViewCell<SmartCell> *> *footerCells;
}
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate; 
@property (nonatomic, readonly) GetPackageCell *getPackageCell;
@property (nonatomic, readonly) DepictionTabView *tabController;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate;
- (void)loadDepiction;
- (void)didSelectTabNamed:(NSString *)name;
@end