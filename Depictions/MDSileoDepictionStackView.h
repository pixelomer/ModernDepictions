#import "MDStackView.h"
#import "MDSileoDepictionViewProtocol.h"

@interface MDSileoDepictionStackView : MDStackView<MDSileoDepictionViewProtocol>
@property (nonatomic, strong) NSString *depictionTabname;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *depictionViews;
@property (nonatomic, assign, setter=setSpacing:, getter=spacing) CGFloat depictionXPadding;
+ (BOOL)shouldAssignPropertiesSeparately;
- (instancetype)initWithProperties:(NSDictionary *)properties;
@end