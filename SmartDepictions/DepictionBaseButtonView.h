#import "DepictionBaseView.h"

/*
	|Key|         |Type|        |Description|                                              |Required|
	title         String        The button’s label.                                         Yes
	action	      String (URL)  The URL to open when the button is pressed.                 Yes
	backupAction  String (URL)  An alternate action to try if the action is not supported.  No
	openExternal  Double        Set whether to open the URL in an external app.             No
	yPadding      Double        Padding to put above and below the button.                  No
*/

typedef NS_ENUM(NSUInteger, DepictionButtonAction) {
	DepictionButtonActionOpenURL = 0,
	DepictionButtonActionShowDepiction = 1,
	DepictionButtonActionShowForm = 2
};

@interface DepictionBaseButtonView : DepictionBaseView {
	NSURL *defaultURL;
	NSURL *backupURL;
	DepictionButtonAction defaultButtonAction;
	DepictionButtonAction backupButtonAction;
	NSArray *paddingConstraints;
}
@property (nonatomic, retain, setter=setTitle:) NSString *title;
@property (nonatomic, retain, setter=setAction:) NSString *action;
@property (nonatomic, retain, setter=setBackupAction:) NSString *backupAction;
@property (nonatomic, assign) BOOL openExternal;
@property (nonatomic, assign, setter=setYPadding:) CGFloat yPadding;
- (void)setTitle:(NSString *)newTitle;
- (void)setAction:(NSString *)newAction;
- (void)setBackupAction:(NSString *)newAction;
- (void)setOpenExternal:(BOOL)openExternal;
- (void)setYPadding:(CGFloat)yPadding;
@end