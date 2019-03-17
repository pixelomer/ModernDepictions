#import "AuthorButton.h"
#import "../Headers/Headers.h"

@implementation AuthorButton

- (instancetype)initWithMIMEAddress:(MIMEAddress *)address {
	self = [super init];
	[self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	self.titleLabel.font = [UIFont systemFontOfSize:16];
	self.MIMEAddress = address;
	self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	return self;
}

- (void)setMIMEAddress:(MIMEAddress *)address {
	NSString *rawURL = [address address];
	NSLog(@"MIMEAddress: %@, rawURL: %@", address, rawURL);
	if (rawURL) {
		rawURL = [@"mailto:" stringByAppendingString:rawURL];
		NSLog(@"%@", rawURL);
		mailURL = [NSURL URLWithString:rawURL];
	}
	if ([address name]) [self setTitle:[address name] forState:UIControlStateNormal];
	self.userInteractionEnabled = (mailURL && [UIApplication.sharedApplication canOpenURL:mailURL]);
}

- (void)touchUpInside:(id)sender {
	// This is a button. When touched, it should do one of the following:
	// - Create a new email for the author with logs
	// - Show other packages from this developer
	
	/*
	if (!mailURL) return;
	NSLog(@"%@", mailURL);
	if (@available(iOS 10.0, *)) [UIApplication.sharedApplication openURL:mailURL options:@{} completionHandler:nil];
	*/
}

@end