#import "DepictionBaseView.h"
#import "../Extensions/UIColor+HexString.h"

@implementation DepictionBaseView

- (CGFloat)height {
	return UITableViewAutomaticDimension;
}

- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	_depictionDelegate = delegate;
	self.textLabel.numberOfLines = 1;
	self.contentView.backgroundColor = nil;
	self.backgroundColor = nil;
	return self;
}

- (instancetype)init {
	return nil;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
	self.textLabel.numberOfLines = numberOfLines;
	_numberOfLines = numberOfLines;
}

- (void)setLabelText:(NSString *)text {
	self.textLabel.text = text;
}

- (void)cellWillAppear {

}

- (NSString *)labelText {
	return self.textLabel.text;
}

@end