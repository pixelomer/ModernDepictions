#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "ModernCell.h"

/**************** GetPackageCell ****************/
/* This cell displays the package's name, icon, */
/* author and the "Get" button. Unlike other    */
/* cells, this cell is not created according to */
/* the depiction JSON.                          */
/************************************************/

@class ModernDepictionDelegate;
@class QueueButton;
@class AuthorButton;

@interface GetPackageCell : UITableViewCell<ModernCell> {
	UIImageView *iconView;
	UILabel *packageNameLabel;
	UIView *textContainerView;
	AuthorButton *authorButton;
	QueueButton *queueButton;
	NSArray *textContainerConstraints;
	bool textLocked;
}
@property (nonatomic, readonly) ModernDepictionDelegate *depictionDelegate;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setButtonTitle:(NSString *)text;
- (void)lockText;
- (NSString *)buttonTitle;
- (void)setPackage:(Package *)package;
// - (void)setIcon:(UIImage *)icon;
// - (UIImage *)icon;
@end