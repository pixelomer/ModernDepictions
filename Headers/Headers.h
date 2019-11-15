#import <UIKit/UIKit.h>

MD_BASIC_INTERFACE(Package, NSObject)
MD_BASIC_INTERFACE(Source, NSObject)
MD_BASIC_INTERFACE(MIMEAddress, NSObject)
MD_BASIC_INTERFACE(ZBPackage, NSObject)
MD_BASIC_INTERFACE(ZBRepo, NSObject)
MD_BASIC_INTERFACE(Database, NSObject)

// Categories aren't necessary. They're here just to make it easier to identify the
// package manager that has a specific class.

NS_ASSUME_NONNULL_BEGIN

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
@property (nonatomic, strong) ZBPackage * _Nullable removedBy;
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

@interface Database(Cydia)
- (Package *)packageWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END