//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMContentUrlController.h"
#import "YMContentUrlService.h"
#import "YMStandardStatDataSource.h"
#import "YMCounter.h"
#import "YMContentUrlWrapper.h"
#import "YMContentUrlDataSource.h"


@interface YMContentUrlController ()

@property(nonatomic, strong) YMContentUrlService *service;

@end

@implementation YMContentUrlController

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
        [(YMContentUrlDataSource *) self.dataSource setIsLandscapeMode:isLandscapeMode];
    }
    [super setIsLandscapeMode:isLandscapeMode];
}


- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getUrlForCounter:counter.id token:counter.token
                          fromDate:self.dateStart
                            toDate:self.dateEnd
                           success:^(YMContentUrlWrapper *content) {
                               YMContentUrlDataSource *dataSource = [[YMContentUrlDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd];
                               [dataSource setIsLandscapeMode:self.isLandscapeMode];
                               success(dataSource);
                           } failure:failure];
}

@end