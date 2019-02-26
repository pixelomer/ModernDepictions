#import <Foundation/Foundation.h>
@class Source;

@interface Package : NSObject
- (NSString *)depiction;
- (NSString *)id;
- (Source *)source;
- (void)parse;
@end