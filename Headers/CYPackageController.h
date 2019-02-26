#import <UIKit/UIKit.h>

@interface CYPackageController : NSObject
- (instancetype)initWithDatabase:(id)database forPackage:(NSString *)packageID withReferrer:(NSString *)referrer;
- (void)reloadData;
- (UIBarButtonItem *)rightButton;
- (id)SDDelegateOverride;
- (void)setSDDelegateOverride:(id)object;
- (bool)isLoading;
- (void)reloadURLWithCache:(BOOL)cache;
@end