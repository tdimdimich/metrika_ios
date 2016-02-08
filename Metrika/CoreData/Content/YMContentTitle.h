//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMAbstractChildEntity.h"


@interface YMContentTitle : YMAbstractChildEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *pageViews;

@end