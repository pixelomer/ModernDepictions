#import <UIKit/UIKit.h>
@class Source;
@class MIMEAddress;

@interface Package : NSObject
- (NSString *)depiction;
- (NSString *)id;
- (Source *)source;
- (void)parse;
- (bool)isCommercial;
- (NSString *)mode;
- (NSString *)section;
- (BOOL)upgradableAndEssential:(BOOL)essential;
- (NSArray *)downgrades;
- (UIImage *)icon;
- (BOOL)uninstalled;
- (NSString *)name;
- (void)install;
- (MIMEAddress *)author;
- (NSString *)getField:(NSString *)name;
- (NSString *)longDescription;
- (Source *)source;
- (NSString *)shortDescription;
- (NSString *)shortSection;
@end

@interface Package(ModernDepictions)
@property (nonatomic, retain) NSDictionary *paymentInformation;
@property (nonatomic, assign) bool didAttemptBefore;
@property (nonatomic, retain) NSString *sileoDepiction;
- (void)retrievePaymentInformationWithCompletion:(void(^)(Package *, NSError *))completionHandler;
@end