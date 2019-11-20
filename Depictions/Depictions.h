// NOTE FROM PAST PIXEL:
// Since you always mix these two definitions, here is what they mean
// for a Left-to-Right language:
// - Leading: Left side
// - Trailing: Right side

@class NSArray;
@class NSDictionary;
@class MDSileoDepictionStackView;
@protocol MDSileoDepictionViewProtocol;

void MDInitializeDepictions(void);
NSArray<MDSileoDepictionStackView *> *MDParseSileoDepiction(NSDictionary *depiction);
__kindof UIView<MDSileoDepictionViewProtocol> *MDCreateView(NSDictionary *properties);
UIImage *MDGetShadowImage(void);