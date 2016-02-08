//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMTechMobileGroupController.h"
#import "YMTechMobileService.h"
#import "YMStandardStatDataSource.h"
#import "YMCounter.h"
#import "YMTechMobileWrapper.h"


@interface YMTechMobileGroupController ()

@property(nonatomic, strong) YMTechMobileService *service;

@end

@implementation YMTechMobileGroupController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getMobileForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTechMobileWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.dataGroup.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:NO];
        success(dataSource);
    } failure:failure];
}

@end