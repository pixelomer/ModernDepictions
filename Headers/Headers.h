#import <UIKit/UIKit.h>
#define MD_BASIC_INTERFACE(name, class) \
@interface name : class \
@end

MD_BASIC_INTERFACE(Package, NSObject)
MD_BASIC_INTERFACE(Source, NSObject)
MD_BASIC_INTERFACE(MIMEAddress, NSObject)

#undef MD_BASIC_INTERFACE

@interface Package(Cydia)
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