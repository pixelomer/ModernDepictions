#ifndef __MACROS_H
#define __MACROS_H
#if DEBUG
#define NSLog(value...) NSLog(@"[BetterDepictions] "value)
#else
#define NSLog(...);
#endif
#define min(a, b) (a > b ? b : a)
#define max(a, b) (a > b ? a : b)
#endif