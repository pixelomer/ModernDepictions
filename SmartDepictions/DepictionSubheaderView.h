#import "DepictionMarkdownView.h"

@interface DepictionSubheaderView : DepictionMarkdownView
@property (nonatomic, retain, setter=setTitle:) NSString *title;
@property (nonatomic, assign, setter=setUseBoldText:) bool useBoldText;
- (void)setUseBoldText:(bool)useBoldText;
- (void)setTitle:(NSString *)title;
@end