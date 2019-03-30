#import <Foundation/Foundation.h>

@interface NSUserDefaults(Private)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
@end