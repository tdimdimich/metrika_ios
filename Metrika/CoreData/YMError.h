//
// Created by Dmitry Korotchenkov on 15.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class RKObjectMapping;
@class RKEntityMapping;


@interface YMError : NSManagedObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *code;

+ (RKEntityMapping *)mapping;

+ (NSError *)errorFromAllYMErrors:(NSArray *)errors;
@end