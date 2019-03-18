#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "SmartDepictions/SmartPackageController.h"

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
		NSLog(@"Raw URL: %@", rawDepictionURL);
		if (rawDepictionURL) {
			NSURL *depictionURL = [NSURL URLWithString:rawDepictionURL];
			NSLog(@"Depiction URL: %@", depictionURL);
			if (depictionURL) {
				SmartPackageController *newView = [[SmartPackageController alloc] initWithDepictionURL:depictionURL database:database packageID:[package id]];
				if (newView) {
					NSLog(@"New view: %@", newView);
					NSLog(@"Returning...");
					return (__bridge void *)newView;
				}
			}
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
%end

%ctor {
	if (class_getInstanceMethod([%c(Package) class], @selector(getField:)) != NULL) {
		NSLog(@"init");
	#if DEBUG
		//_CFEnableZombies();
	#endif
		%init(SmartDepictions);
	}
}