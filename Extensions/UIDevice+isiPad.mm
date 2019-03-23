#import "UIDevice+isiPad.h"

@implementation UIDevice(isiPad)

- (bool)isiPad {
    return (
        [self respondsToSelector:@selector(userInterfaceIdiom)] &&
		[self userInterfaceIdiom] == UIUserInterfaceIdiomPad
    );
}

@end