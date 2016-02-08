//
// Created by Dmitry Korotchenkov on 01.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RKEntityMapping.h"


@interface YMCounter : NSManagedObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *codeStatus;
@property (nonatomic, strong) NSString *permission;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *ownerLogin;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lang;

+ (RKEntityMapping *)mapping;

@end