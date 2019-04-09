#import "FeaturedBannersView.h"
#import "FeaturedBannerView.h"
#import "ModernHomeController.h"
#import <Tweak/Tweak.h>

@implementation FeaturedBannersView

- (instancetype)initWithPackages:(NSArray *)packages bannerLimit:(NSUInteger)bannerLimit {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	bannerScrollView = [UIScrollView new];
	bannerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
	bannerScrollView.showsHorizontalScrollIndicator = NO;
	bannerContainerView = [UIView new];
	bannerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	[bannerScrollView addSubview:bannerContainerView];
	[self.contentView addSubview:bannerScrollView];
	for (UIView *view in @[bannerContainerView, bannerScrollView]) {
		NSDictionary *views = @{ @"view" : view };
		[view.superview addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[view]|"
			options:0
			metrics:nil
			views:views
		]];
		[view.superview addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[view]|"
			options:0
			metrics:nil
			views:views
		]];
	}
	__kindof UIView *previousView;
	// V:|-16-[image(==148)]-16-|
	// H:[previous]-16-[image(==263)]
	// Radius: 10
	for (NSUInteger i = 0; i < bannerLimit; i++) {
		NSDictionary *packageInfo = packages[i];
		FeaturedBannerView *banner = [FeaturedBannerView bannerWithPackageInfo:packageInfo];
		[banner addTarget:self action:@selector(handleBannerTap:) forControlEvents:UIControlEventTouchUpInside];
		[bannerContainerView addSubview:banner];
		NSDictionary *views = @{ @"prev" : (previousView ?: [NSNull null]), @"banner" : banner };
		[bannerContainerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|-16-[banner(==148)]-16-|"
			options:0
			metrics:nil
			views:views
		]];
		[bannerContainerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:[NSString stringWithFormat:@"H:%@-%d-[banner(==263)]",
				(previousView ? @"[prev]" : @"|"),
				(16 / (!!previousView + 1))
			]
			options:0
			metrics:nil
			views:views
		]];
		previousView = banner;
	}
	if (previousView) {
		[bannerScrollView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:[prev]-16-|"
			options:0
			metrics:nil
			views:@{ @"prev" : previousView }
		]];
	}
	height = 148.0 + 32.1;
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	bannerScrollView.contentSize = CGSizeMake(bannerContainerView.frame.size.width, 0);
}

- (CGFloat)height {
	return height;
}

- (void)handleBannerTap:(FeaturedBannerView *)banner {
	[(ModernHomeController *)self._viewControllerForAncestor
		didSelectPackage:banner.packageInfo[@"package"]
	];
}

@end