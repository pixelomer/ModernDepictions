#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class SmartDepictionDelegate;
@class DepictionTab;

@interface DepictionTabView : UITableViewCell<SmartCell> {
	NSMutableArray<NSString *> *currentTabNames;
	NSMutableArray<DepictionTab *> *currentTabs;
}
@property (nonatomic, setter=setTabs:, assign) NSArray<NSDictionary *> * _Nonnull tabs;
- (CGFloat)height;
- (instancetype _Nullable)initWithReuseIdentifier:(NSString * _Nonnull)reuseIdentifier;
- (void)setTabs:(NSArray<NSDictionary *> * _Nonnull)tabs;
@end