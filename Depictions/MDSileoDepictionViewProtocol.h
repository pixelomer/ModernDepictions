@class NSDictionary;

@protocol MDSileoDepictionViewProtocol
@required
// The "properties" variable will contain the properties for the view, specified
// in the JSON file. If the caller should assign all of the properties one by
// one to the view, return a dictionary. If you want to assign the properties
// yourself, process the "properties" variable and return NULL.
// ...
// You probably didn't understand. If you didn't, create an issue on Github and
// if I feel like doing so, I might explain it in more detail.
- (NSDictionary *)setProperties:(NSDictionary *)properties;
@end