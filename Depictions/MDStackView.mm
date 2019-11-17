#import "MDStackView.h"

@implementation MDStackView

+ (instancetype)alloc {
	NSMutableArray *views = [NSMutableArray new];
	MDStackView *stackView;
	if (!views || !(stackView = [super alloc])) return nil;
	stackView->_views = views;
	return stackView;
}

- (UIView *)viewAtIndex:(NSUInteger)index {
	return _views[index];
}

- (void)insertView:(UIView *)view {
	[_views addObject:view];
	[self resetConstraints];
}

- (void)resetConstraints {
	self.translatesAutoresizingMaskIntoConstraints = NO;
	if (_currentConstraints) {
		[self removeConstraints:_currentConstraints];
	}
	if (!_views.count) return;
	NSMutableArray *newConstraints = [NSMutableArray new];
	UIView *previousView = nil;
	for (UIView *view in _views) {
		if (![view isKindOfClass:[UIView class]]) {
			[NSException raise:NSInvalidArgumentException format:@"Object isn't a view: %@", view];
		}
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
			[NSString stringWithFormat:@"V:[prev]-(%f)-[current]", _spacing] :
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
	_currentConstraints = newConstraints.copy;
	[self addConstraints:newConstraints];
}

- (void)insertView:(UIView *)view atIndex:(NSUInteger)index {
	[_views insertObject:view atIndex:index];
	[self resetConstraints];
}

- (void)removeViewAtIndex:(NSUInteger)index {
	[_views[index] removeFromSuperview];
	[_views removeObjectAtIndex:index];
	[self resetConstraints];
}

- (void)removeAllViews {
	[_views removeAllObjects];
	[self resetConstraints];
}

- (void)setViews:(NSArray *)views {
	_views = views.mutableCopy;
	[self resetConstraints];
}

- (void)setSpacing:(CGFloat)spacing {
	_spacing = spacing;
	[self resetConstraints];
}

- (NSArray *)views {
	return [_views copy];
}

@end