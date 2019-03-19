#import "NSMutableString+RegEx.h"

@implementation NSMutableString(RegEx)

- (void)findAndReplaceWithPattern:(NSString *)pattern template:(NSString *)replacementTemplate error:(NSError **)error {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:error];
	if (!error || !(*error)) {
		[regex replaceMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replacementTemplate];
	}
}

@end