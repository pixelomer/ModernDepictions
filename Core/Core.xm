#import <Foundation/Foundation.h>
#import "Core.h"
#import <objc/runtime.h>

MDPackageManager MDCurrentPackageManager = 0;

const char *MDGetClassName(MDTargetClass classID) {
	switch (MDCurrentPackageManager) {
		case MDPackageManagerCydia:
			switch (classID) {
				case MDTargetDepictionController:
					return "CYPackageController";
				case MDTargetPackage:
					return "Package";
			}
		case MDPackageManagerZebra:
			switch (classID) {
				case MDTargetDepictionController:
					return "ZBPackageDepictionViewController";
				case MDTargetPackage:
					return "ZBPackage";
			}
	}
	return NULL;
}

Class MDGetClass(MDTargetClass classID) {
	return objc_getClass(MDGetClassName(classID));
}

NSString *MDGetFieldFromPackage(__kindof NSObject *package, NSString *field) {
	if (!package) return nil;
	if (object_getClass(package) != MDGetClass(MDTargetPackage)) {
		// Q: Why is object_getClass(object) used here instead of [object class]?
		// A: Let me ask you another question: What if object isn't an NSObject?
		return nil;
	}
	switch (MDCurrentPackageManager) {
		case MDPackageManagerCydia:
			[(Package *)package parse];
		case MDPackageManagerZebra:
			return [(Package *)package getField:field];
	}
	return nil;
}

void MDInitializeCore(void) {
	NSString *str = NSBundle.mainBundle.bundleIdentifier;
	if ([str isEqualToString:@(CYDIA_BUNDLE_ID)]) {
		MDCurrentPackageManager = MDPackageManagerCydia;
	}
	else if ([str isEqualToString:@(ZEBRA_BUNDLE_ID)]) {
		MDCurrentPackageManager = MDPackageManagerZebra;
	}
	else {
		[NSException
			raise:NSInternalInconsistencyException
			format:@"ModernDepictions was initialized in an unsupported application."
		];
	}
}