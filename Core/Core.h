#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MDTargetClass) {
    MDTargetDepictionController,
    MDTargetPackage
};

typedef NS_ENUM(NSInteger, MDPackageManager) {
    MDPackageManagerZebra,
    MDPackageManagerCydia
};

typedef NS_ENUM(NSInteger, MDPackageAttribute) {
    MDPackageAttributeIcon
};

Class MDGetClass(MDTargetClass classID);
void MDInitializeCore(void);
NSString *MDGetFieldFromPackage(Package *package, NSString *field);
const char *MDGetClassName(MDTargetClass classID);
void MDGetDataFromURL(NSURL *URL, BOOL useCacheIfPossible, void (^callback)(NSData *, NSError *, NSInteger));
extern MDPackageManager MDCurrentPackageManager;
id MDGetAttribute(Package *package, MDPackageAttribute attr);