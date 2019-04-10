#import "FeaturedDummyPackage.h"

@implementation FeaturedDummyPackage

static UIImage *qmarkIcon;

+ (void)initialize {
	if ([self class] == [FeaturedDummyPackage class]) {
		qmarkIcon = [UIImage imageNamed:@"unknown"];
	}
}

- (void)parse {}

- (NSString *)mode {
	return nil;
}

- (UIImage *)icon {
	return qmarkIcon;
}

- (NSString *)id {
	return _identifier;
}

- (id)source {
	return nil;
}

- (id)author {
	return nil;
}

- (BOOL)uninstalled {
	return YES;
}

- (NSString *)shortDescription {
	return @"This package is not available in your sources.";
}

- (instancetype)initWithPackageName:(NSString *)name identifier:(NSString *)identifier {
	self = [super init];
	_name = name;
	_identifier = identifier;
	return self;
}

@end