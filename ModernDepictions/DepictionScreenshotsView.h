#import "DepictionBaseView.h"

@interface DepictionScreenshotsView : DepictionBaseView {
	CGFloat _height;
	UIView *_screenshotsView;
	NSMutableArray<UIImageView *> *_imageViews;
	NSMutableArray<NSLayoutConstraint *> *currentConstraints;
	CGSize itemSizeStruct;
}
@property (nonatomic, retain, setter=setScreenshots:) NSArray *screenshots;
@property (nonatomic, assign, setter=setItemCornerRadius:) CGFloat itemCornerRadius;
@property (nonatomic, retain, setter=setItemSize:) NSString *itemSize;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setItemCornerRadius:(CGFloat)newRadius;
- (void)setScreenshots:(NSArray *)newScreenshots;
@end