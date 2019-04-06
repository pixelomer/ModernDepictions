#import <UIKit/UIKit.h>

@interface ModernPackageCell : UITableViewCell {
	UIImageView *iconView;
	UIView *textContainerView;
	UILabel *packageNameLabel;
	UILabel *authorLabel;
	UILabel *footerLabel;
}
- (void)setFooterText:(NSString *)newText;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithIconSize:(CGFloat)iconSize reuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)init;
@end