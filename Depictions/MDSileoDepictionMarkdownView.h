#import "MDSileoDepictionViewProtocol.h"

@interface MDSileoDepictionMarkdownView : UIView<MDSileoDepictionViewProtocol> {
	UITextView *_textView;
}
@property (nonatomic, strong) NSString *depictionMarkdown;
@property (nonatomic, assign) BOOL depictionUseRawFormat;
@property (nonatomic, strong) NSString *depictionTintColor;
+ (BOOL)shouldAssignPropertiesSeparately;
- (instancetype)initWithProperties:(NSDictionary *)properties;
@end