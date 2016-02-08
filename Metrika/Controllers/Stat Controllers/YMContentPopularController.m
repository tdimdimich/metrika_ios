//
// Created by Dmitry Korotchenkov on 14/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Objection/Objection.h>
#import "YMContentPopularController.h"
#import "YMContentPopularService.h"
#import "YMCounter.h"
#import "YMContentPopularDataSource.h"

@interface YMContentPopularController ()

@property(nonatomic, strong) YMContentPopularService *service;

@end

@implementation YMContentPopularController

objection_requires(@"service")

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[JSObjection defaultInjector] injectDependencies:self];
    }

    return self;
}

- (void)getDataSourceForCounter:(YMCounter *)counter success:(void (^)(NSObject <YMDiagramDataSource>*dataSource))success error:(void (^)(NSError *))failure {

    [self.service getPopularForCounter:counter.id token:counter.token fromDate:self.dateStart toDate:self.dateEnd success:^(YMContentPopularWrapper *content) {
        success([[YMContentPopularDataSource alloc] initWithContent:content dateStart:self.dateStart dateEnd:self.dateEnd]);
    } failure:failure];
}


@end