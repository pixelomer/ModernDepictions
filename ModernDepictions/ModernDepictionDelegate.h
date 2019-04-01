#import <Foundation/Foundation.h>
#import "../Headers/Headers.h"

@class ModernPackageController;
@class Database;
@class Package;
@class Cydia;

@interface ModernDepictionDelegate : NSObject {
	NSString *modificationButtonTitle;
	UIColor *_tintColor;
}
@property (nonatomic, retain) ModernPackageController *packageController;
@property (nonatomic, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, retain) Cydia *cydiaDelegate;
@property (nonatomic, readonly) NSDictionary *depiction;
@property (nonatomic, readonly) Database *database;
@property (nonatomic, readonly) NSURL *depictionURL;
@property (nonatomic, readonly) NSString *packageID;
@property (nonatomic, readonly) Package *package;
@property (nonatomic, copy) NSString *referrer;
@property (nonatomic, readonly) NSDictionary *modificationButtons;
@property (nonatomic, readonly) bool iOS6;
@property (nonatomic, readonly, getter=tintColor) UIColor *tintColor;
@property (nonatomic, retain) NSInvocation *originalInvocation;
- (UIColor *)tintColor;
- (void)handleRotation;
- (NSString *)modificationButtonTitle;
- (void)setModificationButtonTitle:(NSString *)newTitle;
- (void)setPackageWithID:(NSString *)packageID database:(Database *)database;
- (void)downloadDepiction;
+ (UIColor *)defaultTintColor;
- (instancetype)initWithPackageController:(ModernPackageController *)packageController
	depictionURL:(NSURL *)depictionURL
	database:(Database *)database
	packageID:(NSString *)packageID;
- (void)reloadData;
- (void)handleModifyButton;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)downloadDataFromURL:(NSURL *)url completion:(void (^)(NSData *, NSError *))completionHandler;
@end