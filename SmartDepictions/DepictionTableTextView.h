#import <UIKit/UIKit.h>
#import "SmartContentCell.h"

@interface DepictionTableTextView : SmartContentCell {
	UILabel *textLabel;
	UILabel *titleLabel;
}
@property (nonatomic, retain, setter=setTitle:, getter=title) NSString *title;
@property (nonatomic, retain, setter=setText:, getter=text) NSString *text;
- (NSString *)text;
- (void)setText:(NSString *)text;
- (CGFloat)height;
- (void)setTitle:(NSString *)title;
- (NSString *)title;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end