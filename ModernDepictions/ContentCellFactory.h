#import <UIKit/UIKit.h>

@class ModernDepictionDelegate;
@class DepictionBaseView;

NS_ROOT_CLASS
@interface ContentCellFactory
+ (NSArray<__kindof DepictionBaseView *> *)createCellsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)sourceArray
	delegate:(ModernDepictionDelegate *)delegate
	reuseIdentifierPrefix:(NSString *)reuseIdentifierPrefix;
+ (NSDictionary<NSString *, NSArray<__kindof DepictionBaseView *> *> *)createCellsFromTabArray:(NSArray<NSDictionary<NSString *, id> *> *)tabArray
	delegate:(ModernDepictionDelegate *)delegate;
@end