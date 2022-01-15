#import <UIKit/UIKit.h>

@interface FeaturedDummyPackage : NSObject
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *name;
- (instancetype)initWithPackageName:(NSString *)name identifier:(NSString *)identifier;
- (void)parse;
- (NSString *)mode;
- (UIImage *)icon;
- (NSString *)id;
- (id)source;
- (id)author;
- (BOOL)uninstalled;
- (NSString *)shortDescription;
@end