#import <UIKit/UIKit.h>

@class MDStackView;

@interface MDDepictionViewController : UIViewController {
	UIImageView *_headerImageView;
	NSArray<MDStackView *> *_depictionStackViews;
	NSDictionary *_sileoDepiction;
	UIScrollView *_depictionScrollView;
	NSLayoutConstraint *_headerImagePosition; // Y position
	NSLayoutConstraint *_headerImageWidth;
	NSLayoutConstraint *_headerImageHeight;
}
@property (nonatomic, weak) __kindof NSObject *package;
@end