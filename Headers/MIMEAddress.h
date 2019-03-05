#import <Foundation/Foundation.h>

@interface MIMEAddress : NSObject {
    NSString *name_;
    NSString *address_;
}
- (NSString *)name;
- (NSString *)address;
- (void)setAddress:(NSString *)address;
+ (MIMEAddress *)addressWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
@end