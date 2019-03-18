#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class SmartDepictionDelegate;
@class DepictionTab;

@protocol DepictionTabViewDelegate
@required
- (void)didSelectTabNamed:(NSString * _Nonnull)name;
@end

@interface DepictionTabView : UITableViewCell<SmartCell> {
	NSMutableArray<NSString *> *currentTabNames;
	NSMutableArray<DepictionTab *> *currentTabs;
	NSString *currentTab;
}
@property (nonatomic, setter=setTabs:, assign) NSArray<NSDictionary *> * _Nonnull tabs;
@property (nonatomic, readonly, getter=currentTab) NSString * _Nullable currentTab;
- (CGFloat)height;
- (instancetype _Nullable)initWithDelegate:(id<DepictionTabViewDelegate> _Nullable)delegate reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;
- (void)setTabs:(NSArray<NSDictionary *> * _Nonnull)tabs;
@end