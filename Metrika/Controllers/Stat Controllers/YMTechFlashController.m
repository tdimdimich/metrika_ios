//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMTechFlashController.h"
#import "YMTechFlashService.h"
#import "YMCounter.h"
#import "YMStandardStatDataSource.h"
#import "YMTechFlashWrapper.h"

@interface YMTechFlashController ()

@property(nonatomic, strong) YMTechFlashService *service;

@end

@implementation YMTechFlashController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getFlashForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTechFlashWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:NO];
        success(dataSource);
    } failure:failure];
}

@end