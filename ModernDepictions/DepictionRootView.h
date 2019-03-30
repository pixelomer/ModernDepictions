#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "ModernCell.h"
#import "DepictionTabView.h"
#import "SubDepictionTableView.h"

@class DepictionTabView;
@class GetPackageCell;
@class DepictionBaseView;
@class ModernDepictionDelegate;

@interface DepictionRootView : SubDepictionTableView<UITableViewDataSource, UITableViewDelegate, DepictionTabViewDelegate> {
	NSMutableArray<__kindof UITableViewCell<ModernCell> *> *topCells;
	NSDictionary<NSString *, NSArray<__kindof DepictionBaseView *> *> *tabCells;
	NSMutableArray<__kindof UITableViewCell<ModernCell> *> *footerCells;
}
@property (nonatomic, readonly) ModernDepictionDelegate *depictionDelegate; 
@property (nonatomic, readonly) GetPackageCell *getPackageCell;
@property (nonatomic, readonly) DepictionTabView *tabController;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate;
- (instancetype)init;
- (void)loadDepiction;
- (void)didSelectTabNamed:(NSString *)name;
@end