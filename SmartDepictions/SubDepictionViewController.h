#import <UIKit/UIKit.h>

@class SubDepictionTableView;
@class SmartDepictionDelegate;

@interface SubDepictionViewController : UIViewController {
	UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
@property (nonatomic, retain, setter=setDepiction:) NSArray *depiction;
@property (nonatomic, readonly) SubDepictionTableView *tableView;
- (void)setDepiction:(NSArray *)depiction;
- (void)setDepictionURL:(NSURL *)depictionURL;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate;
@end