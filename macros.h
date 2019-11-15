#if DEBUG
#define MD_TEST_EXCEPTION(text...) [NSException raise:NSInternalInconsistencyException format:text]
#else
#define MD_TEST_EXCEPTION(...) (ERROR: Test exception being used in production)
#endif

#define MD_BASIC_INTERFACE(name, class) \
@interface name : class \
@end

#define ZEBRA_BUNDLE_ID "xyz.willy.Zebra"
#define CYDIA_BUNDLE_ID "com.saurik.Cydia"

#import <Headers/Headers.h>
#import <Core/Core.h>
#import <objc/runtime.h>