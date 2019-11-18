#import <UIKit/UIKit.h>

@interface MDStackView : UIView {
	NSMutableArray<UIView *> *_views;
	NSArray<NSLayoutConstraint *> *_currentConstraints;
}
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, readonly) BOOL isUpdating;
- (UIView *)viewAtIndex:(NSUInteger)index;
- (void)insertView:(UIView *)view atIndex:(NSUInteger)index;
- (void)removeViewAtIndex:(NSUInteger)index;
- (void)removeAllViews;
- (void)insertView:(UIView *)view;
- (void)beginUpdates;
- (void)endUpdates;
- (void)setViews:(NSArray *)views;
- (NSArray *)views;
@end