//
//  YMAppDelegate.m
//  Metrika
//
//  Created by Dmitry Korotchenkov on 12.06.13.
//  Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import <BlocksKit/NSSet+BlocksKit.h>
#import "YMAppDelegate.h"
#import "RKPathUtilities.h"
#import "RKLog.h"
#import "RKObjectManager.h"
#import "RKMIMETypeSerialization.h"
#import "RKNSJSONSerialization.h"
#import "YMMenuController.h"
#import "YMTrafficSummaryService.h"
#import "YMConstants.h"
#import "YMAppSettings.h"
#import "YMUtils.h"
#import "UIViewController+YMAdditions.h"
#import "YMMCounter.h"
#import "GAILogger.h"
#import "GAI.h"
#import "YMTipsManager.h"
#import "GAIDictionaryBuilder.h"
#import "YMCountersListWrapper.h"
#import "YMSignInController.h"
#import "YMCountersListService.h"
#import "YMCounter.h"
#import "YMAccountInfo.h"
#import "VKSdk.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface YMAppDelegate()
@property(nonatomic, strong) YMCountersListService *counterListService;
@end

@implementation YMAppDelegate

objection_requires(@"counterListService")

- (id)init {
    self = [super init];
    if (self) {
        [self configureObjection];
        [[JSObjection defaultInjector] injectDependencies:self];
        [self configureRestKit];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)willEnterForeground {
    [YMTipsManager incrementLaunchCounter];
}

- (void)configureObjection {
    JSObjectionInjector *injector = [JSObjection createInjector];
    [JSObjection setDefaultInjector:injector];
}

- (void)configureRestKit {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    NSURL *baseURL = [NSURL URLWithString:kAPIBaseUrl];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    objectManager.managedObjectStore = [self createManagedObjectStore];
    objectManager.HTTPClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];

    [RKObjectMapping addDefaultDateFormatterForString:@"yyyyMMdd" inTimeZone:nil];
    [RKObjectMapping addDefaultDateFormatterForString:@"yyyyMM" inTimeZone:nil];
    [RKObjectMapping addDefaultDateFormatterForString:@"HH:mm:ss" inTimeZone:nil];
    [RKObjectMapping addDefaultDateFormatterForString:@"HH:mm" inTimeZone:nil];

    RKLogConfigureByName("RestKit", RKLogLevelInfo);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    RKLogConfigureByName("RestKit/Network", RKLogLevelInfo);
}

- (RKManagedObjectStore *)createManagedObjectStore {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSError *error;
    NSString *databasePath = [self databasePath];
    [managedObjectStore addSQLitePersistentStoreAtPath:databasePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (error) {
        NSLog(@"Failed to create managed object store with error: %@. Trying to cleanup", error);
        NSError *fileRemovingError;
        [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&fileRemovingError];
        if (fileRemovingError) {
            NSLog(@"Failed to cleanup database with error: %@", fileRemovingError);
            @throw [NSException exceptionWithName:fileRemovingError.domain reason:nil userInfo:nil];

        } else {
            NSLog(@"Successfully cleaned-up old database. Retry");
            [managedObjectStore addSQLitePersistentStoreAtPath:databasePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
        }
    }
    [managedObjectStore createManagedObjectContexts];
    return managedObjectStore;
}

- (NSString *)databasePath {
    return [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Metrika.sqlite"];
}


- (YMMenuController *)menuController {
    if (!_menuController) {
        _menuController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"menuControllerID"];
    }
    return _menuController;
}

- (BOOL)shouldAutorotate {
    if (self.menuController && ![self.menuController isMenuOpened] && self.menuController.openedController) {
        return [self.menuController.openedController canShowLandscapeMode];
    }
    return NO;
}

- (void)configGoogleAnalytics {
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
#warning Enter your GATrackingId
    [[GAI sharedInstance] trackerWithTrackingId:@"YOUR_KEY"];
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [YMTipsManager incrementLaunchCounter];
    [Fabric with:@[CrashlyticsKit]];

    if (!DEBUG) {
        [self configGoogleAnalytics];
        [YMMCounter startWithAPIKey:21367];
    }
    application.statusBarStyle = UIStatusBarStyleLightContent;
    if ([YMAppSettings getAccounts].count > 0) {
        UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
        YMMenuController *menuController = APPDELEGATE.menuController;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [navigationController pushViewController:menuController animated:NO];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([YMAppSettings selectedCounter]) {
        [self.counterListService getCountersWithToken:[YMAppSettings selectedCounter].counter.token successBlock:^(YMCountersListWrapper *content) {
            [self addAccountWithToken:[YMAppSettings selectedCounter].counter.token andCounters:content.counters];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kUpdateCountersNotification object:nil]];

        } failureBlock:nil progressBlock:nil];
    }
}

- (void)addAccountWithToken:(NSString *)token andCounters:(NSSet *)counters {
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"YMAccountInfo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"token = %@", token];
    NSArray *existingAccounts = [context executeFetchRequest:fetchRequest error:nil];
    YMAccountInfo *accountInfo = existingAccounts.firstObject;
    if (!accountInfo)
        return;

    NSMutableSet *countersSet = [NSMutableSet new];
    for (YMCounter *counter in counters) {

        // find existing counterInfo
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"YMCounterInfo"];
        fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"counter.id = %@ AND counter.token = %@ AND counter.lang = %@",
                        counter.id, counter.token, counter.lang];
        NSArray *existingCounterInfo = [context executeFetchRequest:fetchRequest2 error:nil];


        YMCounterInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"YMCounterInfo" inManagedObjectContext:context];
        if (existingCounterInfo.count) {
            // update new counterInfo with old data and delete old counterInfo
            [info fillWithCounterInfo:existingCounterInfo.firstObject];
            for (YMCounterInfo *curInfo in existingCounterInfo) {
                [context deleteObject:curInfo];
            }

        } else {
            info.color = [YMUtils createCounterColorWithAlreadyExistingCounters:accountInfo.counterInfo];
            info.counter = counter;
            info.dateStart = info.dateEnd = [NSDate date];
        }
        [countersSet addObject:info];
    }

    // select counter if there is no selected
    YMCounterInfo *selectedCounter = [countersSet bk_match:^BOOL(YMCounterInfo *curInfo) {
        return curInfo.selected;
    }];
    if (!selectedCounter) {
        ((YMCounterInfo *)countersSet.allObjects.firstObject).selected = YES;
    }

    accountInfo.counterInfo = countersSet;
    [YMAppSettings commitUpdates];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [YMAppSettings removeAccounts];
}

@end
