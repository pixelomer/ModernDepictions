#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "Depictions.h"
#import "MDDepictionViewController.h"
#import "MDSileoDepictionViewProtocol.h"
#import "MDStackView.h"

%hook DepictionViewController

+ (id)alloc {
	MDDepictionViewController *newVC = [MDDepictionViewController alloc];
	return newVC;
}

%end

void MDInitializeDepictions(void) {
	%init(DepictionViewController = MDGetClass(MDTargetDepictionController));
}

__kindof UIView<MDSileoDepictionViewProtocol> *MDCreateView(NSDictionary *_properties) {
	NSString *className = _properties[@"class"];
	if (!className) return nil;
	className = [NSString stringWithFormat:@"MDSileo%@", className];
	Class _meta = objc_getMetaClass(className.UTF8String);
	Class _class = objc_getClass(className.UTF8String);
	if (!_meta || !_class) return nil;
	if (![_class conformsToProtocol:@protocol(MDSileoDepictionViewProtocol)]) return nil;
	NSDictionary *properties = (id)_properties.mutableCopy;
	[(NSMutableDictionary *)properties removeObjectForKey:@"class"];
	properties = properties.copy;
	BOOL separately = [_meta shouldAssignPropertiesSeparately];
	__kindof UIView *view = [[_meta alloc] initWithProperties:properties];
	if (!view) return nil;
	if (separately) {
		for (NSString *JSONPropertyKey in properties) {
			if (JSONPropertyKey.length <= 0) continue;
			unichar c = [JSONPropertyKey.uppercaseString characterAtIndex:0];
			NSString *propertyKey = [NSString
				stringWithFormat:@"depiction%C%@", c, [JSONPropertyKey substringFromIndex:1]
			];
			NSLog(@"[Key] %@", propertyKey);
			if (class_getProperty(_class, propertyKey.UTF8String)) {
				id value = properties[propertyKey];
				[view setValue:value forKey:propertyKey];
			}
		}
	}
	return view;
}

NSArray<MDSileoDepictionStackView *> *MDParseSileoDepiction(NSDictionary *depiction) {
	if (![depiction isKindOfClass:[NSDictionary class]]) return nil;
	if ([depiction[@"class"] isEqualToString:@"DepictionTabView"]) {
		// I have no idea about how Sileo implements DepictionTabView
		NSArray *tabs = depiction[@"tabs"];
		if (![tabs isKindOfClass:[NSArray class]] || tabs.count <= 0) return nil;
		NSMutableArray *stacks = [NSMutableArray new];
		for (NSDictionary *tab in tabs) {
			UIView *stack = MDCreateView(tab);
			if (stack) [stacks addObject:stack];
		}
		return stacks.copy;
	}
	return nil;
}