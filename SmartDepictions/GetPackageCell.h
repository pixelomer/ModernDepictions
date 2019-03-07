#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

/**************** GetPackageCell ****************/
/* This cell displays the package's name, icon, */
/* author and the "Get" button. Unlike other    */
/* cells, this cell is not created according to */
/* the depiction JSON.                          */
/************************************************/

@class SmartDepictionDelegate;
@class QueueButton;
@class AuthorButton;

@interface GetPackageCell : UITableViewCell<SmartCell> {
	UIImageView *iconView;
	UILabel *packageNameLabel;
	AuthorButton *authorButton;
	QueueButton *queueButton;
}
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setButtonTitle:(NSString *)text;
- (NSString *)buttonTitle;
- (void)setPackage:(Package *)package;
// - (void)setIcon:(UIImage *)icon;
// - (UIImage *)icon;
@end