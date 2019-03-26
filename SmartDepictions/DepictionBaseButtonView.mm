#import "DepictionBaseButtonView.h"
#import "SmartDepictionDelegate.h"
#import "../Extensions/UIColor+HexString.h"

@implementation DepictionBaseButtonView

- (void)setTitle:(NSString *)newTitle {
	self.textLabel.text = newTitle;
	_title = newTitle;
}

- (void)didGetSelected {
	if (defaultButtonAction == DepictionButtonActionOpenURL) {
		[UIApplication.sharedApplication openURL:defaultURL];
	}
}

- (CGFloat)height {
	return (_yPadding * 2) + 44.0;
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithDepictionDelegate:delegate reuseIdentifier:reuseIdentifier];
	self.tintColor = SmartDepictionDelegate.defaultTintColor;
	return self;
}

- (void)convertAction:(NSString *)rawURL toURL:(NSURL * __strong *)urlPt andRawAction:(DepictionButtonAction *)rawActionPt {
	if (!rawURL) return;
	DepictionButtonAction action = 0;
	NSMutableArray *components = [[rawURL componentsSeparatedByString:@"-"] mutableCopy];
	if (components.count > 0) {
		if ([components[0] isEqualToString:@"form"]) action = DepictionButtonActionShowForm;
		else if ([components[0] isEqualToString:@"depiction"]) action = DepictionButtonActionShowDepiction;
		if (action != DepictionButtonActionOpenURL) [components removeObjectAtIndex:0];
	}
	NSString *finalRawURL = [components componentsJoinedByString:@"-"];
	if (urlPt) *urlPt = [NSURL URLWithString:finalRawURL];
	if (rawActionPt) *rawActionPt = action;
}

- (void)setAction:(NSString *)newAction {
	[self convertAction:newAction toURL:&defaultURL andRawAction:&defaultButtonAction];
	_action = newAction;
}

- (void)setTintColor:(id)newColor {
	UIColor *tintColor = [newColor isKindOfClass:[NSString class]] ? [UIColor colorWithHexString:newColor] : newColor;
	self.textLabel.textColor = tintColor;
	[super setTintColor:tintColor];
}

- (void)setBackupAction:(NSString *)newAction {
	[self convertAction:newAction toURL:&backupURL andRawAction:&backupButtonAction];
	_backupAction = newAction;
}

- (void)setYPadding:(CGFloat)yPadding {
	_yPadding = yPadding;
}

@end