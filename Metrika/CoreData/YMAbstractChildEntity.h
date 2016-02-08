//
// Created by Dmitry Korotchenkov on 30.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit/CoreData/RKEntityMapping.h>
#import <RestKit/RestKit/Network/RKObjectManager.h>
#import "YMStandardStatObject.h"


@interface YMAbstractChildEntity : NSManagedObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSDate *parentDateStart;
@property (nonatomic, strong) NSDate *parentDateEnd;
@property (nonatomic, strong) NSString *lang;

+ (RKEntityMapping *)mapping;

@end