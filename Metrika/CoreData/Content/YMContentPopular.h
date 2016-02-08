//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "YMAbstractChildEntity.h"


@interface YMContentPopular : YMAbstractChildEntity

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *urlFull;
@property (nonatomic, strong) NSNumber *pageViews;

@property (nonatomic, strong) NSNumber *exit;
@property (nonatomic, strong) NSNumber *entrance;

@property (nonatomic, strong) NSSet *child;
@property (nonatomic, strong) YMContentPopular *parent;

- (NSString *)domainName;

@end