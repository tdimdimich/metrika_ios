//
// Created by Dmitry Korotchenkov on 13/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMDemographyStructureController.h"
#import "YMDemographyStructureService.h"
#import "YMCounter.h"
#import "YMDemographyStructureDataSource.h"

@interface YMDemographyStructureController ()

@property(nonatomic, strong) YMDemographyStructureService *service;

@end

@implementation YMDemographyStructureController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource>*dataSource))success error:(void (^)(NSError *))failure {

    [self.service getDemographyForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMDemographyStructureWrapper *content) {
        success([[YMDemographyStructureDataSource alloc] initWithContent:content dateStart:self.dateStart dateEnd:self.dateEnd]);
    } failure:failure];
}

@end