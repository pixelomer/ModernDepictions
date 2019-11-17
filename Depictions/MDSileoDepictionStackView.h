#import "MDStackView.h"
#import "MDSileoDepictionViewProtocol.h"

@interface MDSileoDepictionStackView : MDStackView<MDSileoDepictionViewProtocol>
@property (nonatomic, strong) NSString *depictionTabname;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *depictionViews;
- (NSDictionary *)setProperties:(NSDictionary *)properties;
@end