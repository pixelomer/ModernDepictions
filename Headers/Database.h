#import <Foundation/Foundation.h>

@class Package;

@interface Database : NSObject
- (Package *)packageWithName:(NSString *)name;
- (NSString *)getField:(NSString *)name;
@end