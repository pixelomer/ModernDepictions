#import <Foundation/Foundation.h>

@interface NSAttributedString(Markdown)

+ (instancetype)attributedStringWithHTML:(NSString *)rawHTML newlines:(NSString *)newlineString allowMarkdown:(bool)allowMarkdown extraCSS:(NSString *)css;

@end