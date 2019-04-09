#import <Foundation/Foundation.h>

@interface FeaturedDummyPackage : NSObject
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *name;
- (instancetype)initWithPackageName:(NSString *)name identifier:(NSString *)identifier;
@end