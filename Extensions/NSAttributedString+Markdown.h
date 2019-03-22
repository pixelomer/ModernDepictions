#import <Foundation/Foundation.h>

@interface NSAttributedString(Markdown)

+ (instancetype)attributedStringWithMarkdown:(NSString *)rawMarkdown;
+ (instancetype)attributedStringWithHTML:(NSString *)rawHTML;

@end