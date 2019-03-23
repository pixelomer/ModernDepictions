#import "SmartContentCell.h"

@class GADBannerView;

@interface DepictionAdmobView : SmartContentCell {
	GADBannerView *banner;
}
@property (nonatomic, retain, setter=setAdSize:) NSString *adSize;
@property (nonatomic, retain, setter=setAdUnitID:) NSString *adUnitID;
- (void)setAdUnitID:(NSString *)adUnitID;
- (void)setAdSize:(NSString *)adSize;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end