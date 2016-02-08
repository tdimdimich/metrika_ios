//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RestKit.h"

static NSString *const kTokenParamKey = @"oauth_token";

typedef void (^YMServiceSuccessBlock)(id response);

typedef void (^YMServiceErrorBlock)(NSError *error);

typedef void (^YMDownloadProgressBlock)(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead);

@interface YMAbstractService : NSObject

// parameters must contain token!
- (void)sendRequest:(NSString *)methodPath parameters:(NSDictionary *)parameters success:(YMServiceSuccessBlock)success failure:(YMServiceErrorBlock)failure;

// parameters must contain token!
- (void)sendRequest:(NSString *)methodPath parameters:(NSDictionary *)parameters success:(YMServiceSuccessBlock)success failure:(YMServiceErrorBlock)failure downloadProgressBlock:(YMDownloadProgressBlock)downloadBlock;

@end