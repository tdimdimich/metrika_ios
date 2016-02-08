//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RKObjectManager.h"

@class RKEntityMapping;

@interface YMAbstractEntity : NSManagedObject

@property (nonatomic, strong) NSSet *errors;

+ (RKEntityMapping *)entityMapping;

+ (NSArray *)textsForError:(NSError *)error;

+ (NSString *)textForError:(NSError *)error;

+ (NSArray *)codesForError:(NSError *)error;

+ (BOOL)isCodeForPeriodError:(NSString *)errorCode;

- (BOOL)hasError;

- (NSError *)error;

@end