#import "DepictionTabView.h"
#import "DepictionTab.h"

@implementation DepictionTabView

- (CGFloat)height {
	return 37.0;
}

- (instancetype _Nullable)initWithDelegate:(__kindof NSObject<DepictionTabViewDelegate> * _Nullable)delegate reuseIdentifier:(NSString * _Nonnull)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	_tabViewDelegate = delegate;
	underline = [[UIView alloc] init];
	underline.backgroundColor = [UIColor blueColor];
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
- (NSString *)currentTab {
	if (!currentTabNames || [currentTabNames count] <= 0) return nil;
	return currentTab ?: currentTabNames[0];
}

- (void)setTabs:(NSArray *)tabs {
	NSLog(@"Setting tabs to %@ for %@", tabs, self.description);
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
		[tab setTitle:tabName forState:UIControlStateNormal];
		[tab setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[tab sizeToFit];
		[self.contentView addSubview:tab];
		if (i > 0) {
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
			NSDictionary *views = @{ @"tab" : tab };
			[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[tab]|"
				options:0
				metrics:nil
				views:views
			]];
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
	NSString *newTab = sender.currentTitle;
	if (!newTab || ![currentTabNames containsObject:newTab]) return;
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