#import "FeaturedPackageCell.h"

@implementation FeaturedPackageCell

- (instancetype)initWithIconSize:(CGFloat)iconSize centerText:(BOOL)shouldCenterText reuseIdentifier:(NSString *)reuseIdentifier {
	return [super initWithIconSize:65.0 centerText:YES reuseIdentifier:reuseIdentifier];
}

@end