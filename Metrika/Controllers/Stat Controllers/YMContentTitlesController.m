//
// Created by Dmitry Korotchenkov on 26/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMContentTitlesController.h"
#import "YMContentTitleService.h"
#import "YMCounter.h"
#import "YMContentTitleWrapper.h"
#import "YMStandardStatDataSource.h"
#import "YMContentTitlesDataSource.h"

@interface YMContentTitlesController ()

@property(nonatomic, strong) YMContentTitleService *service;

@end

@implementation YMContentTitlesController

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
        [(YMContentTitlesDataSource *) self.dataSource setIsLandscapeMode:isLandscapeMode];
    }
    [super setIsLandscapeMode:isLandscapeMode];
}


- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource> *dataSource))success error:(void (^)(NSError *))failure {
    [self.service getTitleForCounter:counter.id token:counter.token
                            fromDate:self.dateStart
                              toDate:self.dateEnd
                             success:^(YMContentTitleWrapper *content) {
                                 YMContentTitlesDataSource *dataSource = [[YMContentTitlesDataSource alloc] initWithContent:content.data.allObjects dateStart:self.dateStart dateEnd:self.dateEnd];
                                 [dataSource setIsLandscapeMode:self.isLandscapeMode];
                                 success(dataSource);
                             } failure:failure];
}

@end