#import <UIKit/UIKit.h>
#import "Depictions.h"
#import "MDDepictionViewController.h"

%hook DepictionViewController

+ (id)alloc {
	return [MDDepictionViewController alloc];
}

%end

void MDInitializeDepictions(void) {
	%init(DepictionViewController = MDGetClass(MDTargetDepictionController));
}