//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/JSObjection.h>
#import <Objection/Objection.h>
#import "YMTechCookiesController.h"
#import "YMTechCookiesService.h"
#import "YMTechCookiesWrapper.h"
#import "YMCounter.h"
#import "YMStandardStatDataSource.h"

@interface YMTechCookiesController ()

@property(nonatomic, strong) YMTechCookiesService *service;

@end

@implementation YMTechCookiesController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }
    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getCookiesForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTechCookiesWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.data.allObjects
                                                                                       dateStart:self.dateStart
                                                                                         dateEnd:self.dateEnd
                                                                                    needGrouping:NO];
        if (content.data.allObjects.count < 2) {
            [dataSource addDataWithName:NSLocalizedString(@"Cookies disabled", @"Cockies disabled") visits:0 pageViews:0 denial:0 visitTime:0];
        }
        success(dataSource);
    }                          failure:failure];
}

@end