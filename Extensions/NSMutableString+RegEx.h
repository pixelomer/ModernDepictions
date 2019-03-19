#import <Foundation/Foundation.h>

@interface NSString(RegEx)

- (void)findAndReplaceWithPattern:(NSString *)pattern template:(NSString *)replacementTemplate error:(NSError **)error;

@end