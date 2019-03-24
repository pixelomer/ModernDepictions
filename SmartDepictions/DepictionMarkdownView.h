#import <UIKit/UIKit.h>
#import "DepictionBaseView.h"

@interface DepictionMarkdownView : DepictionBaseView
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, retain, setter=setMarkdown:) NSString *markdown;
@property (assign) bool useSpacing;
@property (assign) bool useMargins;
@property (nonatomic, assign, setter=setUseRawFormat:) bool useRawFormat;
- (void)setUseRawFormat:(bool)shouldUseRawFormat;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setMarkdown:(NSString *)newText;
@end