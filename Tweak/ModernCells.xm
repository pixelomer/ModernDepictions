#import <dlfcn.h>
#import <UIKit/UIKit.h>
#import <Headers/Headers.h>
#import <ModernDepictions/Shared/ModernPackageCell.h>

%group ModernCells

#define database_ (MSHookIvar<Database *>(UIApplication.sharedApplication, "database_"))
%hook PackageListController

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)path {
	ModernPackageCell *cell = [table dequeueReusableCellWithIdentifier:@"Package"];
	if (!cell) cell = [[ModernPackageCell alloc] initWithReuseIdentifier:@"Package"];
	Package *package = [database_ packageWithName:[[self packageAtIndexPath:path] id]];
	[cell setPackage:package];
	return cell;
}

%end

%hook SearchController

- (bool)isSummarized {
	return false;
}

%end
#undef database_

%end

void ModernDepictionsInitializeCells(void) {
	void *celldiaHandle = dlopen("/Library/MobileSubstrate/DynamicLibraries/CellDia.dylib", RTLD_NOLOAD);
	if (celldiaHandle) {
		dlclose(celldiaHandle);
		return;
	}
	%init(ModernCells);
}