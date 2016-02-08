//
// Created by Dmitry Korotchenkov on 07/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Objection/JSObjection.h>
#import <Objection/Objection.h>
#import "YMTrafficSummaryController.h"
#import "YMTrafficSummaryService.h"
#import "YMTrafficSummaryDataSource.h"
#import "YMCounter.h"
#import "YMPointPlotData.h"

@interface YMTrafficSummaryController ()

@property(nonatomic, strong) YMTrafficSummaryService *trafficService;

@end

@implementation YMTrafficSummaryController

objection_requires(@"trafficService")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)loadView {
    [super loadView];
    self.graphTypeIsPoints = YES;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMGraphDataSource>*dataSource))success error:(void (^)(NSError *))failure {
    [self.trafficService getSummaryForCounter:counter.id token:counter.token
                                     fromDate:self.dateStart
                                       toDate:self.dateEnd
                                      success:^(NSArray *content) {
                                          success([[YMTrafficSummaryDataSource alloc] initWithTrafficContent:content dateStart:self.dateStart dateEnd:self.dateEnd]);
                                      } failure:failure];
}

@end