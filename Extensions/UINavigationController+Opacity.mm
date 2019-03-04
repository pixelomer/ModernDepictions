#import "UINavigationController+Opacity.h"
#import "UIImage+ImageWithColor.h"

@implementation UINavigationController(Clear)

- (void)setClear:(BOOL)clear {
	[self setOpacity:(clear ? 0.0 : 1.0)];
}

- (void)setOpacity:(CGFloat)opacity {
	UIImage *image = opacity < 1.0 ? [UIImage imageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:opacity]] : nil;
	[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	self.navigationBar.shadowImage = opacity < 1.0 ? image : nil;
	self.navigationBar.translucent = opacity < 1.0;
}

@end