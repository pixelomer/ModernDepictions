#import <UIKit/UIKit.h>

@interface MDStackView : UIView {
	NSMutableArray<UIView *> *views;
	NSArray<NSLayoutConstraint *> *currentConstraints;
}
- (UIView *)viewAtIndex:(NSUInteger)index;
- (void)insertView:(UIView *)view atIndex:(NSUInteger)index;
- (void)removeViewAtIndex:(NSUInteger)index;
- (void)removeAllViews;
- (void)insertView:(UIView *)view;
@end