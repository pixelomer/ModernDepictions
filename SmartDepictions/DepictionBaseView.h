#import <UIKit/UIKit.h>
#import "SmartCell.h"

@class SmartDepictionDelegate;

@interface DepictionBaseView : UITableViewCell<SmartCell>
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
@property (nonatomic, retain, setter=setLabelText:, getter=labelText) NSString *labelText;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)init __attribute__((deprecated("Use initWithDepictionDelegate: instead.")));
- (void)setLabelText:(NSString *)text;
- (NSString *)labelText;
@end