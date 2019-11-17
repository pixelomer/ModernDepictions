/*
 * I'm 19 years old and I've already wasted my entire life.
 * ~ Burgerpants
 */

#import <UIKit/UIKit.h>
#import <ModernDepictions.h>

%ctor {
	MDInitializeCore();
	MDInitializeDepictions();
}