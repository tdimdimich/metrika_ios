//
// Created by Dmitry Korotchenkov on 19/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMTrafficHourlyController.h"
#import "YMTrafficHourlyService.h"
#import "YMCounter.h"
#import "YMTrafficHourlyDataSource.h"

@interface YMTrafficHourlyController ()

@property(nonatomic, strong) YMTrafficHourlyService *service;

@end


@implementation YMTrafficHourlyController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode {
    if (self.dataSource) {
        [(YMTrafficHourlyDataSource *) self.dataSource setIsLandscapeMode:isLandscapeMode];
    }
    [super setIsLandscapeMode:isLandscapeMode];
}


- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {

    [self.service getHourlyForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTrafficHourlyWrapper *content) {
        YMTrafficHourlyDataSource *dataSource = [[YMTrafficHourlyDataSource alloc] initWithContent:content dateStart:self.dateStart dateEnd:self.dateEnd];
        [dataSource setIsLandscapeMode:self.isLandscapeMode];
        success(dataSource);
    }                         failure:failure];
}


@end