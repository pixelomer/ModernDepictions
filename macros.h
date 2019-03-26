#ifndef __MACROS_H
#define __MACROS_H

#import <objc/runtime.h>

// Macro to add a debug prefix to every log
#if DEBUG
#define NSLog(value...) NSLog(@"[BetterDepictions] "value)
#else
#define NSLog(...); {}
#endif

// Macros to find the highest/lowest of two numbers
#define min(a, b) (a > b ? b : a)
#define max(a, b) (a > b ? a : b)

// Macros to properly perform selectors
#define PerformSelector(target, self, _cmd) class_getMethodImplementation(NSClassFromString(@#target), _cmd)(self, _cmd)
#define PerformSelectorWithArgs(target, self, _cmd, args...) class_getMethodImplementation(NSClassFromString(@#target), _cmd)(self, _cmd, args)

#endif