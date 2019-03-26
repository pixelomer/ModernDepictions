#import "DepictionTableButtonView.h"

@implementation DepictionTableButtonView

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return self;
}

@end