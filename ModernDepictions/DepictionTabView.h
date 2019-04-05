#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "ModernCell.h"
#import "DepictionBaseView.h"

@class ModernDepictionDelegate;
@class DepictionTab;

@protocol DepictionTabViewDelegate
@required
- (void)didSelectTabNamed:(NSString *)name;
@end

@interface DepictionTabView : DepictionBaseView {
	NSMutableArray<NSString *> *currentTabNames;
	NSMutableArray<DepictionTab *> *currentTabs;
	NSUInteger selectedIndex;
	NSString *currentTab;
	UIView *underline;
	NSArray<NSLayoutConstraint *> *lineConstraints;
}
@property (nonatomic, setter=setTabs:, assign) NSArray<NSDictionary *> * tabs;
@property (nonatomic, readonly, getter=currentTab) NSString *currentTab;
@property (nonatomic, strong) __kindof NSObject<DepictionTabViewDelegate> *tabViewDelegate;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTabs:(NSArray<NSDictionary *> *)tabs;
@end