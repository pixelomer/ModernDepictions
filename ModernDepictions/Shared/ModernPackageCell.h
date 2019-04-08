#import <UIKit/UIKit.h>
#import <Headers/Headers.h>

@interface ModernPackageCell : UITableViewCell {
	UIImageView *iconView;
	UIView *textContainerView;
	UILabel *packageNameLabel;
	UILabel *authorLabel;
	UILabel *footerLabel;
	UIImageView *placard;
	NSLayoutConstraint *packageNameLabelTrailingConstraint;
}
@property (nonatomic, weak, setter=setPackage:) Package *package;
- (void)setPackage:(Package *)package;
- (void)setFooterText:(NSString *)newText;
- (void)setIcon:(UIImage *)newIcon;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithIconSize:(CGFloat)iconSize reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithIconSize:(CGFloat)iconSize centerText:(BOOL)shouldCenterText reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)init;
@end