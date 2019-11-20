#import <UIKit/UIKit.h>

@interface MDGetPackageView : UIView {
	UIImageView *_iconView;
	UIView *_labelContainer;
	UILabel *_authorLabel;
	UILabel *_nameLabel;
	UIButton *_button;
}
@property (nonatomic, weak) id package;
@property (nonatomic, strong) NSString *buttonText;
@end