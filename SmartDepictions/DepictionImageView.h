#import "DepictionBaseView.h"

@interface DepictionImageView : DepictionBaseView {
	UIImageView *imageView;
	NSArray *paddingConstraints;
	NSArray *sizeConstraints;
	NSArray *alignmentConstraints;
	CGFloat ratio;
	CGFloat _height;
	CGFloat cellHeight;
	CGFloat imageWidth;
}
@property (nonatomic, retain, setter=setURL:) NSString *URL;
@property (nonatomic, assign, setter=setWidth:) CGFloat width;
@property (nonatomic, assign, getter=height, setter=setHeight:) CGFloat height;
@property (nonatomic, assign, setter=setCornerRadius:) CGFloat cornerRadius;
@property (nonatomic, assign, setter=setHorizontalPadding:) CGFloat horizontalPadding;
@property (nonatomic, assign, setter=setAlignment:) AlignEnum alignment;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setURL:(NSString *)URL;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setHorizontalPadding:(CGFloat)horizontalPadding;
- (void)setAlignment:(AlignEnum)alignment;
@end