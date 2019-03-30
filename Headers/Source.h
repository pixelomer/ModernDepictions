#import <Foundation/Foundation.h>

@interface Source : NSObject
- (NSString *)depictionForPackage:(NSString *)package;
- (NSString *)rooturi;
@end

@interface Source(ModernDepictions)
@property (nonatomic, assign) bool didAttemptBefore;
@property (nonatomic, retain) NSDictionary *paymentProviderInfo;
@property (nonatomic, retain) NSURL *paymentEndpoint;
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@end