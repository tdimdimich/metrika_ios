//
// Created by Dmitry Korotchenkov on 29/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMStatAbstractController.h"

@protocol YMDiagramDataSource;
@class YMDiagramLandscapeView;


@interface YMDiagramStatController : YMStatAbstractController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSObject <YMDiagramDataSource> *dataSource;
@end