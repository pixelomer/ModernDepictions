#import <UIKit/UIKit.h>
#import "SmartContentCell.h"

@interface DepictionMarkdownView : SmartContentCell
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, retain, setter=setMarkdown:) NSString *markdown;
@property (assign) BOOL useSpacing;
@property (assign) BOOL useMargins;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setMarkdown:(NSString *)newText;
@end