//
// Created by Dmitry Korotchenkov on 14/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMSourcesSearchEnginesController.h"
#import "YMSourcesSearchEnginesService.h"
#import "YMCounter.h"
#import "YMSourcesSearchEnginesWrapper.h"
#import "YMStandardStatDataSource.h"

@interface YMSourcesSearchEnginesController ()

@property(nonatomic, strong) YMSourcesSearchEnginesService *service;

@end

@implementation YMSourcesSearchEnginesController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource>*dataSource))success error:(void (^)(NSError *))failure {

    [self.service getSearchEnginesForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMSourcesSearchEnginesWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:NO];
        success(dataSource);
    } failure:failure];
}

@end