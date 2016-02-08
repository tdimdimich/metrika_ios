//
// Created by Dmitry Korotchenkov on 26.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (YMAdditions)


+ (NSManagedObjectContext *)getContext;

+ (NSArray *)allSortedBy:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate;

+ (NSArray *)allByPredicate:(NSPredicate *)predicate;
@end