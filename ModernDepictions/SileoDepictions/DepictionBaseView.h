#import <UIKit/UIKit.h>
#import "ModernCell.h"

@class ModernDepictionDelegate;

typedef NS_ENUM(NSUInteger, AlignEnum) {
	AlignEnumLeft = 0,
	AlignEnumCenter = 1,
	AlignEnumRight = 2
};

@interface DepictionBaseView : UITableViewCell<ModernCell>
@property (nonatomic, readonly) ModernDepictionDelegate *depictionDelegate;
@property (nonatomic, strong, setter=setLabelText:, getter=labelText) NSString *labelText;
@property (nonatomic, assign, setter=setNumberOfLines:) NSInteger numberOfLines;
- (void)setNumberOfLines:(NSInteger)numberOfLines;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(ModernDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)cellWillAppear;
- (instancetype)init __attribute__((deprecated("Use initWithDepictionDelegate: instead.")));
- (void)setLabelText:(NSString *)text;
- (NSString *)labelText;
@end