#import "DepictionHeaderView.h"

@implementation DepictionHeaderView

@dynamic title;
- (void)setTitle:(NSString *)title {
	if (title) {
		self.markdown = [NSString stringWithFormat:@"%@<div style=\"font-size: 22px\">%@</div>%@", self.useBoldText ? @"<b>" : @"", title, self.useBoldText ? @"</b>" : @""];
	}
	self->_title = title;
}

@end