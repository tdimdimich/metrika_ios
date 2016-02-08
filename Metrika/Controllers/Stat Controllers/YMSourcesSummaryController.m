//
// Created by Dmitry Korotchenkov on 10/12/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//

#import "YMSourcesSummaryController.h"
#import "YMSourcesSummaryService.h"
#import "Objection.h"
#import "YMCounter.h"
#import "YMSourcesSummaryWrapper.h"
#import "YMStandardStatDataSource.h"
#import "YMSourcesSummaryDataSource.h"

@interface YMSourcesSummaryController ()

@property(nonatomic, strong) YMSourcesSummaryService *service;

@end

@implementation YMSourcesSummaryController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource>*dataSource))success error:(void (^)(NSError *))failure {

    [self.service getSummaryForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMSourcesSummaryWrapper *content) {
        YMSourcesSummaryDataSource *dataSource = [[YMSourcesSummaryDataSource alloc] initWithContent:content dateStart:self.dateStart dateEnd:self.dateEnd];
        success(dataSource);
    }                          failure:failure];
}

@end