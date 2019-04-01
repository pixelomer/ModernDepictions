#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"

@class DepictionRootView;
@class ModernDepictionDelegate;
@class Cydia;

@interface ModernPackageController : UIViewController {
	UIImageView *imageView;
	double origImageHeight;
	double origImageWidth;
	CGFloat navBarLowerY;
}
@property (nonatomic, readonly) DepictionRootView *depictionRootView;
@property (nonatomic, readonly) ModernDepictionDelegate *depictionDelegate;
@property (nonatomic, readonly) ModernPackageController *packageController;
- (instancetype)initWithDepictionURL:(NSURL *)depictionURL database:(id)database packageID:(NSString *)packageID;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadDepiction;
- (void)setReferrer:(NSString *)referrer;
- (void)setOriginalInvocation:(NSInvocation *)originalInvocation;
@end