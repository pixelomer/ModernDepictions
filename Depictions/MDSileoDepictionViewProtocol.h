@protocol NSObject;
@class NSDictionary;

@protocol MDSileoDepictionViewProtocol<NSObject>
@required
+ (BOOL)shouldAssignPropertiesSeparately;
- (instancetype)initWithProperties:(NSDictionary *)properties;
@end