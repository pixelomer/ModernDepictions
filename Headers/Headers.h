#import <UIKit/UIKit.h>

MD_BASIC_INTERFACE(Package, NSObject)
MD_BASIC_INTERFACE(Source, NSObject)
MD_BASIC_INTERFACE(MIMEAddress, NSObject)
MD_BASIC_INTERFACE(ZBPackage, NSObject)
MD_BASIC_INTERFACE(ZBRepo, NSObject)
MD_BASIC_INTERFACE(Database, NSObject)
MD_BASIC_INTERFACE(ZBDatabaseManager, NSObject)
MD_BASIC_INTERFACE(CydiaWebViewController, UIViewController)

// Categories aren't necessary. They're here just to make it easier to identify the
// package manager that has a specific class.

@interface Package(Cydia)
- (NSString *)depiction;
- (NSString *)id;
- (Source *)source;
- (void)parse;
- (bool)isCommercial;
- (NSString *)mode;
- (NSString *)section;
- (BOOL)upgradableAndEssential:(BOOL)essential;
- (NSArray *)downgrades;
- (UIImage *)icon;
- (BOOL)uninstalled;
- (NSString *)name;
- (void)install;
- (MIMEAddress *)author;
- (NSString *)getField:(NSString *)name;
- (NSString *)longDescription;
- (Source *)source;
- (NSString *)shortDescription;
- (NSString *)shortSection;
@end

@interface ZBPackage(Zebra)
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSString *longDescription;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *sectionImageName;
@property (nonatomic, strong) NSURL *depictionURL;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray <NSString *> *dependsOn;
@property (nonatomic, strong) NSArray <NSString *> *conflictsWith;
@property (nonatomic, strong) NSArray <NSString *> *provides;
@property (nonatomic, strong) NSArray <NSString *> *replaces;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) ZBRepo *repo;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *origBundleID;
@property (nonatomic, strong) NSDate *lastSeenDate;
@property (nonatomic, strong) NSMutableArray <ZBPackage *> *dependencies;
@property (nonatomic, strong) NSMutableArray <ZBPackage *> *dependencyOf;
@property (nonatomic, strong) NSMutableArray <NSString *> *issues;
@property (nonatomic, strong) ZBPackage *removedBy;
@property int installedSize;
@property int downloadSize;
@property BOOL sileoDownload;

+ (NSArray *)filesInstalledBy:(NSString *)packageID;
+ (BOOL)respringRequiredFor:(NSString *)packageID;
+ (BOOL)containsApplicationBundle:(NSString *)packageID;
+ (NSString *)pathForApplication:(NSString *)packageID;
//- (id)initWithSQLiteStatement:(sqlite3_stmt *)statement;
- (NSComparisonResult)compare:(id)object;
- (BOOL)sameAs:(ZBPackage *)package;
- (BOOL)sameAsStricted:(ZBPackage *)package;
- (BOOL)isPaid;
- (NSString *)getField:(NSString *)field;
- (BOOL)isInstalled:(BOOL)strict;
- (BOOL)isReinstallable;
- (NSArray <ZBPackage *> *)otherVersions;
- (NSArray <ZBPackage *> *)lesserVersions;
- (NSArray <ZBPackage *> *)greaterVersions;
- (NSUInteger)possibleActions;
- (BOOL)ignoreUpdates;
- (void)setIgnoreUpdates:(BOOL)ignore;
- (NSString *)downloadSizeString;
- (NSString *)installedSizeString;
- (ZBPackage *)installableCandidate;
- (NSDate *)installedDate;
- (NSString *)installedVersion;
- (void)addDependency:(ZBPackage *)package;
- (void)addDependencyOf:(ZBPackage *)package;
- (void)addIssue:(NSString *)issue;
- (BOOL)hasIssues;
@end

@interface ZBRepo(Zebra)
@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *baseFileName;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic) BOOL secure;
@property (nonatomic) BOOL supportSileoPay;
@property (nonatomic) int repoID;
@property (nonatomic, strong) NSURL *iconURL;
@property (nonatomic) BOOL defaultRepo;
@property (nonatomic, strong) NSString *suite;
@property (nonatomic, strong) NSString *components;
@property (nonatomic, strong) NSString *shortURL;
@property (nonatomic) BOOL supportsFeaturedPackages;
@property (nonatomic) BOOL checkedSupportFeaturedPackages;
+ (ZBRepo *)repoMatchingRepoID:(int)repoID;
+ (ZBRepo *)localRepo:(int)repoID;
+ (ZBRepo *)repoFromBaseURL:(NSString *)baseURL;
+ (BOOL)exists:(NSString *)urlString;
- (BOOL)isSecure;
- (BOOL)canDelete;
@end

@interface Database(Cydia)
- (Package *)packageWithName:(NSString *)name;
@end

@interface ZBDatabaseManager(Zebra)
+ (instancetype)sharedInstance;
- (ZBPackage *)topVersionForPackageID:(NSString *)packageIdentifier inRepo:(ZBRepo *)repo;
@end

@interface CydiaWebViewController(Cydia)
+ (NSURLRequest *)requestWithHeaders:(NSURLRequest *)request;
@end