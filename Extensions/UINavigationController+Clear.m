#import "UINavigationController+Clear.h"
#import "UIImage+ImageWithColor.h"

@implementation UINavigationController(Clear)

- (void)setClear:(BOOL)clear {
	[self setClearness:(clear ? 1.0 : 0.0)];
}

- (void)setClearness:(CGFloat)clearness {
	UIImage *image = clearness > 0.0 ?
		(clearness == 1.0 ?
			[UIImage new] :
			[UIImage imageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:clearness]]
		)
	: nil;
	[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
	self.navigationBar.shadowImage = clearness <= 0.0 ? image : nil;
	self.navigationBar.translucent = clearness > 0.0;
}

@end