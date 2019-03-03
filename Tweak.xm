#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "SmartDepictions/SmartPackageController.h"

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
				NSData *rawJSONDepiction = [NSData dataWithContentsOfURL:depictionURL];
				NSLog(@"Raw JSON Data: %@", rawJSONDepiction);
				if (rawJSONDepiction) {
					NSDictionary *JSONDepiction = [NSJSONSerialization
						JSONObjectWithData:rawJSONDepiction
						options:0
						error:nil
					];
					NSLog(@"Serialized data: %@", JSONDepiction);
					if (JSONDepiction) {
						SmartPackageController *newView = [[%c(SmartPackageController) alloc] initWithDepiction:[JSONDepiction copy] database:database packageID:[package id] referrer:referrer];
						if (newView) {
							newView.delegate = self.delegate;
							NSLog(@"New view: %@", newView);
							[self release]; // The CYPackageController is useless at this point
							NSLog(@"Returning...");
							return (void *)newView;
						}
					}
				}
			}
		}
	}
	return %orig;
}

%end

%ctor {
	if ([%c(Package) respondsToSelector:@selector(isCYSupportAvailable)]) {
		NSLog(@"init");
		%init;
	}
}