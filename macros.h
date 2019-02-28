#ifndef __MACROS_H
#define __MACROS_H

#if DEBUG
#define NSLog(value...) NSLog(@"[BetterDepictions] "value)
#else
#define NSLog(...);
#endif
#define min(a, b) (a > b ? b : a)
#define max(a, b) (a > b ? a : b)

#import <objc/runtime.h>
#define PerformSelector(target, self, _cmd) class_getMethodImplementation(NSClassFromString(@#target), _cmd)(self, _cmd)
#define PerformSelectorWithArgs(target, self, _cmd, args...) class_getMethodImplementation(NSClassFromString(@#target), _cmd)(self, _cmd, args)

#endif