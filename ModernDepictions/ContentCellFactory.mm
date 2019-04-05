#import "ContentCellFactory.h"
#import "DepictionBaseView.h"
#import "DepictionScreenshotsView.h"
#import "ModernErrorCell.h"
#import <Extensions/UIDevice+isiPad.h>
#import <Extensions/UIColor+HexString.h>

@implementation ContentCellFactory

+ (NSArray<__kindof DepictionBaseView *> *)createCellsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)sourceArray
	delegate:(ModernDepictionDelegate *)delegate
	reuseIdentifierPrefix:(NSString *)reuseIdentifierPrefix
{
	if (!sourceArray) return nil;
	else if ([sourceArray count] <= 0) return [NSArray new];
	NSMutableArray *mutableResult = [[NSMutableArray alloc] initWithCapacity:sourceArray.count];
	unsigned int i = 0;
	for	(NSDictionary *rootCellInfo in sourceArray) {
		NSDictionary *cellInfo = rootCellInfo;
		while (true) {
			Class cellClass;
			if (!cellInfo[@"class"] ||
				![cellInfo[@"class"] isKindOfClass:[NSString class]]
			) break;
			DepictionBaseView *cell = NULL;
			if (!(cellClass = NSClassFromString(cellInfo[@"class"])))
		#if DEBUG
			cell = [[ModernErrorCell alloc] initWithErrorMessage:[NSString stringWithFormat:@"(?) %@", cellInfo[@"class"]]];
		#else
			break;
		#endif
			else if (![cellClass isSubclassOfClass:[DepictionBaseView class]])
		#if DEBUG
			cell = [[ModernErrorCell alloc] initWithErrorMessage:[NSString stringWithFormat:@"(!) %@", cellInfo[@"class"]]];
			if (!cell) {
		#else
			break;
		#endif
			cell = [(DepictionBaseView *)[cellClass alloc]
				initWithDepictionDelegate:delegate
				reuseIdentifier:[NSString stringWithFormat:@"%@%d", reuseIdentifierPrefix, i++]
			];
			if (!cell) break;
			if (cellClass == [DepictionScreenshotsView class]) {
				if (UIDevice.currentDevice.isiPad && cellInfo[@"ipad"]) cellInfo = cellInfo[@"ipad"];
				else if (!UIDevice.currentDevice.isiPad && cellInfo[@"iphone"]) cellInfo = cellInfo[@"iphone"];
				if (!([cellInfo[@"class"] isEqualToString:@"DepictionScreenshotsView"] ||
					[cellInfo[@"class"] isEqualToString:@"DepictionScreenshotView"])
				) continue;
			}
			for (NSString *propertyKey in cellInfo) {
				if ([propertyKey isEqualToString:@"class"] || ![cell respondsToSelector:NSSelectorFromString(propertyKey)]) continue;
				__kindof NSObject<NSCopying> *property = cellInfo[propertyKey];
				// A JSON value can be null.
				if (![property isKindOfClass:[NSNull class]]) {
					@try {
						[cell setValue:property forKey:propertyKey];
					}
#define cNSLog(args...) NSLog(@"[ContentCellFactory] "args)
					@catch (NSException *ex) {
						cNSLog(@"Failed to set \"%@\" for the following key: \"%@\"", property, propertyKey);
						cNSLog(@"Exception: %@", ex);
						if ([property isKindOfClass:[NSString class]] && [ex.name isEqualToString:NSInvalidArgumentException]) {
							property = [UIColor colorWithHexString:property];
							cNSLog(@"Retrying with value: %@", property);
							[cell setValue:property forKey:propertyKey];
						}
						else {
							cNSLog(@"Unable to convert an object with a type of \"%@\" to a color", NSStringFromClass(property.class));
							@throw ex;
						}
					}
#undef cNSLog
				}
			}
		#if DEBUG
			}
		#endif
			cell.selectionStyle = [cell respondsToSelector:@selector(didGetSelected)] ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
			[mutableResult addObject:cell];
			break;
		}
	}
	NSArray *result = [mutableResult copy];
	mutableResult = nil;
	return result;
}

+ (NSDictionary<NSString *, NSArray<__kindof DepictionBaseView *> *> *)createCellsFromTabArray:(NSArray<NSDictionary<NSString *, id> *> *)tabArray
	delegate:(ModernDepictionDelegate *)delegate
{
	if (!tabArray || !delegate) return nil;
	NSMutableDictionary *mutableResult = [[NSMutableDictionary alloc] initWithCapacity:tabArray.count];
	for (NSDictionary *tab in tabArray) {
		id tabName = tab[@"tabname"];
		id views = tab[@"views"];
		if (!tabName || !views || ![tabName isKindOfClass:[NSString class]]) continue;
		NSArray *tabCells = [self createCellsFromArray:views delegate:delegate reuseIdentifierPrefix:tabName];
		if (tabCells) [mutableResult setObject:tabCells forKey:tabName];
	}
	NSDictionary *result = [mutableResult copy];
	mutableResult = nil;
	return result;
}

@end