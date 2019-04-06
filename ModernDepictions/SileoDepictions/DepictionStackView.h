#import "DepictionBaseView.h"

@class SubDepictionTableView;

@interface DepictionStackView : DepictionBaseView {
	SubDepictionTableView *tableView;
	NSArray *cells;
}
@property (nonatomic, strong, setter=setViews:) NSArray *views;
- (void)setViews:(NSArray *)views;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end