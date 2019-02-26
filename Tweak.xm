#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "SmartDepictions/SmartDepictions.h"

%hook CYPackageController
%property (nonatomic, retain) id _Nullable SDDelegateOverride;

- (void)showActionSheet:(UIActionSheet *)sheet fromItem:(id)item {
	if (self.SDDelegateOverride) [self.SDDelegateOverride performSelector:@selector(showActionSheet:fromItem:) withObject:sheet withObject:item];
	else %orig;
}

%end

%hook PackageListController

- (void)didSelectPackage:(Package *)package {
	NSLog(@"-[%@ didSelectPackage:%@]", NSStringFromClass([self class]), package);
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
						NSLog(@"%@", JSONDepiction);
						SmartPackageController *view = [[SmartPackageController alloc] initWithDepiction:JSONDepiction database:MSHookIvar<id>(self, "database_") packageID:[package id] referrer:[[self referrerURL] absoluteString]];
						MSHookIvar<id>(view.dummyController, "delegate_") = view;
						[[self navigationController] pushViewController:view animated:YES];
						return;
					}
				}
			}
		}
	}
	%orig;
}

/*
- (void) didSelectPackage:(Package *)package {
    CYPackageController *view([[[CYPackageController alloc] initWithDatabase:database_ forPackage:[package id] withReferrer:[[self referrerURL] absoluteString]] autorelease]);
    [view setDelegate:self.delegate];
    [[self navigationController] pushViewController:view animated:YES];
}
*/

%end