#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"
#import "SmartCell.h"

/**************** GetPackageCell ****************/
/* This cell displays the package's name, icon, */
/* author and the "Get" button. Unlike other    */
/* cells, this cell is not created according to */
/* the depiction JSON.                          */
/************************************************/

@interface GetPackageCell : UITableViewCell<SmartCell> {
	UIImageView *iconView;
	UILabel *packageNameLabel;
	UILabel *authorLabel;
	UIButton *queueButton;
}
- (instancetype _Nullable)initWithPackage:(Package * _Nonnull)package reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;
- (void)setButtonTitle:(NSString * _Nullable)text;
- (NSString * _Nullable)buttonTitle;
// - (void)setIcon:(UIImage *)icon;
// - (UIImage *)icon;
@end