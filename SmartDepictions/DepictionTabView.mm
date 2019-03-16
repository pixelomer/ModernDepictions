#import "DepictionTabView.h"
#import "DepictionTab.h"

@implementation DepictionTabView

- (CGFloat)height {
	return 37.0;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
	self.contentView.frame = self.frame;
	return self;
}

- (void)setTabs:(NSArray *)tabs {
	NSLog(@"Setting tabs to %@ for %@", tabs, self.description);
	if (currentTabNames) [currentTabNames release];
	currentTabNames = [[NSMutableArray alloc] init];
	for (NSDictionary *tabDict in tabs) {
		NSString *tabName = tabDict[@"tabname"];
		id views = tabDict[@"views"];
		if (!tabName || !views || ![views isKindOfClass:[NSArray class]] || [(NSArray *)views count] < 1) continue;
		[currentTabNames addObject:tabName];
	}
	if (currentTabs) {
		for (DepictionTab *tab in currentTabs) [tab removeFromSuperview];
		[currentTabs release];
	}
	currentTabs = [[NSMutableArray alloc] init];
	for (int i = 0, count = [currentTabNames count]; i < count; i++) {
		NSString *tabName = currentTabNames[i];
		DepictionTab *tab = [[DepictionTab alloc] initWithFrame:CGRectMake(
			(UIScreen.mainScreen.bounds.size.width / count) * i,
			0,
			UIScreen.mainScreen.bounds.size.width / count,
			self.contentView.frame.size.height
		)];
		[tab setTitle:tabName forState:UIControlStateNormal];
		[self.contentView addSubview:tab];
		[currentTabs addObject:tab];
	}
	_tabs = [tabs retain];
}

@end