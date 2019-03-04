#import <UIKit/UIKit.h>
#import "../Headers/Headers.h"

/**************** GetPackageCell ****************/
/* This cell displays the package's name, icon, */
/* author and the "Get" button. Unlike other    */
/* cells, this cell is not created according to */
/* the depiction JSON.                          */
/************************************************/

@interface GetPackageCell : UITableViewCell {
	UIImageView *iconView;
}
// @property (nonatomic, setter=setIcon, getter=icon) UIImage *icon;
- (instancetype _Nullable)initWithPackage:(Package * _Nonnull)package reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;
// - (void)setIcon:(UIImage *)icon;
// - (UIImage *)icon;
@end