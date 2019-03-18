#import <UIKit/UIKit.h>

@class SmartDepictionDelegate;
@class SmartContentCell;

NS_ROOT_CLASS
@interface ContentCellFactory
+ (NSArray<__kindof SmartContentCell *> *)createCellsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)sourceArray
	delegate:(SmartDepictionDelegate *)delegate
	reuseIdentifierPrefix:(NSString *)reuseIdentifierPrefix;
+ (NSDictionary<NSString *, NSArray<__kindof SmartContentCell *> *> *)createCellsFromTabArray:(NSArray<NSDictionary<NSString *, id> *> *)tabArray
	delegate:(SmartDepictionDelegate *)delegate;
@end