#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "SmartDepictions/SmartPackageController.h"
#import "Extensions/UIColor+HexString.h"
@import GoogleMobileAds;

extern "C" void _CFEnableZombies();

// Dirty function to check if a depiction is valid
__unused static bool VerifySileoDepiction(NSDictionary *depiction) {
	return ([depiction[@"minVersion"] isKindOfClass:[NSString class]] &&
		[depiction[@"class"] isKindOfClass:[NSString class]] &&
		NSClassFromString(depiction[@"class"]) && (
			[(NSString *)depiction[@"class"] isEqualToString:@"DepictionTabView"] && (
				[depiction[@"tabs"] isKindOfClass:[NSArray class]] &&
				[(NSArray *)depiction[@"tabs"] count] > 0
			)
		)
	);
}

%group SmartDepictions
%hook CYPackageController

- (void *)initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
	Package *package = [database packageWithName:name];
	if (package) {
		[package parse];
		NSString *rawDepictionURL = [package sileoDepiction];
		NSString *rawHTMLDepictionURL = [package depiction];
		NSURL *depictionURL = nil;
		if ([rawDepictionURL isKindOfClass:[NSString class]]) {
			depictionURL = [NSURL URLWithString:rawDepictionURL];
		}
		else if (![rawHTMLDepictionURL isKindOfClass:[NSString class]]);
		else return %orig;
		NSLog(@"Depiction URL: %@", depictionURL);
		SmartPackageController *newView = [[SmartPackageController alloc] initWithDepictionURL:depictionURL database:database packageID:[package id]];
		if (newView) {
			NSLog(@"New view: %@", newView);
			NSLog(@"Returning...");
			return (__bridge void *)newView;
		}
	}
	return %orig;
}

%end

%hook Package
%property (nonatomic, retain) NSString *sileoDepiction;

- (void)parse {
	%orig;
	id value = [self getField:@"sileodepiction"];
	self.sileoDepiction = [value isKindOfClass:[NSNull class]] ? nil : value;
}

%end

%hook UIView

- (void)setBackgroundColor:(id)newColor {
	UIColor *color = [UIColor clearColor];
	if (!newColor);
	else if ([newColor isKindOfClass:[NSString class]]) color = [UIColor colorWithHexString:newColor];
	else if ([newColor isKindOfClass:[UIColor class]]) color = newColor;
	else @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid type for a color" userInfo:nil];
	%orig(color);
}

%end

%hook Cydia

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	NSLog(@"Starting GADMobileAds...");
	[[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
}

// For some reason Cydia forgets its superclass when I start GADMobileAds
- (Class)superclass {
	return %c(CyteApplication);
}

- (void)applicationWillResignActive:(id)application {
	NSLog(@"Application will resign active");
	%orig;
}

%end
%end

%ctor {
	if ([%c(Package) instancesRespondToSelector:@selector(getField:)]) {
		NSLog(@"init");
	#if DEBUG
		//_CFEnableZombies();
	#endif
		%init(SmartDepictions);
	}
}