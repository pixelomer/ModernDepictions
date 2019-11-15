/*
 * I can't go to hell, I'm all out of vacation days.
 * ~ Burgerpants
 */

#import <UIKit/UIKit.h>
#import <ModernDepictions.h>

%ctor {
	MDInitializeCore();
	MDInitializeDepictions();
}