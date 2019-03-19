#import <Foundation/Foundation.h>

@interface NSAttributedString(Markdown)

+ (instancetype)attributedStringWithMarkdown:(NSString *)rawMarkdown;

@end