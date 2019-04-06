#import <UIKit/UIKit.h>

@class SubDepictionTableView;
@class ModernDepictionDelegate;

@interface SubDepictionViewController : UIViewController {
	UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, readonly) ModernDepictionDelegate *depictionDelegate;
@property (nonatomic, strong, setter=setDepiction:) NSArray *depiction;
@property (nonatomic, readonly) SubDepictionTableView *tableView;
- (void)setDepiction:(NSArray *)depiction;
- (void)setDepictionURL:(NSURL *)depictionURL;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate;
@end