#import <UIKit/UIKit.h>
#import <Headers/Headers.h>
#import <ModernDepictions/SileoDepictions/ModernPackageController.h>
@import GoogleMobileAds;

static NSArray *iOSRepoUpdatesHosts;
static __kindof UIViewController *(*origPVCInitializer)(CYPackageController *const __unsafe_unretained, SEL, Database *__strong, NSString *__strong, NSString *__strong);

%group Depictions
%hook CYPackageController

%new
- (CYPackageController *)___initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
	return origPVCInitializer(self, _cmd, database, name, referrer);
}

- (__kindof UIViewController *)initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
	origPVCInitializer = &%orig;
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
		else if (iOSRepoUpdatesHosts) {
			NSURL *requestedURL;
			if (!(requestedURL = [NSURL URLWithString:rawHTMLDepictionURL]) || ![iOSRepoUpdatesHosts containsObject:requestedURL.host]) return %orig;
			NSString *percentEncodedURL = [rawHTMLDepictionURL stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
			depictionURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.ios-repo-updates.com/api/sileo-depiction/?depiction=%@", percentEncodedURL]];
			if (!depictionURL) return %orig;
			NSLog(@"Using the iOS Repo Updates API.\nOriginal URL: %@\nEncoded URL: %@\nFinal URL: %@", rawHTMLDepictionURL, percentEncodedURL, depictionURL);
		}
		else return %orig;
		NSLog(@"Depiction URL: %@", depictionURL);
		ModernPackageController *newView = [[ModernPackageController alloc] initWithDepictionURL:depictionURL database:database packageID:[package id]];
		NSInvocation *original = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:_cmd]];
		original.selector = @selector(___initWithDatabase:forPackage:withReferrer:);
		[original setArgument:&database atIndex:2];
		[original setArgument:&name atIndex:3];
		[original setArgument:&referrer atIndex:4];
		[original retainArguments];
		newView.originalInvocation = original;
		newView.referrer = referrer;
		if (newView) {
			NSLog(@"New view: %@", newView);
			if (self) objc_msgSend(self, NSSelectorFromString(@"release"));
			NSLog(@"Returning...");
			return newView;
		}
	}
	return %orig;
}

- (void)dealloc {
	NSLog(@"A CYPackageController is being deallocated...");
	%orig;
}

%end

%hook Cydia

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	NSLog(@"Starting GADMobileAds...");
	[[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
}

%end

@interface GADNUIKitWebViewController : UIView
- (UIWebView *)webView;
@end

%hook GADNUIKitWebViewController

- (UIWebView *)webView {
	UIWebView *orig = %orig;
	orig.scrollView.scrollEnabled = NO;
	return orig;
}

%end
%end

void ModernDepictionsInitializeDepictions(void) {
	NSNumber *enableiOSRepoUpdatesAPI = [[NSUserDefaults standardUserDefaults] objectForKey:@"EnableiOSRepoUpdatesAPI" inDomain:@"com.pixelomer.moderndepictions.prefs"];
	if (enableiOSRepoUpdatesAPI && [enableiOSRepoUpdatesAPI boolValue]) {
		iOSRepoUpdatesHosts = @[
#if IRU_API_ALLOW_ALL
			@"repo.packix.com",
			@"moreinfo.thebigboss.org"
#endif
		];
	}
	%init(Depictions);
}