//
// Created by Dmitry Korotchenkov on 03.07.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMSourcesPhrasesSearchEngines : NSManagedObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSString *url;

+ (RKEntityMapping *)mapping;

@end