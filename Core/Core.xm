#import <Foundation/Foundation.h>
#import "Core.h"
#import <objc/runtime.h>

MDPackageManager MDCurrentPackageManager = 0;
static const char *(*GetClassNameFunction)(MDTargetClass classID) = NULL;

const char *_MDGetClassName_Cydia(MDTargetClass classID) {
	switch (classID) {
		case MDTargetDepictionController:
			return "CYPackageController";
		case MDTargetPackage:
			return "Package";
	}
	return NULL;
}

const char *MDGetClassName(MDTargetClass classID) {
	return GetClassNameFunction(classID);
}

Class MDGetClass(MDTargetClass classID) {
	return objc_getClass(MDGetClassName(classID));
}

void MDInitializeCore(void) {
	const char *str = NSBundle.mainBundle.bundleIdentifier.UTF8String;
	if (!strcmp(str, "com.saurik.Cydia")) {
		MDCurrentPackageManager = MDPackageManagerCydia;
		GetClassNameFunction = &_MDGetClassName_Cydia;
	}
	else {
		[NSException
			raise:NSInternalInconsistencyException
			format:@"ModernDepictions was initialized in an unsupported application."
		];
	}
}