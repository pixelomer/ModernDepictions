#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MDTargetClass) {
    MDTargetDepictionController,
    MDTargetPackage
};

typedef NS_ENUM(NSInteger, MDPackageManager) {
    MDPackageManagerZebra,
    MDPackageManagerCydia
};

Class MDGetClass(MDTargetClass classID);
void MDInitializeCore(void);
const char *MDGetClassName(MDTargetClass classID);
extern MDPackageManager MDCurrentPackageManager;