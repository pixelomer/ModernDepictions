#import "DepictionMarkdownView.h"
#import "DepictionHeaderView.h"

@interface DepictionSubheaderView : DepictionHeaderView
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
@end