#import "DepictionTab.h"
#import "../Headers/Localize.h"

@implementation DepictionTab

- (void)setTabName:(NSString *)newName {
	_tabName = newName;
	[self setTitle:UCLocalize(newName) forState:UIControlStateNormal];
}

@end