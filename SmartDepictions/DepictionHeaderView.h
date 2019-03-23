#import "SmartContentCell.h"

@interface DepictionHeaderView : SmartContentCell {
	@private
	UILabel *headerLabel;
	
	@protected
	CGFloat fontSize;
}
@property (nonatomic, retain, setter=setTitle:) NSString *title;
@property (nonatomic, assign, setter=setUseBoldText:) bool useBoldText;
- (void)setTitle:(NSString *)title;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setUseBoldText:(bool)useBoldText;
@end