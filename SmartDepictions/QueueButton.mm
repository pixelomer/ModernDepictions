#import "QueueButton.h"

@implementation QueueButton

- (instancetype)init {
	[super init];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	self.backgroundColor = [UIColor blueColor];
	self.layer.masksToBounds = YES;
	if (@available(iOS 7.0, *)) self.layer.cornerRadius = 16.0;
	else self.layer.cornerRadius = 10.0;
	return self;
}

@end