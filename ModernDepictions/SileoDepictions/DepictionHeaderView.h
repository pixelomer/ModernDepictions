#import "DepictionBaseView.h"

@interface DepictionHeaderView : DepictionBaseView {
	@private
	UILabel *headerLabel;
	
	@protected
	CGFloat fontSize;
	NSNumber *_useBoldText;
}
@property (nonatomic, strong, setter=setTitle:) NSString *title;
@property (nonatomic, assign, setter=setUseBoldText:, getter=useBoldText) NSNumber *useBoldText;
- (void)setTitle:(NSString *)title;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setUseBoldText:(NSNumber *)useBoldText;
- (NSNumber *)useBoldText;
@end