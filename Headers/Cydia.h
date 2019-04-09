#import <Foundation/Foundation.h>

@class Package;

@interface Cydia : NSObject
- (void)installPackage:(Package *)package;
- (UIViewController *)pageForPackage:(NSString *)packageID withReferrer:(NSString *)referrer;
@end