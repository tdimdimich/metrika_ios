//
// Created by Dmitry Korotchenkov on 26.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSManagedObject+YMAdditions.h"
#import "RKManagedObjectStore.h"


@implementation NSManagedObject (YMAdditions)

+ (NSManagedObjectContext *)getContext {
    return [(RKManagedObjectStore *) [RKManagedObjectStore defaultStore] mainQueueManagedObjectContext];
}

+ (NSArray *)allSortedBy:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate {
    NSString *entityName = NSStringFromClass(self.class);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setSortDescriptors:sortDescriptors];
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    __block NSArray *array;
    NSManagedObjectContext *managedObjectContext = [self getContext];
    [managedObjectContext performBlockAndWait:^{
        NSError *error;
        array = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"Failed to load objects %@", error);
        }
    }];
    return array;
}

+ (NSArray *)allByPredicate:(NSPredicate *)predicate {
    return [self allSortedBy:@[] predicate:predicate];
}

@end