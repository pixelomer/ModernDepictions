#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

@class SmartDepictionDelegate;
@class DepictionTab;

@protocol DepictionTabViewDelegate
@required
- (void)didSelectTabNamed:(NSString *)name;
@end

@interface DepictionTabView : UITableViewCell<SmartCell> {
	NSMutableArray<NSString *> *currentTabNames;
	NSMutableArray<DepictionTab *> *currentTabs;
	NSString *currentTab;
	UIView *underline;
	NSArray<NSLayoutConstraint *> *lineConstraints;
}
@property (nonatomic, retain) UIColor *depictionTintColor;
@property (nonatomic, setter=setTabs:, assign) NSArray<NSDictionary *> * tabs;
@property (nonatomic, readonly, getter=currentTab) NSString *currentTab;
@property (nonatomic, readonly) __kindof NSObject<DepictionTabViewDelegate> *tabViewDelegate;
- (CGFloat)height;
- (instancetype)initWithDelegate:(__kindof NSObject<DepictionTabViewDelegate> *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTabs:(NSArray<NSDictionary *> *)tabs;
@end