#import <UIKit/UIKit.h>
#import "SmartContentCell.h"

@interface DepictionMarkdownView : SmartContentCell
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, retain, setter=setMarkdown:) NSString *markdown;
@property (assign) bool useSpacing;
@property (assign) bool useMargins;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setMarkdown:(NSString *)newText;
@end