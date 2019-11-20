#import <UIKit/UIKit.h>

@class MDSileoDepictionStackView;

@interface MDTabView : UIView {
	UIView *_selectionIndicator;
	NSArray<UIButton *> *_buttons;
}
@property (nonatomic, assign, readonly) NSUInteger currentIndex;
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) NSArray<MDSileoDepictionStackView *> *tabs;
@end