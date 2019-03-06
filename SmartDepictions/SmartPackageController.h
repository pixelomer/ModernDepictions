#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"

@class DepictionRootView;
@class SmartDepictionDelegate;
@class Cydia;

@interface SmartPackageController : UIViewController {
	UIImageView *imageView;
	double origImageHeight;
	bool isiPad;
	double origImageWidth;
	CGFloat navBarLowerY;
}
@property (nonatomic, readonly) DepictionRootView *depictionRootView;
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
- (instancetype)initWithDepiction:(NSDictionary *)dict database:(id)database packageID:(NSString *)packageID;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end