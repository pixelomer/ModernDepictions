#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"
#import "SmartContentCell.h"

@class SmartDepictionDelegate;
@class DepictionTab;

@protocol DepictionTabViewDelegate
@required
- (void)didSelectTabNamed:(NSString *)name;
@end

@interface DepictionTabView : SmartContentCell {
	NSMutableArray<NSString *> *currentTabNames;
	NSMutableArray<DepictionTab *> *currentTabs;
	NSUInteger selectedIndex;
	NSString *currentTab;
	UIView *underline;
	NSArray<NSLayoutConstraint *> *lineConstraints;
}
@property (nonatomic, setter=setTabs:, assign) NSArray<NSDictionary *> * tabs;
@property (nonatomic, readonly, getter=currentTab) NSString *currentTab;
@property (nonatomic, retain) __kindof NSObject<DepictionTabViewDelegate> *tabViewDelegate;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTabs:(NSArray<NSDictionary *> *)tabs;
@end