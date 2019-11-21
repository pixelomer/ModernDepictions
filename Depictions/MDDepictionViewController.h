#import <UIKit/UIKit.h>

@class MDGetPackageView;
@class MDStackView;
@class MDTabView;

@interface MDDepictionViewController : UIViewController<UIScrollViewDelegate> {
	UIImageView *_headerImageView;
	NSArray<MDStackView *> *_depictionStackViews;
	UIScrollView *_depictionScrollView;
	NSLayoutConstraint *_headerPosition; // Y position
	NSLayoutConstraint *_headerImageWidth;
	NSLayoutConstraint *_headerImageHeight;
	MDGetPackageView *_getPackageView;
	MDTabView *_tabView;
	NSString *_packageID;
	CGFloat _initialImageHeight;
	BOOL _didLayoutSubviews;
	__weak id _package;
	id _repo;
}
@property (nonatomic, strong) NSDictionary *sileoDepiction;
- (id)package;
@end