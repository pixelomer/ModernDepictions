#import "DepictionAdmobView.h"
#import "SmartDepictionDelegate.h"
#import "AdmobTests.h"

@implementation DepictionAdmobView

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	banner = [[GADBannerView alloc] init];
	banner.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:banner];
	[self.contentView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:banner
			attribute:NSLayoutAttributeCenterX
			relatedBy:NSLayoutRelationEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeCenterX
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:banner
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationGreaterThanOrEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:0.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:self.contentView
			attribute:NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationEqual
			toItem:banner
			attribute:NSLayoutAttributeHeight
			multiplier:1.0
			constant:0.0
		]
	]];
	banner.rootViewController = (UIViewController *)delegate.packageController;
	banner.delegate = self;
	self.adSize = @"Banner";
	return self;
}

- (void)layoutSubviews {
	if (request) {
		[banner loadRequest:request];
		adLoaded = true;
	}
	[super layoutSubviews];
}

- (CGFloat)height {
	return height;
}

- (void)setAdSize:(NSString *)adSize {
	GADAdSize newSize;
	if ([adSize isEqualToString:@"SmartBanner"]) newSize = kGADAdSizeSmartBannerPortrait;
	else if ([adSize isEqualToString:@"LargeBanner"]) newSize = kGADAdSizeLargeBanner;
	else newSize = kGADAdSizeMediumRectangle;
	height = newSize.size.height;
	banner.adSize = newSize;
	NSLog(@"New height: %f, expected height: %f", height, newSize.size.height);
	_adSize = adSize;
}

- (void)setAdUnitID:(NSString *)adUnitID {
	banner.adUnitID = adUnitID;
	_adUnitID = adUnitID;
	request = [GADRequest request];
#if DEBUG
	// This is a macro defined in a private file. It is safe to remove this line or add your own device.
	request.testDevices = AdModTestDevices;
#endif
}

@end