//
// Created by Dmitry Korotchenkov on 18/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMSourcesPhrasesController.h"
#import "YMSourcesPhrasesService.h"
#import "YMCounter.h"
#import "YMSourcesPhrasesWrapper.h"
#import "YMStandardStatDataSource.h"

@interface YMSourcesPhrasesController ()

@property(nonatomic, strong) YMSourcesPhrasesService *service;

@end

@implementation YMSourcesPhrasesController

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
        [(YMStandardStatDataSource *) self.dataSource setIsLandscapeMode:isLandscapeMode];
    }
    [super setIsLandscapeMode:isLandscapeMode];
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getPhrasesForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMSourcesPhrasesWrapper *content) {
        YMStandardStatDataSource *dataSource = [[YMStandardStatDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd needGrouping:YES];
        [dataSource setIsLandscapeMode:self.isLandscapeMode];
        success(dataSource);
    }                          failure:failure];
}

@end