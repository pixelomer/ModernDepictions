#import <UIKit/UIKit.h>
#import <Headers/Headers.h>

@class Cydia;

@interface ModernHomeController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
	Cydia *_cydiaDelegate;
}
@property (nonatomic, assign, setter=setDelegate:, getter=delegate) Cydia *cydiaDelegate;
- (Cydia *)delegate;
- (void)setDelegate:(Cydia *)newDelegate;
- (instancetype)init;
@end