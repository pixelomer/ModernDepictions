#import "DepictionSubheaderView.h"

@implementation DepictionSubheaderView

- (void)setUseBoldText:(bool)useBoldText {
	_useBoldText = useBoldText;
	[self setTitle:_title];
}

- (void)setTitle:(NSString *)title {
	if (title) {
		self.markdown = [NSString stringWithFormat:@"%@%@%@", _useBoldText ? @"<b>" : @"", title, _useBoldText ? @"</b>" : @""];
	}
	_title = title;
}

@end