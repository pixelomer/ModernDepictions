#import <UIKit/UIKit.h>
#import "SmartCell.h"

@class SmartDepictionDelegate;

typedef NS_ENUM(NSUInteger, AlignEnum) {
	AlignEnumLeft = 0,
	AlignEnumCenter = 1,
	AlignEnumRight = 2
};

@interface DepictionBaseView : UITableViewCell<SmartCell>
@property (nonatomic, readonly) SmartDepictionDelegate *depictionDelegate;
@property (nonatomic, retain, setter=setLabelText:, getter=labelText) NSString *labelText;
@property (nonatomic, assign, setter=setNumberOfLines:) NSInteger numberOfLines;
- (void)setNumberOfLines:(NSInteger)numberOfLines;
- (CGFloat)height;
- (instancetype)initWithDepictionDelegate:(SmartDepictionDelegate *)delegate reuseIdentifier:(NSString *)reuseIdentifier;
- (void)cellWillAppear;
- (instancetype)init __attribute__((deprecated("Use initWithDepictionDelegate: instead.")));
- (void)setLabelText:(NSString *)text;
- (NSString *)labelText;
@end