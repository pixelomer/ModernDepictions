/*
 * Lie to yourself all the time. It makes you feel better.
 * ~ Burgerpants
 */

#import <UIKit/UIKit.h>
#import <ModernDepictions.h>

%ctor {
	MDInitializeCore();
	MDInitializeDepictions();
}