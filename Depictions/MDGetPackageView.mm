#import "MDGetPackageView.h"

@implementation MDGetPackageView

- (void)setPackage:(id)package {
	_package = package;
	_authorLabel.text = [MDGetFieldFromPackage(package, @"author") componentsSeparatedByString:@"<"].firstObject;
	_nameLabel.text = (
		MDGetFieldFromPackage(package, @"name") ?:
		MDGetFieldFromPackage(package, @"package") ?:
		@"(unnamed)"
	);
	_iconView.image = MDGetAttribute(package, MDPackageAttributeIcon);
	self.buttonText = @"MODIFY";
	[_iconView setNeedsDisplay];
}

- (void)setButtonText:(NSString *)text {
	_buttonText = text;
	[_button setTitle:text forState:UIControlStateNormal];
}

- (instancetype)init {
	if ((self = [super init])) {
		_iconView = [UIImageView new];
		_iconView.layer.masksToBounds = YES;
		_iconView.layer.cornerRadius = 15.0;
		_iconView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		_labelContainer = [UIView new];
		_authorLabel = [UILabel new];
		_authorLabel.textAlignment = NSTextAlignmentNatural;
		_nameLabel = [UILabel new];
		_nameLabel.font = [UIFont boldSystemFontOfSize:20];
		_nameLabel.textAlignment = NSTextAlignmentNatural;
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		_button.backgroundColor = [UIColor redColor];
		_button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
		_button.layer.masksToBounds = YES;
		_button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 16.0, 5.0, 16.0);
		_button.layer.cornerRadius = 16.0;
		[_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		NSDictionary<NSString *, UIView *> *views = @{
			@"button" : _button,
			@"name" : _nameLabel,
			@"author" : _authorLabel,
			@"labels" : _labelContainer,
			@"icon" : _iconView
		};
		for (NSString *key in views) {
			views[key].translatesAutoresizingMaskIntoConstraints = NO;
		}
		[_labelContainer addSubview:_authorLabel];
		[_labelContainer addSubview:_nameLabel];
		[self addSubview:_iconView];
		[self addSubview:_labelContainer];
		[self addSubview:_button];
		[self addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|-16-[icon(==60)]-10-[labels][button]-23-|"
			options:NSLayoutFormatAlignAllCenterY
			metrics:nil
			views:views
		]];
		[_button
			setContentHuggingPriority:UILayoutPriorityDefaultHigh
			forAxis:UILayoutConstraintAxisHorizontal
		];
		[_labelContainer
			setContentHuggingPriority:UILayoutPriorityDefaultLow
			forAxis:UILayoutConstraintAxisHorizontal
		];
		[_button
			setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
			forAxis:UILayoutConstraintAxisHorizontal
		];
		[_labelContainer
			setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
			forAxis:UILayoutConstraintAxisHorizontal
		];
		[self addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|-16-[icon(==60)]-16-|"
			options:0
			metrics:nil
			views:views
		]];
		[_labelContainer addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"V:|[name(==24.0)]-4-[author(==19.5)]|"
			options:0
			metrics:nil
			views:views
		]];
		[_labelContainer addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[name]|"
			options:0
			metrics:nil
			views:views
		]];
		[_labelContainer addConstraints:[NSLayoutConstraint
			constraintsWithVisualFormat:@"H:|[author]|"
			options:0
			metrics:nil
			views:views
		]];
	}
	return self;
}

@end