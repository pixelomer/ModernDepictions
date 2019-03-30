#import "DepictionBaseView.h"
@import GoogleMobileAds;

@class GADBannerView;

@interface DepictionAdmobView : DepictionBaseView<GADBannerViewDelegate> {
	GADBannerView *banner;
	CGFloat height;
	GADRequest *request;
	bool adLoaded;
}
@property (nonatomic, retain, setter=setAdSize:) NSString *adSize;
@property (nonatomic, retain, setter=setAdUnitID:) NSString *adUnitID;
- (void)setAdUnitID:(NSString *)adUnitID;
- (void)setAdSize:(NSString *)adSize;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end