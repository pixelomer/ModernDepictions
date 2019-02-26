#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"

@interface SmartPackageController : UIViewController {
	UIImageView *imageView;
	UIColor *oldTintColor;
	double origImageHeight;
	double origImageWidth;
	bool IsWildcat_;
}
@property (nonatomic, readonly) NSDictionary *depiction;
@property (nonatomic, readonly) CYPackageController *dummyController;
@property (nonatomic, readonly) UITableView *tableView;
- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID referrer:(NSString *)referrer;
@end