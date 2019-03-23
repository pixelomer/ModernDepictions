#import "DepictionStackView.h"
#import "ContentCellFactory.h"
#import "SubDepictionTableView.h"

@implementation DepictionStackView

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	tableView = [[SubDepictionTableView alloc] init];
	tableView.translatesAutoresizingMaskIntoConstraints = NO;
	tableView.scrollEnabled = NO;
	tableView.alwaysBounceVertical = NO;
	tableView.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:tableView];
	NSDictionary *views = @{ @"tableView" : tableView };
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[tableView]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.contentView addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[tableView(>=0)]|"
		options:0
		metrics:nil
		views:views
	]];
	return self;
}

- (CGFloat)height {
	return tableView.contentSize.height;
}

- (void)setViews:(NSArray *)views {
	[tableView setViews:views delegate:self.depictionDelegate];
	_views = views;
}

@end