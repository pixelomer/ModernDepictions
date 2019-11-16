/*
 * You have something called "determination". So as long as you hold on... So as
 * long as you do what's in your heart... I believe you can do the right thing.
 * ~ Sans
 */

#import <UIKit/UIKit.h>
#import <ModernDepictions.h>

%ctor {
	MDInitializeCore();
	MDInitializeDepictions();
}