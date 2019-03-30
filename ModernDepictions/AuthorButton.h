#import <UIKit/UIKit.h>

@class MIMEAddress;

@interface AuthorButton : UIButton {
	NSURL *mailURL;
}
- (instancetype)initWithMIMEAddress:(MIMEAddress *)address;
- (void)setMIMEAddress:(MIMEAddress *)address;
@end