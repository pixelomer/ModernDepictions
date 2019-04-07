#import <UIKit/UIKit.h>

@interface PackageListController : NSObject
- (UINavigationController *)navigationController;
- (NSURL *)referrerURL;
- (Package *)packageAtIndexPath:(NSIndexPath *)indexPath;
- (bool)isSummarized;
@end
