#import <Foundation/Foundation.h>

@class Package;

@interface Cydia : NSObject
- (void)installPackage:(Package *)package;
@end