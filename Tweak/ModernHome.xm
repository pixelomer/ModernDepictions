#import <UIKit/UIKit.h>
#import <Headers/Headers.h>
#import <ModernDepictions/ModernHome/ModernHomeController.h>
#import <ModernDepictions/ModernHome/FeaturedBannersView.h>
#import "Tweak.h"

@interface HomeController : CyteViewController
@end

static void _logos_method$ModernHome$Shared$didSelectPackage$(UIViewController *self, SEL _cmd, NSString *packageID) {
	Package *package = [[%c(Database) sharedInstance] packageWithName:packageID];
	NSLog(@"Did select: %@", package);
	Cydia *delegate = (id)UIApplication.sharedApplication;
	CYPackageController *pvc = (id)[delegate
		pageForPackage:[package id]
		withReferrer:ModernDepictionsGeneratePackageURL([package id])
	];
	pvc.delegate = delegate;
	[self.navigationController pushViewController:pvc animated:YES];
}

%group ModernHome
%hook Cydia

- (__kindof UIViewController *)pageForURL:(NSURL *)url forExternal:(BOOL)external withReferrer:(id)referrer {
	NSLog(@"pageForURL:\"%@\" forExternal:%d withReferrer:\"%@\"", url, external, referrer);
	if ([[url absoluteString] isEqualToString:@"cydia://home"]) return [ModernHomeController new];
	return %orig;
}

%end
%end

%group SectionsControllerFeaturedPackages

@interface SectionsController : UITableViewController
@property (nonatomic, strong) FeaturedBannersView *bannersView;
@end

%hook SectionsController
%property (nonatomic, strong) FeaturedBannersView *bannersView;

- (SectionsController *)initWithDatabase:(Database *)db source:(Source *)src {
	%orig;
	NSString *srcRawRootURI = src.rooturi;
	NSURL *srcRootURI = srcRawRootURI ? [NSURL URLWithString:srcRawRootURI] : nil;
	if (srcRootURI) {
		NSDictionary *cachedRepo = [[NSUserDefaults standardUserDefaults] objectForKey:@"ModernDepictionsCachedFeaturedPackages"][srcRootURI.absoluteString];
		NSString *itemSize = cachedRepo[@"itemSize"];
		NSArray *banners = cachedRepo[@"banners"];
		// cachedRepo has to be non-null for its values to be non-null, no need to check if cachedRepo is valid
		if (banners && itemSize) {
			CGSize itemSizeStruct = CGSizeFromString(itemSize);
			self.bannersView = [[FeaturedBannersView alloc] initWithPackages:banners bannerLimit:100 bannerSize:&itemSizeStruct];
		}
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger orig = %orig;
	return orig + (section == 0 && self.bannersView);
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.bannersView) {
		if (indexPath.row == 0 && indexPath.section == 0) return self.bannersView;
		else return %orig(tableView, [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section]);
	}
	return %orig;
}

%new
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.bannersView && indexPath.row == 0 && indexPath.section == 0) return self.bannersView.height;
	else return UITableViewAutomaticDimension;
}

%end
%end


void ModernDepictionsInitializeHome(void) {
	class_addMethod(
		objc_getClass("ModernHomeController"),
		@selector(didSelectPackage:),
		(IMP)_logos_method$ModernHome$Shared$didSelectPackage$,
		"v@:@"
	);
	%init(ModernHome);
	if (ModernDepictionsGetPreferenceValue(@"EnableFeaturedPackagesInSectionController", 1)) {
		class_addMethod(
			objc_getClass("SectionsController"),
			@selector(didSelectPackage:),
			(IMP)_logos_method$ModernHome$Shared$didSelectPackage$,
			"v@:@"
		);
		%init(SectionsControllerFeaturedPackages);
	}
}