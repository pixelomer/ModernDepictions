#import "MDStackView.h"

@implementation MDStackView

+ (instancetype)alloc {
	NSMutableArray *views = [NSMutableArray new];
	MDStackView *stackView;
	if (!views || !(stackView = [super alloc])) return nil;
	stackView->views = views;
	return stackView;
}

- (UIView *)viewAtIndex:(NSUInteger)index {
	return views[index];
}

- (void)insertView:(UIView *)view {
	[views addObject:view];
	[self resetConstraints];
}

- (void)resetConstraints {
	self.translatesAutoresizingMaskIntoConstraints = NO;
	if (currentConstraints) {
		[self removeConstraints:currentConstraints];
	}
	if (!views.count) return;
	NSMutableArray *newConstraints = [NSMutableArray new];
	UIView *previousView = nil;
	for (UIView *view in views) {
		if (view.superview != self) {
			[view removeFromSuperview];
			view.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:view];
		}
		NSDictionary *constraintViews = (
			previousView ?
			@{ @"prev" : previousView, @"current" : view } :
			@{ @"current" : view }
		);
		NSString *format = (
			previousView ?
			@"V:[prev][current]" :
			@"V:|[current]"
		);
		[newConstraints addObjectsFromArray:[NSLayoutConstraint
			constraintsWithVisualFormat:format
			options:0
			metrics:nil
			views:constraintViews
		]];
		[newConstraints addObjectsFromArray:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[current]|"
			options:0
			metrics:nil
			views:constraintViews
		]];
		previousView = view;
	}
	[newConstraints addObject:[NSLayoutConstraint
		constraintWithItem:previousView
		attribute:NSLayoutAttributeBottom
		relatedBy:NSLayoutRelationLessThanOrEqual
		toItem:self
		attribute:NSLayoutAttributeBottom
		multiplier:1.0
		constant:0.0
	]];
	currentConstraints = newConstraints.copy;
	[self addConstraints:newConstraints];
}

- (void)insertView:(UIView *)view atIndex:(NSUInteger)index {
	[views insertObject:view atIndex:index];
	[self resetConstraints];
}

- (void)removeViewAtIndex:(NSUInteger)index {
	[views[index] removeFromSuperview];
	[views removeObjectAtIndex:index];
	[self resetConstraints];
}

- (void)removeAllViews {
	[views removeAllObjects];
	[self resetConstraints];
}

@end