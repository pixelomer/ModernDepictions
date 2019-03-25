#import <Foundation/Foundation.h>
#import "../Headers/Headers.h"

@class SmartPackageController;
@class Database;
@class Package;
@class Cydia;

@interface SmartDepictionDelegate : NSObject {
	NSString *modificationButtonTitle;
}
@property (nonatomic, retain) SmartPackageController *packageController;
@property (nonatomic, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, retain) Cydia *cydiaDelegate;
@property (nonatomic, readonly) NSDictionary *depiction;
@property (nonatomic, readonly) Database *database;
@property (nonatomic, readonly) NSURL *depictionURL;
@property (nonatomic, readonly) NSString *packageID;
@property (nonatomic, readonly) Package *package;
@property (nonatomic, readonly) NSDictionary *modificationButtons;
@property (nonatomic, readonly) bool iOS6;
@property (nonatomic, readonly) UIColor *tintColor;
- (void)handleRotation;
- (NSString *)modificationButtonTitle;
- (void)setModificationButtonTitle:(NSString *)newTitle;
- (void)setPackageWithID:(NSString *)packageID database:(Database *)database;
- (void)downloadDepiction;
+ (UIColor *)defaultTintColor;
- (instancetype)initWithPackageController:(SmartPackageController *)packageController
	depictionURL:(NSURL *)depictionURL
	database:(Database *)database
	packageID:(NSString *)packageID;
- (void)reloadData;
- (void)handleModifyButton;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)downloadDataFromURL:(NSURL *)url completion:(void (^)(NSData *, NSError *))completionHandler;
@end