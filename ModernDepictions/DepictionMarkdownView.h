#import <UIKit/UIKit.h>
#import "DepictionBaseView.h"

@interface DepictionMarkdownView : DepictionBaseView {
	UITextView *textView;
}
@property (nonatomic, retain, setter=setMarkdown:) NSString *markdown;
@property (assign) bool useSpacing;
@property (assign) bool useMargins;
@property (nonatomic, assign, setter=setUseRawFormat:) bool useRawFormat;
- (void)setUseRawFormat:(bool)shouldUseRawFormat;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setMarkdown:(NSString *)newText;
@end