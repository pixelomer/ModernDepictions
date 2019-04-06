#import "DepictionTabView.h"
#import "DepictionTab.h"
#import "ModernDepictionDelegate.h"

static UIColor *notHighlightedColor;

@implementation DepictionTabView

- (CGFloat)height {
	return 37.0;
}

+ (void)initialize {
	if (self == [DepictionTabView self]) {
		notHighlightedColor = [UIColor colorWithRed:0.586 green:0.557 blue:0.502 alpha:1.0];
	}
}

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	selectedIndex = 0;
	underline = [[UIView alloc] init];
	underline.backgroundColor = self.depictionDelegate.tintColor;
	UIView *separatorView = [[UIView alloc] init];
	separatorView.translatesAutoresizingMaskIntoConstraints = NO;
	separatorView.backgroundColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.925 alpha:1.0];
	[self.contentView addSubview:separatorView];
	NSDictionary *views = @{ @"separator" : separatorView };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:[separator(==1)]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[separator]|"
		options:0
		metrics:nil
		views:views
	]];
	underline.translatesAutoresizingMaskIntoConstraints = NO;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
	self.contentView.frame = self.frame;
	return self;
}

- (void)setDepictionTintColor:(UIColor *)newTintColor {
	[currentTabs[selectedIndex] setTitleColor:newTintColor forState:UIControlStateNormal];
	underline.backgroundColor = newTintColor;
	[underline setNeedsDisplay];
}

- (NSString *)currentTab {
	if (!currentTabNames || [currentTabNames count] <= 0) return nil;
	return currentTab ?: currentTabNames[0];
}

- (void)setTabs:(NSArray *)tabs {
	NSLog(@"Setting tabs to %@ for %@", tabs, self.description);
	selectedIndex = 0;
	if (lineConstraints) {
		[self.contentView removeConstraints:lineConstraints];
		lineConstraints = nil;
	}
	currentTabNames = [[NSMutableArray alloc] init];
	for (NSDictionary *tabDict in tabs) {
		NSString *tabName = tabDict[@"tabname"];
		id views = tabDict[@"views"];
		if (!tabName || !views || ![views isKindOfClass:[NSArray class]] || [(NSArray *)views count] < 1) continue;
		[currentTabNames addObject:tabName];
	}
	if (currentTabs) {
		for (DepictionTab *tab in currentTabs) [tab removeFromSuperview];
	}
	currentTabs = [[NSMutableArray alloc] init];
	for (int i = 0, count = [currentTabNames count]; i < count; i++) {
		NSString *tabName = currentTabNames[i];
		DepictionTab *tab = [[DepictionTab alloc] init];
		tab.translatesAutoresizingMaskIntoConstraints = NO;
		tab.tabName = tabName;
		[tab setTitleColor:notHighlightedColor forState:UIControlStateNormal];
		[tab sizeToFit];
		[self.contentView addSubview:tab];
		NSDictionary *views = @{ @"tab" : tab };
		if (i) {
			[self.contentView addConstraints:@[
				[NSLayoutConstraint
					constraintWithItem:tab
					attribute:NSLayoutAttributeWidth
					relatedBy:NSLayoutRelationEqual
					toItem:currentTabs[0]
					attribute:NSLayoutAttributeWidth
					multiplier:1.0
					constant:0.0
				],
				[NSLayoutConstraint
					constraintWithItem:tab
					attribute:NSLayoutAttributeHeight
					relatedBy:NSLayoutRelationEqual
					toItem:currentTabs[0]
					attribute:NSLayoutAttributeHeight
					multiplier:1.0
					constant:0.0
				],
				[NSLayoutConstraint
					constraintWithItem:tab
					attribute:NSLayoutAttributeLeading
					relatedBy:NSLayoutRelationEqual
					toItem:currentTabs[i - 1]
					attribute:NSLayoutAttributeTrailing
					multiplier:1.0
					constant:0.0
				]
			]];
		}
		else {
			[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[tab]"
				options:0
				metrics:nil
				views:views
			]];
			[self.contentView addConstraint:[NSLayoutConstraint
				constraintWithItem:tab
				attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual
				toItem:self.contentView
				attribute:NSLayoutAttributeWidth
				multiplier:(1.0 / count)
				constant:0.0
			]];
		}
		[self.contentView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[tab]|"
			options:0
			metrics:nil
			views:views
		]];
		[tab addTarget:self action:@selector(didSelectTab:) forControlEvents:UIControlEventTouchUpInside];
		[currentTabs addObject:tab];
	}
	if (currentTabs.count > 0) {
		[self.contentView addSubview:underline];
		[self.contentView addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:[line(==2)]|"
			options:0
			metrics:nil
			views:@{ @"line" : underline }
		]];
		[self didSelectTab:currentTabs[0]];
	}
	else if ([self.contentView.subviews containsObject:underline]) {
		[underline removeFromSuperview];
	}
	_tabs = tabs;
}

- (void)didSelectTab:(DepictionTab *)sender {
	NSString *newTab = sender.tabName;
	NSUInteger newIndex = [currentTabs indexOfObjectIdenticalTo:sender];
	if (!newTab || ![currentTabNames containsObject:newTab] || newIndex == NSNotFound) return;
	[currentTabs[selectedIndex] setTitleColor:notHighlightedColor forState:UIControlStateNormal];
	selectedIndex = newIndex;
	[currentTabs[selectedIndex] setTitleColor:self.depictionDelegate.tintColor forState:UIControlStateNormal];
	bool shouldNotifyDelegate = (currentTab && ![newTab isEqualToString:currentTab]) || (!currentTab && ![newTab isEqualToString:currentTabNames[0]]);
	currentTab = newTab;
	if (shouldNotifyDelegate && self.tabViewDelegate && [self.tabViewDelegate respondsToSelector:@selector(didSelectTabNamed:)]) {
		[self.tabViewDelegate didSelectTabNamed:currentTab];
	}
	[self layoutIfNeeded];
	CGFloat duration = 0.0;
	if (lineConstraints) {
		[self.contentView removeConstraints:lineConstraints];
		duration = 0.25;
	}
	[UIView animateWithDuration:duration animations:^{
		lineConstraints = @[
			[NSLayoutConstraint
				constraintWithItem:underline
				attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual
				toItem:sender.titleLabel
				attribute:NSLayoutAttributeWidth
				multiplier:1.0
				constant:0.0
			],
			[NSLayoutConstraint
				constraintWithItem:underline
				attribute:NSLayoutAttributeTrailing
				relatedBy:NSLayoutRelationEqual
				toItem:sender.titleLabel
				attribute:NSLayoutAttributeTrailing
				multiplier:1.0
				constant:0.0
			]
		];
		[self.contentView addConstraints:lineConstraints];
		[self layoutIfNeeded];
	}];
}

@end