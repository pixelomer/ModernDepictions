#import <UIKit/UIKit.h>

@class Package;

@interface FeaturedBannerView : UIButton {
	UIImageView *shadowView;
}
@property (nonatomic, readonly) NSDictionary *packageInfo;
@property (nonatomic, readonly, getter=getPackage) Package *package;
+ (instancetype)bannerWithPackageInfo:(NSDictionary *)info;
- (Package *)getPackage;
@end