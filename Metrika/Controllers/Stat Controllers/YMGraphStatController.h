//
// Created by Dmitry Korotchenkov on 29/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMStatAbstractController.h"


@interface YMGraphStatController : YMStatAbstractController <YMPlotViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSObject <YMGraphDataSource> *dataSource;
@property(nonatomic) BOOL graphTypeIsPoints;

@end