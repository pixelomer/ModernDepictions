#import "DepictionMarkdownView.h"

@interface DepictionSubheaderView : DepictionMarkdownView {
	@protected
	NSString *_title;
}
@property (nonatomic, retain, setter=setTitle:, getter=title) NSString *title;
@property (nonatomic, assign, setter=setUseBoldText:) bool useBoldText;
- (void)setUseBoldText:(bool)useBoldText;
- (void)setTitle:(NSString *)title;
@end