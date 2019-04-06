#import "DepictionImageView.h"
#import "ModernDepictionDelegate.h"

@implementation DepictionImageView

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:imageView];
	[self.contentView addConstraint:[NSLayoutConstraint
		constraintWithItem:imageView
		attribute:NSLayoutAttributeCenterY
		relatedBy:NSLayoutRelationEqual
		toItem:self.contentView
		attribute:NSLayoutAttributeCenterY
		multiplier:1.0
		constant:0.0
	]];
	_height = _width = 0.0;
	self.horizontalPadding = 0.0;
	self.alignment = AlignEnumCenter;
	return self;
}

- (CGFloat)height {
	return cellHeight;
}

- (void)setURL:(NSString *)URL {
	NSURL *url = [NSURL URLWithString:URL];
	if (url) [self.depictionDelegate downloadDataFromURL:url completion:^(NSData *data, NSError *error) {
		if (!error && data) {
			UIImage *image = [UIImage imageWithData:data];
			if (image) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					imageView.image = image;
					[imageView setNeedsDisplay];
				});
			}
		}
	}];
	_URL = URL;
}

- (void)resetSize {
	if (_height != 0.0 && _width != 0.0) {
		CGFloat maxWidth = UIScreen.mainScreen.bounds.size.width - (self.horizontalPadding * 2);
		CGFloat intendedWidth = _width;
		ratio = maxWidth / intendedWidth;
		if (ratio > 1.0) ratio = 1.0;
		cellHeight = (ratio * _height);
		imageWidth = (ratio * _width);
		NSLog(@"max: %f, intended: %f, ratio: %f, height: %f, width: %f", maxWidth, intendedWidth, ratio, cellHeight, imageWidth);
	}
}

- (void)resetSizeConstraints {
	if (sizeConstraints) {
		[self.contentView removeConstraints:sizeConstraints];
	}
	[self resetSize];
	sizeConstraints = @[
		[NSLayoutConstraint
			constraintWithItem:imageView
			attribute:NSLayoutAttributeHeight
			relatedBy:NSLayoutRelationEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:0.0
			constant:cellHeight
		],
		[NSLayoutConstraint
			constraintWithItem:imageView
			attribute:NSLayoutAttributeWidth
			relatedBy:NSLayoutRelationEqual
			toItem:nil
			attribute:NSLayoutAttributeNotAnAttribute
			multiplier:0.0
			constant:imageWidth
		]
	];
}

- (void)layoutSubviews {
	[self resetSizeConstraints];
	for (NSArray *array in @[ sizeConstraints ?: NSNull.null, paddingConstraints ?: NSNull.null, alignmentConstraints ?: NSNull.null ]) {
		if ([array isKindOfClass:[NSNull class]]) continue;
		[self.contentView addConstraints:array];
	}
	[super layoutSubviews];
}

- (void)setWidth:(CGFloat)width {
	_width = width;
	[self resetSize];
}

- (void)setHeight:(CGFloat)height {
	_height = height;
	[self resetSize];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
	imageView.layer.masksToBounds = YES;
	imageView.layer.cornerRadius = cornerRadius;
	_cornerRadius = cornerRadius;
}

- (void)setHorizontalPadding:(CGFloat)horizontalPadding {
	if (paddingConstraints) {
		[self.contentView removeConstraints:paddingConstraints];
	}
	paddingConstraints = @[
		[NSLayoutConstraint
			constraintWithItem:imageView
			attribute:NSLayoutAttributeLeading
			relatedBy:NSLayoutRelationGreaterThanOrEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeLeading
			multiplier:1.0
			constant:horizontalPadding
		],
		[NSLayoutConstraint
			constraintWithItem:imageView
			attribute:NSLayoutAttributeTrailing
			relatedBy:NSLayoutRelationLessThanOrEqual
			toItem:self.contentView
			attribute:NSLayoutAttributeTrailing
			multiplier:1.0
			constant:-horizontalPadding
		]
	];
	[self.contentView layoutIfNeeded];
	_horizontalPadding = horizontalPadding;
}

- (void)setAlignment:(AlignEnum)alignment {
	if (alignmentConstraints) {
		[self.contentView removeConstraints:alignmentConstraints];
	}
	if (alignment == AlignEnumLeft) {
		alignmentConstraints = @[
			[NSLayoutConstraint
				constraintWithItem:imageView
				attribute:NSLayoutAttributeLeading
				relatedBy:NSLayoutRelationEqual
				toItem:self.contentView
				attribute:NSLayoutAttributeLeading
				multiplier:1.0
				constant:0.0
			]
		];
	}
	else if (alignment == AlignEnumRight) {
		alignmentConstraints = @[
			[NSLayoutConstraint
				constraintWithItem:imageView
				attribute:NSLayoutAttributeTrailing
				relatedBy:NSLayoutRelationEqual
				toItem:self.contentView
				attribute:NSLayoutAttributeTrailing
				multiplier:1.0
				constant:0.0
			]
		];
	}
	else {
		alignmentConstraints = @[
			[NSLayoutConstraint
				constraintWithItem:imageView
				attribute:NSLayoutAttributeCenterX
				relatedBy:NSLayoutRelationEqual
				toItem:self.contentView
				attribute:NSLayoutAttributeCenterX
				multiplier:1.0
				constant:0.0
			]
		];
	}
	[self.contentView layoutIfNeeded];
	_alignment = alignment;
}

@end