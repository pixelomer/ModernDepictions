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
- (BOOL)upgradableAndEssential:(BOOL)essential;
- (NSArray *)downgrades;
- (UIImage *)icon;
- (BOOL)uninstalled;
- (NSString *)name;
- (void)install;
- (MIMEAddress *)author;
@end

@interface Package(CYSupport)
@property (nonatomic, copy) NSString *sileoDepiction;
- (NSString *)valueForTag:(NSString *)tag;
+ (bool)isCYSupportAvailable;
@end