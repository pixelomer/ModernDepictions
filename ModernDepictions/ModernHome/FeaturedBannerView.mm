#import "FeaturedBannerView.h"
#import <Headers/Headers.h>
#import <Tweak/Tweak.h>
#import <Extensions/UIImage+ImageWithColor.h>

@implementation FeaturedBannerView

+ (instancetype)bannerWithPackageInfo:(NSDictionary *)info {
	return [[self buttonWithType:UIButtonTypeCustom] initWithPackageInfo:info];
}

- (instancetype)initWithPackageInfo:(NSDictionary *)info {
	self.translatesAutoresizingMaskIntoConstraints = NO;
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = 10.0;
	[self addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:info[@"image"]];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:imageView];
	if (![(NSNumber *)info[@"hideShadow"] boolValue]) {
		shadowView = [[UIImageView alloc] initWithImage:GetShadowImage()];
		shadowView.translatesAutoresizingMaskIntoConstraints = NO;
		shadowView.contentMode = UIViewContentModeScaleToFill;
		shadowView.transform = CGAffineTransformMakeRotation(M_PI);
		[imageView addSubview:shadowView];
	}
	NSArray *views = @[ (shadowView ?: NSNull.null), imageView ];
	for (UIView *view in views) {
		if ([view isKindOfClass:[NSNull null]]) continue;
		[view.superview addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[v]|"
			options:0
			metrics:nil
			views:@{ @"v" : view }
		]];
		[view.superview addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[v]|"
			options:0
			metrics:nil
			views:@{ @"v" : view }
		]];
	}
	return self;
}

- (Package *)getPackage {
	return [[objc_getClass("Database") sharedInstance] packageWithName:self.packageInfo[@"package"]];
}

- (void)handleTap:(id)sender {
	
}

@end