#import "SubDepictionViewController.h"
#import "SubDepictionTableView.h"
#import "SmartDepictionDelegate.h"

@implementation SubDepictionViewController

- (void)setDepictionURL:(NSURL *)depictionURL {
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
	[_tableView addSubview:activityIndicator];
	[_tableView addConstraints:@[
		[NSLayoutConstraint
			constraintWithItem:activityIndicator
			attribute:NSLayoutAttributeCenterX
			relatedBy:NSLayoutRelationEqual
			toItem:_tableView
			attribute:NSLayoutAttributeCenterX
			multiplier:1.0
			constant:0.0
		],
		[NSLayoutConstraint
			constraintWithItem:activityIndicator
			attribute:NSLayoutAttributeCenterY
			relatedBy:NSLayoutRelationEqual
			toItem:_tableView
			attribute:NSLayoutAttributeCenterY
			multiplier:1.0
			constant:0.0
		]
	]];
	[_depictionDelegate downloadDataFromURL:depictionURL completion:^(NSData *data, NSError *error){
		NSLog(@"Error: %@, Data: %@", error, data);
		if (data && !error) {
			NSDictionary *depiction = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if ([depiction isKindOfClass:[NSDictionary class]] && depiction[@"views"]) dispatch_sync(dispatch_get_main_queue(), ^{
				self.depiction = depiction[@"views"];
				self.title = depiction[@"title"];
			});
		}
		[activityIndicator stopAnimating];
		activityIndicator = nil;
	}];
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate {
	self = [super init];
	_depictionDelegate = delegate;
	_tableView = [[SubDepictionTableView alloc] init];
	_tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_tableView];
	NSDictionary *views = @{ @"tableView" : _tableView };
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"H:|[tableView]|"
		options:0
		metrics:nil
		views:views
	]];
	[self.view addConstraints:[NSLayoutConstraint
		constraintsWithVisualFormat:@"V:|[tableView]|"
		options:0
		metrics:nil
		views:views
	]];
	return self;
}

- (void)setDepiction:(NSArray *)depiction {
	[_tableView setViews:depiction delegate:_depictionDelegate];
	_depiction = depiction;
}

- (void)viewDidLoad {
	[activityIndicator startAnimating];
}

@end