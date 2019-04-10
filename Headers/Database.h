#import <Foundation/Foundation.h>

@class Source;
@class Package;

@interface Database : NSObject
- (Package *)packageWithName:(NSString *)name;
- (NSString *)getField:(NSString *)name;
+ (Database *)sharedInstance;
- (NSArray<Source *> *)sources;
@end