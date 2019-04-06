#import "ModernErrorCell.h"

@implementation ModernErrorCell

- (instancetype)initWithErrorMessage:(NSString *)errorMessage {
	self = [super initWithDepictionDelegate:nil reuseIdentifier:nil];
	self.textLabel.text = [NSString stringWithFormat:@"Error: %@", errorMessage];
	self.textLabel.textColor = [UIColor whiteColor];
	self.contentView.backgroundColor = [UIColor redColor];
	return self;
}

@end