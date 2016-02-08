//
// Created by Dmitry Korotchenkov on 19/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMTrafficDeepnessTimeController.h"
#import "YMTrafficDeepnessService.h"
#import "YMCounter.h"
#import "YMTrafficDeepnessDataSource.h"
#import "YMTrafficDeepnessWrapper.h"

@interface YMTrafficDeepnessTimeController ()

@property(nonatomic, strong) YMTrafficDeepnessService *service;

@end

@implementation YMTrafficDeepnessTimeController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {

    [self.service getDeepnessForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTrafficDeepnessWrapper *content) {
        success([[YMTrafficDeepnessDataSource alloc] initWithContent:content.dataTime.allObjects dateStart:self.dateStart dateEnd:self.dateEnd]);
    }                           failure:failure];
}

@end