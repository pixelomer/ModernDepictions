#import "SmartContentCell.h"

@class SubDepictionTableView;

@interface DepictionStackView : SmartContentCell {
	SubDepictionTableView *tableView;
	NSArray *cells;
}
@property (nonatomic, retain, setter=setViews:) NSArray *views;
- (void)setViews:(NSArray *)views;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end