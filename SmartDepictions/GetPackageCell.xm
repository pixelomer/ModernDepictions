#import "GetPackageCell.h"

@implementation GetPackageCell

- (instancetype _Nullable)initWithPackage:(Package * _Nonnull)package reuseIdentifier:(NSString * _Nonnull)reuseIdentifier {
	[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 92);
	self.contentView.frame = self.frame;
	UIImage *icon = [package icon];
	iconView = [[UIImageView alloc] initWithImage:icon];
	iconView.frame = CGRectMake(16, 16, 60, 60);
	iconView.layer.masksToBounds = YES;
	iconView.layer.cornerRadius = 15.0;
	[self.contentView addSubview:iconView];
	return self;
}

@end