#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "GetPackageCell.h"
#import "SmartCell.h"

@interface DepictionRootView : UITableView<UITableViewDataSource, UITableViewDelegate> {
	NSDictionary *depiction;
	NSMutableArray *modificationButtons;
	NSString *modificationButtonTitle;
	NSMutableArray<__kindof UITableViewCell<SmartCell> *> *topCells;
	NSMutableDictionary<NSString *, NSArray<__kindof UITableViewCell<SmartCell> *> *> *tabCells;
	NSString *currentTab;
}
@property (nonatomic, readonly) Package *package;
@property (nonatomic, readonly) Database *database;
@property (nonatomic, readonly) NSString *packageName;
@property (nonatomic, readonly) GetPackageCell *getPackageCell;
- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID;
- (void)reloadData;
@end