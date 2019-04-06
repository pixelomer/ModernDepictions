#import "DepictionSubheaderView.h"

@implementation DepictionSubheaderView

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self->fontSize = 14.0;
	self->_useBoldText = @NO;
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	return self;
}

@end