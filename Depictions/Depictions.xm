#import <UIKit/UIKit.h>
#import "Depictions.h"

%hook DepictionViewController
+ (id)alloc {
	TEST_EXCEPTION(@"Hooking works UwU");
	return NULL;
}
%end

void MDInitializeDepictions(void) {
	%init(DepictionViewController = MDGetClass(MDTargetDepictionController));
}