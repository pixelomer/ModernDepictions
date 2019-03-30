#import <UIKit/UIKit.h>
#import "DepictionBaseView.h"

// WARNING: Normal content cells must NOT create a custom init method.
@interface ModernErrorCell : DepictionBaseView
- (instancetype)initWithErrorMessage:(NSString *)errorMessage;
@end