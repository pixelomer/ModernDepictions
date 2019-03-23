#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"

@class DepictionRootView;
@class SmartDepictionDelegate;
@class Cydia;

@interface SmartPackageController : UIViewController {
	UIImageView *imageView;
	double origImageHeight;
	double origImageWidth;
	CGFloat navBarLowerY;
}
@property (nonatomic, readonly) DepictionRootView *depictionRootView;
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
@property (nonatomic, readonly) SmartPackageController *packageController;
- (instancetype)initWithDepictionURL:(NSURL *)depictionURL database:(id)database packageID:(NSString *)packageID;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadDepiction;
@end