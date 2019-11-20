#import <Foundation/Foundation.h>
#import "Core.h"
#import <objc/runtime.h>

MDPackageManager MDCurrentPackageManager = 0;
static NSArray *fieldArray;

const char *MDGetClassName(MDTargetClass classID) {
	switch (MDCurrentPackageManager) {
		case MDPackageManagerCydia:
			switch (classID) {
				case MDTargetDepictionController:
					return "CYPackageController";
				case MDTargetPackage:
					return "Package";
			}
		case MDPackageManagerZebra:
			switch (classID) {
				case MDTargetDepictionController:
					return "ZBPackageDepictionViewController";
				case MDTargetPackage:
					return "ZBPackage";
			}
	}
	return NULL;
}

Class MDGetClass(MDTargetClass classID) {
	return objc_getClass(MDGetClassName(classID));
}

NSString *MDGetFieldFromPackage(Package *package, NSString *field) {
	NSLog(@"[GetField] Field: \"%@\", Package: %@", field, package);
	if (!package) return nil;
	if (object_getClass(package) != MDGetClass(MDTargetPackage)) {
		NSLog(@"[GetField] Invalid class");
		// Q: Why is object_getClass(object) used here instead of [object class]?
		// A: Let me ask you another question: What if object isn't an NSObject?
		return nil;
	}
	id value = nil;
	switch (MDCurrentPackageManager) {
		case MDPackageManagerCydia:
			[package parse];
			value = [package getField:field];
			value = [value isKindOfClass:[NSString class]] ? value : nil;
			return value;
		case MDPackageManagerZebra:
			switch ([fieldArray indexOfObject:field.lowercaseString]) {
				case 0: return [package name];
				case 1: return [package longDescription];
				case 2: return [(ZBPackage *)package identifier];
				case 3: return [(ZBPackage *)package version];
				case 4: return [(ZBPackage *)package depictionURL].absoluteString;
				default: return [package getField:field];
			}
			break;
	}
	NSLog(@"Returning \"%@\"...", value);
	return value;
}

void MDGetDataFromURL(NSURL *URL, BOOL useCacheIfPossible, void (^callback)(NSData *, NSError *, NSInteger)) {
	if (!URL || ![URL.scheme.lowercaseString hasPrefix:@"http"]) return;
	static NSURLSession *session = nil;
	static NSOperationQueue *queue;
	if (!session) {
		queue = [NSOperationQueue new];
		session = [NSURLSession
			sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
			delegate:nil
			delegateQueue:queue
		];
	}
	NSURLRequest *request = [NSURLRequest
		requestWithURL:URL
		cachePolicy:(
			useCacheIfPossible ?
			NSURLRequestReturnCacheDataElseLoad :
			NSURLRequestReloadIgnoringLocalCacheData
		)
		timeoutInterval:5 // ¯\_(ツ)_/¯
	];
	request = [%c(CydiaWebViewController) requestWithHeaders:request] ?: request;
	NSURLSessionDownloadTask *task = [session
		downloadTaskWithRequest:request
		completionHandler:(void(^)(id,id,id))
		^(NSURL *location, NSHTTPURLResponse *response, NSError *error){
			NSData *data = nil;
			if (location) data = [NSData dataWithContentsOfURL:location];
			callback(data, error, response.statusCode);
		}
	];
	[task resume];
}

void MDInitializeCore(void) {
	NSString *str = NSBundle.mainBundle.bundleIdentifier;
	fieldArray = @[@"name", @"description", @"package", @"version", @"depiction"];
	if ([str isEqualToString:@(CYDIA_BUNDLE_ID)]) {
		MDCurrentPackageManager = MDPackageManagerCydia;
	}
	else if ([str isEqualToString:@(ZEBRA_BUNDLE_ID)]) {
		MDCurrentPackageManager = MDPackageManagerZebra;
	}
	else {
		[NSException
			raise:NSInternalInconsistencyException
			format:@"ModernDepictions was initialized in an unsupported application."
		];
	}
}