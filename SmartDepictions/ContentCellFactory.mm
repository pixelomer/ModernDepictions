#import "ContentCellFactory.h"
#import "DepictionBaseView.h"
#import "DepictionScreenshotsView.h"
#import "SmartErrorCell.h"
#import "../Extensions/UIDevice+isiPad.h"

@implementation ContentCellFactory

+ (NSArray<__kindof DepictionBaseView *> *)createCellsFromArray:(NSArray<NSDictionary<NSString *, id> *> *)sourceArray
	delegate:(SmartDepictionDelegate *)delegate
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
			cell = [[SmartErrorCell alloc] initWithErrorMessage:[NSString stringWithFormat:@"(?) %@", cellInfo[@"class"]]];
		#else
			break;
		#endif
			else if (![cellClass isSubclassOfClass:[DepictionBaseView class]])
		#if DEBUG
			cell = [[SmartErrorCell alloc] initWithErrorMessage:[NSString stringWithFormat:@"(!) %@", cellInfo[@"class"]]];
			if (!cell) {
		#else
			break;
		#endif
			cell = [(DepictionBaseView *)[cellClass alloc]
				initWithDepictionDelegate:delegate
				reuseIdentifier:[NSString stringWithFormat:@"%@%d", reuseIdentifierPrefix, i++]
			];
			if (cellClass == [DepictionScreenshotsView class]) {
				if (UIDevice.currentDevice.isiPad && cellInfo[@"ipad"]) cellInfo = cellInfo[@"ipad"];
				else if (!UIDevice.currentDevice.isiPad && cellInfo[@"iphone"]) cellInfo = cellInfo[@"iphone"];
			}
			for (NSString *propertyKey in cellInfo) {
				if ([propertyKey isEqualToString:@"class"] || ![cell respondsToSelector:NSSelectorFromString(propertyKey)]) continue;
				id property = cellInfo[propertyKey];
				[cell setValue:property forKey:propertyKey];
			}
		#if DEBUG
			}
		#endif
			cell.selectionStyle = [cell respondsToSelector:@selector(didSelectCell)] ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
			[mutableResult addObject:cell];
			break;
		}
	}
	NSArray *result = [mutableResult copy];
	mutableResult = nil;
	return result;
}

+ (NSDictionary<NSString *, NSArray<__kindof DepictionBaseView *> *> *)createCellsFromTabArray:(NSArray<NSDictionary<NSString *, id> *> *)tabArray
	delegate:(SmartDepictionDelegate *)delegate
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