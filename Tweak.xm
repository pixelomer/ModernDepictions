#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "SmartDepictions/SmartPackageController.h"

%hook CYPackageController

- (void *)initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
	Package *package = [database packageWithName:name];
	if (package) {
		[package parse];
		NSString *depictionURL = [package depiction];
		NSLog(@"Original URL: %@", depictionURL);
		if (depictionURL) {
			NSArray *depictionURLParts = [depictionURL componentsSeparatedByString:@"#"];
			NSLog(@"Parts: %@", depictionURLParts);
			if (depictionURLParts && [depictionURLParts count] > 1) {
				NSURL *JSONDepictionURL = [NSURL URLWithString:[depictionURLParts lastObject]];
				NSLog(@"JSON Depiction URL: %@", JSONDepictionURL);
				if (JSONDepictionURL) {
					NSData *rawJSONDepiction = [NSData dataWithContentsOfURL:JSONDepictionURL];
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
	}
	return %orig;
}

%end