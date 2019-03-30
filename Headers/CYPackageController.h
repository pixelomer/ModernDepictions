#import <UIKit/UIKit.h>

@class Cydia;

@interface CYPackageController : UIViewController
@property (nonatomic, assign) Cydia *delegate;
- (instancetype)initWithDatabase:(id)database forPackage:(NSString *)packageID withReferrer:(NSString *)referrer;
- (void)reloadData;
- (UIBarButtonItem *)rightButton;
- (id)SDDelegateOverride;
- (void)setSDDelegateOverride:(id)object;
- (bool)isLoading;
- (void)reloadURLWithCache:(BOOL)cache;
@end