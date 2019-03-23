#import "DepictionAdmobView.h"
#import "SmartDepictionDelegate.h"
@import GoogleMobileAds;

@implementation DepictionAdmobView

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	banner = [[GADBannerView alloc] init];
	banner.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:banner];
	NSDictionary *views = @{ @"banner" : banner };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[banner]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[banner]|"
		options:0
		metrics:nil
		views:views
	]];
	banner.rootViewController = (UIViewController *)delegate.packageController;
	return self;
}

- (CGFloat)height {
	return 80.0;
}

- (void)setAdSize:(NSString *)adSize {
	if ([adSize isEqualToString:@"SmartBanner"]) banner.adSize = kGADAdSizeSmartBannerPortrait;
	else if ([adSize isEqualToString:@"LargeBanner"]) banner.adSize = kGADAdSizeLargeBanner;
	else banner.adSize = kGADAdSizeBanner;
	_adSize = adSize;
}

- (void)setAdUnitID:(NSString *)adUnitID {
	banner.adUnitID = adUnitID;
	_adUnitID = adUnitID;
	[banner loadRequest:[GADRequest request]];
}

@end