#import "DepictionBaseView.h"
#import "../Extensions/UIColor+HexString.h"

@implementation DepictionBaseView

- (CGFloat)height {
	return UITableViewAutomaticDimension;
}

- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	_depictionDelegate = delegate;
	self.textLabel.numberOfLines = 0;
	self.contentView.backgroundColor = nil;
	self.backgroundColor = nil;
	return self;
}

- (instancetype)init {
	return nil;
}

- (void)setLabelText:(NSString *)text {
	self.textLabel.text = text;
}

- (NSString *)labelText {
	return self.textLabel.text;
}

@end