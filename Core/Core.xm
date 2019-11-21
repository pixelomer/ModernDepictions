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

id MDGetAttribute(Package *package, MDPackageAttribute attr) {
	NSLog(@"[GetAttribute] Attribute: \"%ld\", Package: %@", (long)attr, package);
	if (!package) return nil;
	if (object_getClass(package) != MDGetClass(MDTargetPackage)) return nil;
	switch (attr) {
		case MDPackageAttributeIcon:
			switch (MDCurrentPackageManager) {
				case MDPackageManagerCydia:
					return [package icon];
				case MDPackageManagerZebra:
					return (
						[UIImage imageWithContentsOfFile:[(ZBPackage *)package iconPath]] ?:
						[UIImage imageNamed:[(ZBPackage *)package sectionImageName]]
					);
			}
	}
	return nil;
}

NSString *MDGetFieldFromPackage(Package *package, NSString *field) {
	NSLog(@"[GetField] Field: \"%@\", Package: %@", field, package);
	if (!package) return nil;
	if (object_getClass(package) != MDGetClass(MDTargetPackage)) return nil;
	id value = nil;
	switch (MDCurrentPackageManager) {
		case MDPackageManagerCydia:
			[package parse];
			value = [package getField:field];
			value = [value isKindOfClass:[NSString class]] ? value : nil;
			break;
		case MDPackageManagerZebra:
			switch ([fieldArray indexOfObject:field.lowercaseString]) {
				case 0: value = [package name]; break;
				case 1: value = [package longDescription]; break;
				case 2: value = [(ZBPackage *)package identifier]; break;
				case 3: value = [(ZBPackage *)package version]; break;
				case 4: value = [(ZBPackage *)package depictionURL].absoluteString; break;
				case 5: value = [(ZBPackage *)package author]; break;
				default: value = [package getField:field]; break;
			}
			break;
	}
	NSLog(@"[GetField] Returning \"%@\"...", value);
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
	fieldArray = @[@"name", @"description", @"package", @"version", @"depiction", @"author"];
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