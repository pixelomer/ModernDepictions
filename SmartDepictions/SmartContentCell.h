#import <UIKit/UIKit.h>
#import "SmartCell.h"

@class SmartDepictionDelegate;

@interface SmartContentCell : UITableViewCell<SmartCell>
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)init __attribute__((deprecated("Use initWithDepictionDelegate: instead.")));
@end