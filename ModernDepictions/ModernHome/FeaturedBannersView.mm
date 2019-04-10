#import "FeaturedBannersView.h"
#import "FeaturedBannerView.h"
#import "ModernHomeController.h"
#import <Tweak/Tweak.h>

@implementation FeaturedBannersView

static CGSize defaultSize;

+ (void)initialize {
	if ([self class] == [FeaturedBannersView class]) {
		defaultSize = CGSizeMake(263.0, 148.0);
	}
}

- (instancetype)initWithPackages:(NSArray *)packages bannerLimit:(NSUInteger)bannerLimit {
	return [self initWithPackages:packages bannerLimit:bannerLimit bannerSize:nil];
}

- (instancetype)initWithPackages:(NSArray *)packages bannerLimit:(NSUInteger)bannerLimit bannerSize:(CGSize *)bannerSizePt {
	CGSize bannerSize = bannerSizePt ? *bannerSizePt : defaultSize;
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
	NSLog(@"Packages: %@", packages);
	for (NSUInteger i = 0; i < min(packages.count, bannerLimit); i++) {
		NSDictionary *packageInfo = packages[i];
		FeaturedBannerView *banner = [FeaturedBannerView bannerWithPackageInfo:packageInfo];
		if (!banner) continue;
		[banner addTarget:self action:@selector(handleBannerTap:) forControlEvents:UIControlEventTouchUpInside];
		[bannerContainerView addSubview:banner];
		NSDictionary *views = @{ @"prev" : (previousView ?: [NSNull null]), @"banner" : banner };
		[bannerContainerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-16-[banner(==%f)]-16-|", bannerSize.height]
			options:0
			metrics:nil
			views:views
		]];
		[bannerContainerView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:[NSString stringWithFormat:@"H:%@-%d-[banner(==%f)]",
				(previousView ? @"[prev]" : @"|"),
				(16 / (!!previousView + 1)),
				bannerSize.width
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
	else return nil;
	height = bannerSize.height + 32.1;
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	bannerScrollView.contentSize = CGSizeMake(bannerContainerView.frame.size.width, 0);
}

- (CGFloat)height {
	return height;
}

- (void)dealloc {
	NSLog(@"A %@ is being deallocated...", NSStringFromClass(self.class));
}

- (void)handleBannerTap:(FeaturedBannerView *)banner {
	[(ModernHomeController *)self._viewControllerForAncestor
		didSelectPackage:banner.packageInfo[@"package"]
	];
}

@end