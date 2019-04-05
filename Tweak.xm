#import <Foundation/Foundation.h>
#import "Tweak/Tweak.h"

extern "C" void _CFEnableZombies();

%ctor {
	if ([%c(Package) instancesRespondToSelector:@selector(getField:)]) {
		NSLog(@"init");
	#if DEBUG
		//_CFEnableZombies();
	#endif
		ModernDepictionsInitializeDepictions();
		ModernDepictionsInitializeCore();
	}
}