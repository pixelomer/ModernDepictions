#import "MDGetPackageView.h"

@implementation MDGetPackageView

- (void)setPackage:(id)package {
	_package = package;
}

- (instancetype)init {
	if ((self = [super init])) {
		_iconView = [UIImageView new];
		_labelContainer = [UIView new];
		_authorLabel = [UILabel new];
		_nameLabel = [UILabel new];
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
	}
	return self;
}

@end