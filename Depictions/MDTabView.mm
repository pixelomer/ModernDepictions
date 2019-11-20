#import "MDTabView.h"
#import "MDSileoDepictionStackView.h"

@implementation MDTabView

- (void)setTabs:(NSArray *)tabs {
	if (!tabs.count) return;
	_tabs = tabs;
	for (UIView *view in _buttons) {
		[view removeFromSuperview];
	}
	NSMutableArray *newButtons = [NSMutableArray new];
	for (NSUInteger i=0; i<tabs.count; i++) {
		MDSileoDepictionStackView *stackView = tabs[i];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
		[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[button setTitle:stackView.depictionTabname forState:UIControlStateNormal];
		button.translatesAutoresizingMaskIntoConstraints = NO;
		[newButtons addObject:button];
		[self addSubview:button];
		CGFloat leadingMultiplier = ((CGFloat)i / (CGFloat)tabs.count);
		[self addConstraints:@[
			[NSLayoutConstraint
				constraintWithItem:button
				attribute:NSLayoutAttributeLeading
				relatedBy:NSLayoutRelationEqual
				toItem:self
				attribute:(leadingMultiplier ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
				multiplier:(leadingMultiplier ?: 1.0)
				constant:0.0
			],
			[NSLayoutConstraint
				constraintWithItem:button
				attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual
				toItem:self
				attribute:NSLayoutAttributeWidth
				multiplier:(1.0 / (CGFloat)tabs.count)
				constant:0.0
			],
			[NSLayoutConstraint
				constraintWithItem:button
				attribute:NSLayoutAttributeTop
				relatedBy:NSLayoutRelationEqual
				toItem:self
				attribute:NSLayoutAttributeTop
				multiplier:1.0
				constant:0.0
			],
			[NSLayoutConstraint
				constraintWithItem:button
				attribute:NSLayoutAttributeBottom
				relatedBy:NSLayoutRelationEqual
				toItem:self
				attribute:NSLayoutAttributeBottom
				multiplier:1.0
				constant:-3.0
			],
			[NSLayoutConstraint
				constraintWithItem:button
				attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual
				toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute
				multiplier:1.0
				constant:40.0
			]
		]];
	}
	_buttons = newButtons.copy;
}

- (instancetype)init {
	if (self = [super init]) {
		_selectionIndicator = [UIView new];
		_selectionIndicator.backgroundColor = [UIColor redColor];
		_selectionIndicator.translatesAutoresizingMaskIntoConstraints = NO;
		UIView *separatorView = [UIView new];
		separatorView.backgroundColor = [UIColor grayColor];
		separatorView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_selectionIndicator];
		[self addSubview:separatorView];
		NSDictionary *views = @{ @"indicator" : _selectionIndicator, @"separator" : separatorView };
		[self addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:[indicator(2)][separator(1)]|"
			options:0
			metrics:nil
			views:views
		]];
		[self addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[separator]|"
			options:0
			metrics:nil
			views:views
		]];
	}
	return self;
}

@end