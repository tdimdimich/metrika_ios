//
// File: YMAppSettings.m
// Project: Metrika
//
// Created by dkorneev on 8/22/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <BlocksKit/NSArray+BlocksKit.h>
#import <RestKit/RestKit/Network/RKObjectManager.h>
#import <RestKit/RestKit/CoreData/RKManagedObjectStore.h>
#import <RestKit/RestKit/CoreData/NSManagedObjectContext+RKAdditions.h>
#import "YMAppSettings.h"
#import "YMAccountInfo.h"
#import "NSSet+BlocksKit.h"
#import "YMCountersListWrapper.h"
#import "NSManagedObject+YMAdditions.h"

@implementation YMAppSettings

+ (void)removeAccounts {
    NSLog(@"remove accounts");
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;

    // 1. delete YMAccountInfo, appropriated YMCounterInfo will delete automatically by CoreData
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"YMAccountInfo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"shouldBeRemoved = YES"];
    NSError *error = nil;
    NSArray *accounts = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
        NSLog(@"Error has occurred while getting account info [%@]", error);

    NSMutableArray *tokens = [NSMutableArray new];
    for (YMAccountInfo *account in accounts) {
        [tokens addObject:account.token];
        [context deleteObject:account];
    }

    // 2. delete YMCountersListWrapper, appropriated YMCounterInfo will delete automatically by CoreData
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"YMCountersListWrapper"];
    error = nil;
    NSArray *wrappers = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
        NSLog(@"Error has occurred while getting account info [%@]", error);

    for (YMCountersListWrapper *wrapper in wrappers) {
        NSString *token = [tokens bk_match:^BOOL(NSString *curToken) {
            return [curToken isEqualToString:wrapper.token];
        }];
        if (token) {
            [context deleteObject:wrapper];
        }
    }
    [self commitUpdates];
}

+ (NSArray *)getVisibleAccounts {
    return [YMAccountInfo allByPredicate:[NSPredicate predicateWithFormat:@"hidden = NO"]];
}

+ (NSArray *)getAccounts {
    return [YMAccountInfo allByPredicate:nil];
}

+ (void)commitUpdates {
    NSManagedObjectContext *context = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    NSError *error = nil;
    if (![context saveToPersistentStore:&error]) {
        NSLog(@"Error has occurred while committing updates:\n[%@]", error);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAppSettingsDidUpdateNotification object:nil];
    }
}

+ (YMCounterInfo *)selectedCounter {
    NSArray *accounts = [self getAccounts];
    for (YMAccountInfo *account in accounts) {
        YMCounterInfo *counter = [account.counterInfo bk_match:^BOOL(YMCounterInfo *curCounter) {
            return curCounter.selected;
        }];
        if (counter)
            return counter;
    }
    return nil;
}

@end