@class NSArray;
@class NSDictionary;
@class MDSileoDepictionStackView;
@protocol MDSileoDepictionViewProtocol;

void MDInitializeDepictions(void);
NSArray<MDSileoDepictionStackView *> *MDParseSileoDepiction(NSDictionary *depiction);
__kindof UIView<MDSileoDepictionViewProtocol> *MDCreateView(NSDictionary *properties);