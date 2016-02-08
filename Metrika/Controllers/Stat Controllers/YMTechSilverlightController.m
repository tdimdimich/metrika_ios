//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMTechSilverlightController.h"
#import "YMTechSilverlightService.h"
#import "YMCounter.h"
#import "YMStandardStatDataSource.h"
#import "YMTechSilverlightWrapper.h"

@interface YMTechSilverlightController ()

@property(nonatomic, strong) YMTechSilverlightService *service;

@end

@implementation YMTechSilverlightController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getSilverlightForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMTechSilverlightWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:NO];
        success(dataSource);
    } failure:failure];
}

@end