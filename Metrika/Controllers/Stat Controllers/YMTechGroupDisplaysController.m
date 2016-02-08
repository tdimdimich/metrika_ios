//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/JSObjection.h>
#import <Objection/Objection.h>
#import "YMTechGroupDisplaysController.h"
#import "YMTechDisplayService.h"
#import "YMCounter.h"
#import "YMTechDisplayWrapper.h"
#import "YMStandardStatDataSource.h"

@interface YMTechGroupDisplaysController ()

@property(nonatomic, strong) YMTechDisplayService *service;

@end

@implementation YMTechGroupDisplaysController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getDisplaysForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTechDisplayWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.dataGroup.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:NO];
        success(dataSource);
    } failure:failure];
}

@end