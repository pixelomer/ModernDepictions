#import "ModernHomeController.h"
#import "FeaturedPackageCell.h"
#import "FeaturedBannersView.h"
#import "FeaturedHeaderView.h"

@implementation ModernHomeController

- (instancetype)init {
	self = [self initWithStyle:UITableViewStylePlain];
	database = [objc_getClass("Database") sharedInstance];
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSUserDefaults *stddef = [NSUserDefaults standardUserDefaults];
	BOOL shouldRefresh = NO;
	refreshButton = [[UIBarButtonItem alloc]
		initWithTitle:UCLocalize(@"REFRESH")
		style:UIBarButtonItemStylePlain
		target:self
		action:@selector(refreshFeaturedPackages)
	];
	self.navigationItem.leftBarButtonItem = refreshButton;
	if (NSDate *lastRefresh = [stddef objectForKey:@"ModernDepictionsLastRefreshDate"]) {
		NSLog(@"Last refresh: %@", lastRefresh);
		NSDate *aWeekAfterRefresh = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay 
			value:7
			toDate:lastRefresh 
			options:0
		];
		shouldRefresh = (
			![stddef objectForKey:@"ModernDepictionsCachedFeaturedPackages"] ||
			([aWeekAfterRefresh compare:[NSDate date]] == NSOrderedAscending)
		);
	}
	else {
		NSLog(@"Never refreshed before");
		shouldRefresh = YES;
	}
	NSLog(@"Will be refreshed: %d", shouldRefresh);
	if (shouldRefresh) [self refreshFeaturedPackages];
	else [self loadFeaturedPackages];
}

/* Structure:

{
	"Dynastic": {
		"itemSize": "{263, 148}",
		"itemCornerRadius": 10,
		"banners": [
			{
				"url": "https://repo-cdn.dynastic.co/91373858589769729.97ea6548c456372ba1ba0e6640e7e73f-750?size=750",
				"title": "ShortLook",
				"package": "co.dynastic.ios.tweak.shortlook",
				"hideShadow": false
			},
			{
				"url": "https://repo-cdn.dynastic.co/163005874409832449.23336a53f4a32e557baa0943417349ca-750?size=750",
				"title": "Ultrasound",
				"package": "applebetas.ios.tweak.willow",
				"hideShadow": false
			}
		]
	},
	"Nexus": {
		"itemSize": "{263, 148}",
		"itemCornerRadius": 10,
		"banners": [
			{  
				"url": "https://nexusrepo.kro.kr/depictions/com.peterdev.xeon/sileo-depiction/images/header.png",
				"title": "Xeon",
				"package": "com.peterdev.xeon",
				"hideShadow": false
			},
			{  
				"url": "https://nexusrepo.kro.kr/sileo-featured-images/powerguardbanner.png",
				"title": "PowerGuard",
				"package": "com.peterdev.powerguard",
				"hideShadow": false
			},
			{  
				"url": "https://nexusrepo.kro.kr/depictions/com.peterdev.carrierhider/sileo-depiction/images/header.png",
				"title": "Carrier Hider",
				"package": "com.peterdev.carrierhider",
				"hideShadow": false
			},
			{  
				"url": "https://nexusrepo.kro.kr/depictions/com.peterdev.hidejbapps/sileo-depiction/images/header.png",
				"title": "Hide JB Apps",
				"package": "com.peterdev.hidejbapps",
				"hideShadow": false
			}
		]
	}
}

*/

- (void)loadFeaturedPackages {
	self.title = @"Cydia";
	NSDictionary<NSString *, NSDictionary *> *cachedInformation = [[NSUserDefaults standardUserDefaults] objectForKey:@"ModernDepictionsCachedFeaturedPackages"];
	NSMutableArray<NSDictionary *> *featuredPackages = [NSMutableArray new];
	NSLog(@"Cached: %@", cachedInformation);
	for (NSString *repoHost in cachedInformation) {
		NSDictionary *repo = cachedInformation[repoHost];
		if (repo[@"banners"]) for (NSDictionary *bannerInfo in repo[@"banners"]) {
			if (
				[bannerInfo[@"imageData"] isKindOfClass:[NSData class]] &&
				[bannerInfo[@"package"] isKindOfClass:[NSString class]] &&
				[bannerInfo[@"title"] isKindOfClass:[NSString class]]
			) {
				UIImage *image = nil;
				if (!(image = [UIImage imageWithData:bannerInfo[@"imageData"]])) continue;
				[featuredPackages addObject:@{
					@"title" : bannerInfo[@"title"],
					@"image" : image,
					@"hideShadow" : bannerInfo[@"hideShadow"] ?: @NO,
					@"package" : bannerInfo[@"package"],
					@"preferredSize" : repo[@"itemSize"] ?: @"{263, 148}"
				}];
			}
		}
	}
	NSLog(@"Featured packages: %@", featuredPackages);
	NSMutableArray *chosenPackages = [NSMutableArray new];
	for (int i = featuredPackages.count; i > max(0, featuredPackages.count - 9); i--) {
		NSInteger index = arc4random_uniform(i);
		[chosenPackages addObject:featuredPackages[index]];
		[featuredPackages removeObjectAtIndex:index];
	}
	NSLog(@"Chose packages: %@", chosenPackages);
	[self createCellsFromPackages:chosenPackages];
	[self.tableView reloadData];
}

- (void)createCellsFromPackages:(NSArray<NSDictionary<NSString *, __kindof NSObject *> *> *)packageArray {
	NSMutableArray *mutableCells = [NSMutableArray new];
	if (packageArray.count > 0) {
		FeaturedBannersView *bannersView = [[FeaturedBannersView alloc] initWithPackages:packageArray bannerLimit:4];
		[mutableCells addObject:bannersView];
	}
	if (packageArray.count > 4) {
		[mutableCells addObject:@"Popular Packages"]; // Will be treated as a FeaturedHeaderView
		for (int i = 4; i < min(packageArray.count, 9); i++) {
			[mutableCells addObject:packageArray[i]]; // Will be treated as a FeaturedPackageCell
		}
	}
	cells = [mutableCells copy];
}

- (void)refreshFeaturedPackages {
	self.title = @"Refreshing...";
	refreshButton.enabled = NO;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		usleep(2000000);
		NSUserDefaults *stddef = [NSUserDefaults standardUserDefaults];
		if ([stddef objectForKey:@"ModernDepictionsCachedFeaturedPackages"]) [stddef removeObjectForKey:@"ModernDepictionsCachedFeaturedPackages"];
		NSArray<Source *> *sources = [[database sources] copy];
		NSMutableDictionary *finalDictionary = [NSMutableDictionary new];
		for (Source *source in sources) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				self.title = [NSString stringWithFormat:@"%@...", source.name];
			});
			NSURL *featuredURL = [[NSURL URLWithString:source.rooturi] URLByAppendingPathComponent:@"sileo-featured.json"];
			if (!featuredURL) continue;
			NSData *rawJSON = [NSData dataWithContentsOfURL:featuredURL];
			NSLog(@"Featured URL: %@, Data: %@", featuredURL, rawJSON);
			if (!rawJSON) continue;
			NSError *error = nil;
			NSDictionary *JSON = [NSJSONSerialization
				JSONObjectWithData:rawJSON
				options:NSJSONReadingMutableContainers
				error:&error
			];
			NSLog(@"Error: %@\nJSON: %@", error, JSON);
			if (!JSON || error || ![JSON isKindOfClass:[NSDictionary class]] || ![JSON[@"class"] isKindOfClass:[NSString class]] || ![JSON[@"class"] isEqualToString:@"FeaturedBannersView"] || ![JSON[@"banners"] isKindOfClass:[NSMutableArray class]]) continue;
			NSMutableArray *banners = JSON[@"banners"];
			NSLog(@"Banners: %@", banners);
			if (banners.count > 0) {
				for (NSMutableDictionary *banner in banners) {
					NSURL *bannerURL = nil;
					NSLog(@"Downloading banner: %@", banner);
					if (![banner isKindOfClass:[NSMutableDictionary class]] || ![banner[@"url"] isKindOfClass:[NSString class]] || !(bannerURL = [NSURL URLWithString:banner[@"url"]])) continue;
					NSData *data = [NSData dataWithContentsOfURL:bannerURL];
					if (data) banner[@"imageData"] = data;
				}
			}
			finalDictionary[featuredURL.host] = [JSON copy];
		}
		[stddef setObject:finalDictionary forKey:@"ModernDepictionsCachedFeaturedPackages"];
		[stddef setObject:[NSDate date] forKey:@"ModernDepictionsLastRefreshDate"];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self loadFeaturedPackages];
			refreshButton.enabled = YES;
		});
		NSLog(@"Final: %@", finalDictionary);
	});
}

- (Cydia *)delegate {
	return _cydiaDelegate;
}

- (void)setDelegate:(Cydia *)newDelegate {
	_cydiaDelegate = newDelegate;
}

// TESTING
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *object = cells[indexPath.row];
	UITableViewCell *cell = nil;
	NSLog(@"Object: %@", object);
	if ([object isKindOfClass:[NSString class]]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Header"];
		if (!cell) {
			cell = [[FeaturedHeaderView alloc] initWithReuseIdentifier:@"Header"];
		}
		cell.text = (NSString *)object;
	}
	else if ([object isKindOfClass:[NSDictionary class]]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Package"];
		if (!cell) cell = [[FeaturedPackageCell alloc] initWithIconSize:65.0 centerText:YES reuseIdentifier:@"Package"];
		((FeaturedPackageCell *)cell).package = [database packageWithName:cells[indexPath.row][@"package"]];
	}
	else {
		cell = (UITableViewCell *)object;
	}
	if (![cell isKindOfClass:[FeaturedPackageCell class]]) cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return cells ? cells.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	FeaturedBannersView *cell = cells[indexPath.row];
	return [cell isKindOfClass:[FeaturedBannersView class]] ? cell.height : UITableViewAutomaticDimension;
}

@end