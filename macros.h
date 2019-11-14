#import <Headers/Headers.h>
#import <Core/Core.h>

#if DEBUG
#define TEST_EXCEPTION(text...) [NSException raise:NSInternalInconsistencyException format:text]
#else
#define TEST_EXCEPTION(...) (ERROR: Test exception being used in production)
#endif