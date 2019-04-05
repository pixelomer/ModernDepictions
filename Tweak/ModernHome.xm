#import <UIKit/UIKit.h>
#import <Headers/Headers.h>

%group ModernHome
%hook HomeController

- (void *)init {
	return %orig;
}

%end
%end

void ModernDepictionsInitializeHome(void) {
	%init(ModernHome);
}