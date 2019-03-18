#import "SmartContentCell.h"

@implementation SmartContentCell

- (CGFloat)height {
	return 44.0;
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	_depictionDelegate = delegate;
	return self;
}

- (instancetype)init {
	return nil;
}

@end