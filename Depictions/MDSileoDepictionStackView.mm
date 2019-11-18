#import "MDSileoDepictionStackView.h"
#import "Depictions.h"

@implementation MDSileoDepictionStackView

+ (BOOL)shouldAssignPropertiesSeparately {
	return YES;
}

- (instancetype)initWithProperties:(NSDictionary *)properties {
	return [super init];
}

- (void)setDepictionViews:(NSArray *)depictionViews {
	_depictionViews = depictionViews;
	[self beginUpdates];
	for (NSDictionary *properties in depictionViews) {
		if (![properties isKindOfClass:[NSDictionary class]]) continue;
		UIView *view = MDCreateView(properties);
		if (view) [self insertView:view];
	}
	[self endUpdates];
}

@end