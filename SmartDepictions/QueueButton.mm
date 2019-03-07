#import "QueueButton.h"

@implementation QueueButton

- (instancetype)init {
	[super init];
	self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
	self.backgroundColor = [UIColor blueColor];
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = 16.0;
	return self;
}

@end