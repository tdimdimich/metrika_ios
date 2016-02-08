//
// Created by Dmitry Korotchenkov on 02.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractWrapper.h"


@interface YMSourcesSitesWrapper : YMAbstractWrapper

@property (nonatomic, strong) NSSet *data;

- (NSArray *)listOfObjects;
@end