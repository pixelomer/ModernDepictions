#import <UIKit/UIKit.h>

@interface FeaturedBannersView : UITableViewCell {
	UIScrollView *bannerScrollView;
	UIView *bannerContainerView;
	NSArray *banners;
	CGFloat height;
}
- (CGFloat)height;
- (instancetype)initWithPackages:(NSArray *)packages bannerLimit:(NSUInteger)bannerLimit;
- (instancetype)initWithPackages:(NSArray *)packages bannerLimit:(NSUInteger)bannerLimit bannerSize:(CGSize *)bannerSizePt;
@end