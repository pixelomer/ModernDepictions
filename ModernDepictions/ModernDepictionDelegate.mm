#import "ModernDepictionDelegate.h"
#import "DepictionRootView.h"
#import "ModernPackageController.h"
#import "GetPackageCell.h"
#import "DepictionImageView.h"
#import "DepictionStackView.h"
#import "../Extensions/UIColor+HexString.h"

@implementation ModernDepictionDelegate

NSArray *resizableCellClasses;
UIColor *defaultTintColor;

+ (UIColor *)defaultTintColor {
	return defaultTintColor;
}

+ (void)initialize {
	if ([self class] == [ModernDepictionDelegate class]) {
		resizableCellClasses = @[
			[DepictionImageView class],
			[DepictionStackView class]
		];
		defaultTintColor = [UIColor colorWithRed:0.173 green:0.694 blue:0.745 alpha:1.0];
	}
}

- (void)updateCells {
	[self.packageController.depictionRootView beginUpdates];
	[self.packageController.depictionRootView endUpdates];
}

- (void)handleRotation {
	[self updateCells];
}

- (NSString *)modificationButtonTitle {
	return modificationButtonTitle;
}

- (void)setModificationButtonTitle:(NSString *)newTitle {
	modificationButtonTitle = newTitle;
	self.packageController.depictionRootView.getPackageCell.buttonTitle = newTitle;
}

- (instancetype)initWithPackageController:(ModernPackageController *)packageController
	depictionURL:(NSURL *)depictionURL
	database:(Database *)database
	packageID:(NSString *)packageID
{
	self = [super init];
	_tintColor = self.class.defaultTintColor;
	_packageController = packageController;
	_packageID = packageID;
	_depictionURL = depictionURL;
	_operationQueue = [[NSOperationQueue alloc] init];
	if (@available(iOS 7.0, *)) _iOS6 = false;
	else _iOS6 = true;
	[self setPackageWithID:packageID database:database];
	return self;
}

#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
#pragma GCC diagnostic push

- (void)handleModifyButton {
	if ([_modificationButtons isKindOfClass:[NSNull class]]) {
		UIAlertController *alert = [UIAlertController
			alertControllerWithTitle:UCLocalize(@"Warning")
			message:UCLocalize(@"Since ModernDepictions doesn't support Sileo's payment API, you'll now be forwarded to the original depiction where you can pay for the package.")
			preferredStyle:UIAlertControllerStyleAlert
		];
		UIAlertAction *action = [UIAlertAction actionWithTitle:UCLocalize(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction *sender){
			CYPackageController *legacyVC = [objc_getClass("CYPackageController") alloc];
			self.originalInvocation.target = legacyVC;
			NSString *packageID = self.package.id;
			[self.originalInvocation setArgument:&packageID atIndex:3];
			[self.originalInvocation setArgument:&_referrer atIndex:4];
			for (int i = 2; i < self.originalInvocation.methodSignature.numberOfArguments; i++) {
				id object = nil;
				[self.originalInvocation getArgument:&object atIndex:i];
				NSLog(@"Argument %d: %@", i, object);
			}
			[self.originalInvocation invoke];
			[self.originalInvocation getReturnValue:&legacyVC];
			NSAssert(legacyVC, @"Failed to initialize the legacy view controller.");
			legacyVC.delegate = self.cydiaDelegate;
			[self.packageController.navigationController pushViewController:legacyVC animated:YES];
		}];
		[alert addAction:action];
		[self.packageController presentViewController:alert animated:YES completion:nil];
		return;
	}
	else if (_modificationButtons.count == 1) {
		[_cydiaDelegate performSelector:NSSelectorFromString(_modificationButtons.allValues[0]) withObject:_package];
	}
	else if (_modificationButtons.count > 1) {
		UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
		for (NSString *buttonTitle in _modificationButtons) {
			UIAlertAction *action = [UIAlertAction actionWithTitle:UCLocalize(buttonTitle) style:UIAlertActionStyleDefault handler:^(UIAlertAction *sender){
				[_cydiaDelegate performSelector:NSSelectorFromString(_modificationButtons[buttonTitle]) withObject:_package];
			}];
			[actionSheet addAction:action];
		}
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:UCLocalize(@"CANCEL") style:UIAlertActionStyleCancel handler:nil];
		[actionSheet addAction:cancelAction];
		actionSheet.view.tintColor = self.class.defaultTintColor;
		[_packageController presentViewController:actionSheet animated:YES completion:^{
			actionSheet.view.tintColor = self.class.defaultTintColor;
		}];
	}
}

#pragma GCC diagnostic pop

- (void)downloadDepiction {
	if (!_depictionURL) return;
	[self downloadDataFromURL:_depictionURL completion:^(NSData *data, NSError *error){
		if (!data) return;
		_depiction = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		NSLog(@"Depiction: %@", _depiction);
		if ([_depiction isKindOfClass:[NSDictionary class]]) {
			NSLog(@"-[%@ loadDepiction]", self.packageController);
			if (_depiction[@"tintColor"]) {
				_tintColor = [UIColor colorWithHexString:_depiction[@"tintColor"]];
			}
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.packageController loadDepiction];
			});
		}
	}];
}

- (void)setPackageWithID:(NSString *)packageID database:(Database *)database {
	_database = database;
	_packageID = packageID;
	[self reloadData];
}

- (void)reloadData {
	NSLog(@"Reloading data");

	_package = [self.database packageWithName:self.packageID];
	[self.package parse];
	self.packageController.depictionRootView.getPackageCell.package = self.package;
	
	if ([_modificationButtons isKindOfClass:[NSNull class]]) return;

	NSMutableDictionary *modificationButtons = [[NSMutableDictionary alloc] init];
	if (self.package != nil) {
		/* (Re)installation/Upgrade actions */
		if ([self.package source] == nil);
		else if ([self.package upgradableAndEssential:NO]) modificationButtons[@"UPGRADE"] = @"installPackage:";
		else if ([self.package uninstalled]) modificationButtons[@"INSTALL"] = @"installPackage:";
		else modificationButtons[@"REINSTALL"] = @"installPackage:";
		/* End */

		/* Removal actions */
		if (![self.package uninstalled]) modificationButtons[@"REMOVE"] = @"removePackage:";
		if ([self.package mode] != nil) modificationButtons[@"CLEAR"] = @"clearPackage:";
		/* End */

		/* Downgrade actions */
		//if ([versions count] != 0) {
		//	[modificationButtons addObject:@"DOWNGRADE"];
		//}
		/* End */
	}
	switch ([modificationButtons count]) {
		case 0: modificationButtonTitle = nil; break;
		case 1: modificationButtonTitle = modificationButtons.allKeys[0]; break;
		default: modificationButtonTitle = @"MODIFY"; break;
	}
	self.packageController.depictionRootView.getPackageCell.buttonTitle = UCLocalize(modificationButtonTitle);
	_modificationButtons = [modificationButtons copy];

	[self.package retrievePaymentInformationWithCompletion:^(Package *package, NSError *error){
		NSString *price = package.paymentInformation[@"price"];
		// WARNING: atof can cause undefined behaviour
		if ([price isKindOfClass:[NSString class]] && !(atof([price UTF8String] + 1) <= 0.0)) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				self.packageController.depictionRootView.getPackageCell.buttonTitle = price;
				[self.packageController.depictionRootView.getPackageCell lockText];
				_modificationButtons = (id)[NSNull null];
			});
		}
	}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.packageController scrollViewDidScroll:scrollView];
}

- (void)downloadDataFromURL:(NSURL *)url completion:(void (^)(NSData *, NSError *))completionHandler {
	if (!url) return;
	@autoreleasepool {
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		NSLog(@"Asynchronously downloading data from URL: %@", url);
		[NSURLConnection sendAsynchronousRequest:request
			queue:self.operationQueue
			completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
				NSLog(@"Download completed for \"%@\" with error: %@", url, error);
			#if DEBUG
				if (data) {
					NSLog(@"String data (first 64 bytes): %@", [[NSString alloc] initWithBytes:data.bytes length:min(65, data.length) encoding:NSUTF8StringEncoding]);
					NSError *jsonError = nil;
					id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
					NSLog(@"JSON Error: %@, JSON: %@", jsonError, json);
				}
			#endif
				completionHandler(data, error);
			}
		];
	}
}

// Only allows NULL. Used to deallocate the package controller.
- (void)setPackageController:(ModernPackageController *)newPackageController {
	if (!newPackageController) _packageController = nil;
}

@end