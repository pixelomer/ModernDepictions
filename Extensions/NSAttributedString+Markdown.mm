#import "NSAttributedString+Markdown.h"
#import "NSMutableString+RegEx.h"
#import <MMMarkdown/MMMarkdown.h>

@implementation NSAttributedString(Markdown)

+ (instancetype)attributedStringWithHTML:(NSString *)rawHTML newlines:(NSString *)newlineString allowMarkdown:(bool)allowMarkdown extraCSS:(NSString *)css {
	NSString *finalString = nil;
	if (@available(iOS 8.0, *)) {
		finalString = (allowMarkdown ?
			([MMMarkdown HTMLStringWithMarkdown:rawHTML extensions:MMMarkdownExtensionsGitHubFlavored error:nil] ?:
				@"<p style=\"color:red\">ERROR: Failed to parse markdown. Please contact the repository maintainer.</p>"
			) :
			rawHTML
		);
	}
	else {
		NSMutableString *markdown = [rawHTML mutableCopy];
		if (allowMarkdown) {
			// This is an NSArray because the changes have to be done in a specific order
			NSArray *replacements = @[
				@"\\[(.*?)\\]\\((.*?)\\);<a href=\"$2\">$1</a>",
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
		finalString = [components componentsJoinedByString:newlineString];
	}
	NSString *htmlPrefix = [NSString stringWithFormat:
		@"<meta charset=\"UTF-8\">"
		"<style>"
		"body {"
		"	font-family: '-apple-system', 'HelveticaNeue';"
		"	font-size: 16px;"
		"}"
		"%@"
		"</style>", css ?: @""
	];
	finalString = [htmlPrefix stringByAppendingString:finalString];
	NSMutableAttributedString *finalObject = [[[self alloc] initWithData:[finalString dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] mutableCopy];
	if (finalObject.mutableString.length > 0 && [finalObject.mutableString characterAtIndex:finalObject.mutableString.length - 1] == '\n') {
		[finalObject deleteCharactersInRange:NSMakeRange(finalObject.mutableString.length - 1, 1)];
	}
	return [finalObject copy];
}

@end