#import <UIKit/UIKit.h>
#import "DepictionBaseView.h"

@interface DepictionTableTextView : DepictionBaseView {
	UILabel *textLabel;
	UILabel *titleLabel;
}
@property (nonatomic, strong, setter=setTitle:, getter=title) NSString *title;
@property (nonatomic, strong, setter=setText:, getter=text) NSString *text;
- (NSString *)text;
- (void)setText:(NSString *)text;
- (CGFloat)height;
- (void)setTitle:(NSString *)title;
- (NSString *)title;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end