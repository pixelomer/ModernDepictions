#import "DepictionSubheaderView.h"

@implementation DepictionSubheaderView

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	self->fontSize = 14.0;
	return self;
}

@end