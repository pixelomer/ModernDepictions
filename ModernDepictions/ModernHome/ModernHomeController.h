#import <UIKit/UIKit.h>
#import <Headers/Headers.h>

@class Cydia;

@interface ModernHomeController : UITableViewController
@property (nonatomic, assign) Cydia *delegate;
- (instancetype)init;
@end