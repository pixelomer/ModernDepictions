#import <UIKit/UIKit.h>
#import "Depictions.h"
#import "MDDepictionViewController.h"

%hook DepictionViewController

+ (id)alloc {
	MDDepictionViewController *newVC = [MDDepictionViewController alloc];
	return newVC;
}

%end

void MDInitializeDepictions(void) {
	%init(DepictionViewController = MDGetClass(MDTargetDepictionController));
}