#import <UIKit/UIKit.h>
@class Source;

@interface Package : NSObject
- (NSString *)depiction;
- (NSString *)id;
- (Source *)source;
- (void)parse;
- (bool)isCommercial;
- (NSString *)mode;
- (BOOL)upgradableAndEssential:(BOOL)essential;
- (NSArray *)downgrades;
- (UIImage *) icon;
- (BOOL)uninstalled;
- (void)install;
@end

@interface Package(CYSupport)
@property (nonatomic, copy) NSString *sileoDepiction;
- (NSString *)valueForTag:(NSString *)tag;
+ (bool)isCYSupportAvailable;
@end