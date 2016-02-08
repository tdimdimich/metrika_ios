//
// Created by Dmitry Korotchenkov on 13/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMGeoController.h"
#import "YMGeoService.h"
#import "YMCounter.h"
#import "YMGeoWrapper.h"
#import "YMStandardStatDataSource.h"

@interface YMGeoController ()

@property(nonatomic, strong) YMGeoService *service;

@end

@implementation YMGeoController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)setIsLandscapeMode:(BOOL)isLandscapeMode {
    if (self.dataSource) {
        [(YMStandardStatDataSource *)self.dataSource setIsLandscapeMode:isLandscapeMode];
    }
    [super setIsLandscapeMode:isLandscapeMode];
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource>*dataSource))success error:(void (^)(NSError *))failure {

    [self.service getGeoForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMGeoWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:YES];
        [dataSource setIsLandscapeMode:self.isLandscapeMode];
        success(dataSource);
    } failure:failure];
}

@end