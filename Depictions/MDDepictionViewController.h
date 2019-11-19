#import <UIKit/UIKit.h>

@class MDStackView;

@interface MDDepictionViewController : UIViewController {
	UIImageView *_headerImageView;
	NSArray<MDStackView *> *_depictionStackViews;
	UIScrollView *_depictionScrollView;
	NSLayoutConstraint *_headerImagePosition; // Y position
	NSLayoutConstraint *_headerImageWidth;
	NSLayoutConstraint *_headerImageHeight;
	NSString *_packageID;
	__weak id _package;
	id _repo;
}
@property (nonatomic, strong) NSDictionary *sileoDepiction;
- (id)package;
@end