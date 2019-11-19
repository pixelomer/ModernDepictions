#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "Depictions.h"
#import "MDDepictionViewController.h"
#import "MDSileoDepictionViewProtocol.h"
#import "MDStackView.h"

static NSArray *fieldArray;

%group Depictions
%hook DepictionViewController

+ (id)alloc {
	MDDepictionViewController *newVC = [MDDepictionViewController alloc];
	return newVC;
}

%end
%end

void MDInitializeDepictions(void) {
	%init(Depictions, DepictionViewController=MDGetClass(MDTargetDepictionController));
}

__kindof UIView<MDSileoDepictionViewProtocol> *MDCreateView(NSDictionary *_properties) {
	NSString *className = _properties[@"class"];
	if (!className) return nil;
	className = [NSString stringWithFormat:@"MDSileo%@", className];
	Class _class = objc_getClass(className.UTF8String);
	if (!_class) return nil;
	if (![_class conformsToProtocol:@protocol(MDSileoDepictionViewProtocol)]) return nil;
	NSDictionary *properties = (id)_properties.mutableCopy;
	[(NSMutableDictionary *)properties removeObjectForKey:@"class"];
	properties = properties.copy;
	BOOL separately = [_class shouldAssignPropertiesSeparately];
	__kindof UIView *view = [[_class alloc] initWithProperties:properties];
	if (!view) return nil;
	if (separately) {
		for (NSString *JSONPropertyKey in properties) {
			if (JSONPropertyKey.length <= 0) continue;
			unichar c = [JSONPropertyKey.uppercaseString characterAtIndex:0];
			NSString *propertyKey = [NSString
				stringWithFormat:@"depiction%C%@", c, [JSONPropertyKey substringFromIndex:1]
			];
			BOOL isValid = !!class_getProperty(_class, propertyKey.UTF8String);
			NSLog(@"[Key] \"%@\", %d", propertyKey, (int)isValid);
			if (isValid) {
				id value = properties[JSONPropertyKey];
				[view setValue:value forKey:propertyKey];
			}
		}
	}
	return view;
}

NSArray<MDSileoDepictionStackView *> *MDParseSileoDepiction(NSDictionary *depiction) {
	NSLog(@"[ParseDepiction] %@", depiction);
	if (![depiction isKindOfClass:[NSDictionary class]]) return nil;
	if ([depiction[@"class"] isEqualToString:@"DepictionTabView"]) {
		// DepictionTabView is the only root view so let's just check for it
		NSArray *tabs = depiction[@"tabs"];
		if (![tabs isKindOfClass:[NSArray class]] || tabs.count <= 0) return nil;
		NSMutableArray *stacks = [NSMutableArray new];
		for (NSDictionary *tab in tabs) {
			NSLog(@"[ParseDepiction] Parsing tab: %@", tab);
			UIView *stack = MDCreateView(tab);
			NSLog(@"[ParseDepiction] Result: %@", stack);
			if (stack) [stacks addObject:stack];
		}
		return stacks.copy;
	}
	return nil;
}