#import <UIKit/UIKit.h>
#import <Headers/Headers.h>

%group ModernCells
%hook PackageCell

// NOTE: The new object has to be a UITableViewCell and respond to setPackage:asSummary:
- (void *)init {
	return %orig;
}

%end
%end

void ModernDepictionsInitializeCells(void) {
	%init(ModernCells);
}