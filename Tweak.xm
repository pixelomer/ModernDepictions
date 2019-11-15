/*
 * Now your sanity and mine can die TOGETHER!
 * ~ Undyne
 */

#import <UIKit/UIKit.h>
#import <ModernDepictions.h>

%ctor {
	MDInitializeCore();
	MDInitializeDepictions();
}