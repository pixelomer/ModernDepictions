#import <UIKit/UIKit.h>

@class SmartDepictionDelegate;
@class DepictionBaseView;

NS_ROOT_CLASS
@interface ContentCellFactory
+ (NSArray<__kindof DepictionBaseView *> *)createCellsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)sourceArray
	delegate:(SmartDepictionDelegate *)delegate
	reuseIdentifierPrefix:(NSString *)reuseIdentifierPrefix;
+ (NSDictionary<NSString *, NSArray<__kindof DepictionBaseView *> *> *)createCellsFromTabArray:(NSArray<NSDictionary<NSString *, id> *> *)tabArray
	delegate:(SmartDepictionDelegate *)delegate;
@end