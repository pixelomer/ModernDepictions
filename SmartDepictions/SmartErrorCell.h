#import <UIKit/UIKit.h>
#import "SmartContentCell.h"

// WARNING: Normal content cells must NOT create a custom init method.
@interface SmartErrorCell : SmartContentCell
- (instancetype)initWithErrorMessage:(NSString *)errorMessage;
@end