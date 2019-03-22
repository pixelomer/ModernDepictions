#import "NSAttributedString+Markdown.h"
#import "NSMutableString+RegEx.h"

@implementation NSAttributedString(Markdown)

+ (instancetype)attributedStringWithHTML:(NSString *)rawHTML newlines:(NSString *)newlineString allowMarkdown:(bool)allowMarkdown {
	NSMutableString *markdown = [rawHTML mutableCopy];
	if (allowMarkdown) {
		NSArray *replacements = @[
			@"\\[(.*?)\\]\\(.*?\\);$1",
			@"\\*\\*(.*?)\\*\\*;<b>$1</b>",
			@"\\*(.*?)\\*;<i>$1</i>",
			@"\\_\\_(.*?)\\_\\_;<b>$1</b>",
			@"\\_(.*?)\\_;<i>$1</i>"
		];
		for (NSString *replacement in replacements) {
			NSArray *components = [replacement componentsSeparatedByString:@";"];
			[markdown findAndReplaceWithPattern:components[0] template:components[1] error:nil];
		}
	}
	NSMutableArray *components = [[markdown componentsSeparatedByString:@"\n"] mutableCopy];
	if (allowMarkdown) {
		for (int j = 0; j < components.count; j++) {
			NSString *string = components[j];
			NSMutableString *prefix = [NSMutableString stringWithCapacity:6];
			[prefix setString:@" "];
			for (int i = 1; i <= 6; i++) {
				[prefix insertString:@"#" atIndex:0];
				if ([string hasPrefix:prefix]) {
					NSMutableString *mstring = [string mutableCopy];
					[mstring replaceCharactersInRange:NSMakeRange(0, prefix.length) withString:[NSString stringWithFormat:@"<h%d>", i]];
					[mstring appendString:[NSString stringWithFormat:@"</h%d>", i]];
					components[j] = [mstring copy];
					break;
				}
			}
		}
	}
	NSString *finalString = [@"<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue'; font-size: 16px; }</style>" stringByAppendingString:[components componentsJoinedByString:newlineString]];
	return [[self alloc] initWithData:[finalString dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
}

+ (instancetype)attributedStringWithMarkdown:(NSString *)rawMarkdown {
	return [self attributedStringWithHTML:rawMarkdown newlines:@"<br/>" allowMarkdown:true];
}

+ (instancetype)attributedStringWithHTML:(NSString *)rawHTML {
	return [self attributedStringWithHTML:rawHTML newlines:@"\n" allowMarkdown:false];
}

@end