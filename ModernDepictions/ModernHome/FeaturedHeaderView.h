#import <UIKit/UIKit.h>

@interface FeaturedHeaderView : UITableViewCell {
	UILabel *label;
}
@property (nonatomic, strong, setter=setText:) NSString *text;
- (instancetype)initWithReuseIdentifier:(NSString *)ri;
- (void)setText:(NSString *)text;
@end