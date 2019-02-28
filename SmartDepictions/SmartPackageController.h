#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"

@interface SmartPackageController : UIViewController {
	NSDictionary *depiction;
	UIImageView *imageView;
	double origImageHeight;
	bool isiPad;
	double origImageWidth;
	NSMutableArray *modificationButtons;
	NSString *modificationButtonTitle;
}
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) Package *package;
@property (nonatomic, readonly) Database *database;
@property (nonatomic, readonly) NSString *packageName;
@property (nonatomic, retain) id delegate;
- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID referrer:(NSString *)referrer;
- (void)reloadData;

@end