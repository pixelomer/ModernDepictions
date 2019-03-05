#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class GetPackageCell;

@interface DepictionRootView : UITableView<UITableViewDataSource, UITableViewDelegate> {
	NSDictionary *depiction;
	NSString *modificationButtonTitle;
	NSMutableArray<__kindof UITableViewCell<SmartCell> *> *topCells;
	NSMutableDictionary<NSString *, NSArray<__kindof UITableViewCell<SmartCell> *> *> *tabCells;
	NSString *currentTab;
}
@property (nonatomic, readonly) Package *package;
@property (nonatomic, readonly) Database *database;
@property (nonatomic, readonly) NSString *packageName;
@property (nonatomic, readonly) NSMutableArray *modificationButtons;
@property (nonatomic, readonly) GetPackageCell *getPackageCell;
- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID;
- (void)reloadData;
@end