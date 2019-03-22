#import "DepictionSubheaderView.h"

@implementation DepictionSubheaderView

- (void)setUseBoldText:(bool)useBoldText {
	_useBoldText = useBoldText;
	[self setTitle:_title];
}

- (void)setTitle:(NSString *)title {
	if (title) {
		self.markdown = [NSString stringWithFormat:@"%@%@%@", self.useBoldText ? @"<b>" : @"", title, self.useBoldText ? @"</b>" : @""];
	}
	_title = title;
}

- (NSString *)title {
	return _title;
}

@end