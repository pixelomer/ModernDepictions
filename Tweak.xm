#import <UIKit/UIKit.h>
#import "Headers/Headers.h"
#import "ModernDepictions/ModernPackageController.h"
#import "Extensions/UIColor+HexString.h"
@import GoogleMobileAds;

extern "C" void _CFEnableZombies();
static void *(*origPVCInitializer)(CYPackageController *const __unsafe_unretained, SEL, Database *__strong, NSString *__strong, NSString *__strong);

%group ModernDepictions

#pragma mark - Necessary hooks

%hook CYPackageController

%new
- (CYPackageController *)___initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
	return (__bridge id)origPVCInitializer(self, _cmd, database, name, referrer);
}

- (void *)initWithDatabase:(Database *)database forPackage:(NSString *)name withReferrer:(NSString *)referrer {
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
			if (self) objc_msgSend(self, NSSelectorFromString(@"release")); // Cydia isn't built with ARC
			NSLog(@"Returning...");
			return (__bridge void *)newView;
		}
	}
	return %orig;
}

- (void)dealloc {
	NSLog(@"A CYPackageController is being deallocated...");
	%orig;
}

%end

%hook Database

- (void)reloadDataWithInvocation:(NSInvocation *)invocation {
	%orig;
	NSMutableArray *sourceList = MSHookIvar<id>(self, "sourceList_");
	if (!sourceList) return;
	for (Source *source in sourceList) {
		if (!source.didAttemptBefore) {
			source.didAttemptBefore = true;
			NSLog(@"Root URI: %@", source.rooturi);
			NSURL *paymentEndpointSource = [[NSURL URLWithString:source.rooturi] URLByAppendingPathComponent:@"payment_endpoint"];
			NSLog(@"Payment endpoint source: %@", paymentEndpointSource);
			if (paymentEndpointSource) {
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
					NSData *rawData = [NSData dataWithContentsOfURL:paymentEndpointSource];
					NSString *stringURL = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
					NSLog(@"Payment endpoint: %@", stringURL);
					if (!(source.paymentEndpoint = [NSURL URLWithString:stringURL])) return;
					NSURL *infoURL = [source.paymentEndpoint URLByAppendingPathComponent:@"info"];
					NSLog(@"Info URL: %@", infoURL);
					if (!infoURL || !(rawData = [NSData dataWithContentsOfURL:infoURL])) return;
					source.paymentProviderInfo = [NSJSONSerialization JSONObjectWithData:rawData options:0 error:nil];
					NSLog(@"Payment provider info: %@", source.paymentProviderInfo);
				});
			}
		}
	}
}

%end

%hook Source
%property (nonatomic, assign) bool didAttemptBefore;
%property (nonatomic, retain) NSDictionary *paymentProviderInfo;
%property (nonatomic, retain) NSURL *paymentEndpoint;
%property (nonatomic, retain) NSOperationQueue *operationQueue;
%end

%hook Package
%property (nonatomic, retain) NSString *sileoDepiction;
%property (nonatomic, retain) NSDictionary *paymentInformation;

%new
- (void)retrievePaymentInformationWithCompletion:(void(^)(Package *, NSError *))completionHandler {
	if (!self.source.paymentEndpoint) return;
	if (self.paymentInformation) {
		dispatch_async(dispatch_get_main_queue(), ^{
			completionHandler(self, nil);
		});
		return;
	}
	if (!self.source.operationQueue) self.source.operationQueue = [NSOperationQueue new];
	NSURL *url;
	if (!(url = [self.source.paymentEndpoint URLByAppendingPathComponent:[NSString stringWithFormat:@"package/%@/info", self.id]])) return;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"POST";
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	Package *package = self;
	[NSURLConnection sendAsynchronousRequest:request
		queue:self.source.operationQueue
		completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
			NSError *finalError = error;
			if (data && !finalError) {
				NSLog(@"Data: %@", [[NSString alloc] initWithBytes:data.bytes length:65 encoding:NSUTF8StringEncoding]);
				package.paymentInformation = [NSJSONSerialization JSONObjectWithData:data options:0 error:&finalError];
				NSLog(@"Payment info for %@: %@", package, package.paymentInformation ?: finalError);
			}
			completionHandler(self, finalError);
		}
	];
}

- (void)parse {
	%orig;
	id value = [self getField:@"sileodepiction"];
	self.sileoDepiction = [value isKindOfClass:[NSNull class]] ? nil : value;
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

#pragma mark - Convenience hooks

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

%hook UILabel

- (void)setTextAlignment:(NSTextAlignment)alignment {
	NSTextAlignment finalAlignment = alignment;
	if (alignment == NSTextAlignmentNaturalInverse) {
		finalAlignment = (
			UIApplication.sharedApplication.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft ?
			NSTextAlignmentLeft :
			NSTextAlignmentRight
		);
	}
	%orig(finalAlignment);
}

%end
%end

%ctor {
	if ([%c(Package) instancesRespondToSelector:@selector(getField:)]) {
		NSLog(@"init");
	#if DEBUG
		_CFEnableZombies();
	#endif
		%init(ModernDepictions);
	}
}