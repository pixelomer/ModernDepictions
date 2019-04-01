#import "QueueButton.h"

@implementation QueueButton

- (instancetype)init {
	self = [super init];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	self.layer.masksToBounds = YES;
	self.contentEdgeInsets = UIEdgeInsetsMake(5.0, 16.0, 5.0, 16.0);
	if (@available(iOS 7.0, *)) self.layer.cornerRadius = 16.0;
	else self.layer.cornerRadius = 10.0;
	return self;
}

@end