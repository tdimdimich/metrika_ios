//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Objection/JSObjection.h>
#import <Objection/Objection.h>
#import "YMAbstractService.h"
#import "YMAbstractEntity.h"
#import "YMUtils.h"


@interface YMAbstractService ()
@property(nonatomic, weak) RKObjectRequestOperation *operation;
@property(nonatomic, strong) NSString *token;
@end

#define EXEC_BLOCK_WITH_PARAM_IF_EXIST(block, param) \
if (block) { \
    block(param); \
}

@implementation YMAbstractService

- (void)sendRequest:(NSString *)methodPath parameters:(NSDictionary *)parameters success:(YMServiceSuccessBlock)success failure:(YMServiceErrorBlock)failure {
    [self sendRequest:methodPath parameters:parameters success:success failure:failure downloadProgressBlock:nil];
}

- (void)sendRequest:(NSString *)methodPath parameters:(NSDictionary *)parameters success:(YMServiceSuccessBlock)success failure:(YMServiceErrorBlock)failure downloadProgressBlock:(YMDownloadProgressBlock)downloadBlock {
    self.token = parameters[kTokenParamKey];
    if (!self.token) {
        NSLog(@"Token wasn't passed!");
        EXEC_BLOCK_WITH_PARAM_IF_EXIST(failure, nil);
        return;
    }

    NSString *method = [methodPath stringByAppendingString:@".json"];
    void (^successBlock)(RKObjectRequestOperation *, RKMappingResult *) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        YMAbstractEntity *response = mappingResult.firstObject;
        if (response.hasError) {
            EXEC_BLOCK_WITH_PARAM_IF_EXIST(failure, response.error);

        } else {
            EXEC_BLOCK_WITH_PARAM_IF_EXIST(success, response);
        }
    };
    void (^failureBlock)(RKObjectRequestOperation *, NSError *) = ^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    };

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![YMUtils isPreferredRussianLanguage]) {
        [params addEntriesFromDictionary:@{
                @"lang" : @"en"
        }];
    }

    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKObjectRequestOperation *operation =
            [manager appropriateObjectRequestOperationWithObject:nil method:RKRequestMethodGET path:method parameters:params];
    [operation setWillMapDeserializedResponseBlock:[self addedTokenMapping]];
    [operation setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    [manager enqueueObjectRequestOperation:operation];
    if (downloadBlock) {
        [operation.HTTPRequestOperation setDownloadProgressBlock:downloadBlock];
    }
    self.operation = operation;
}

- (id (^)(id))addedTokenMapping {
    return ^(id deserializedResponse) {
        if ([deserializedResponse isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *castedResponse = [deserializedResponse mutableCopy];

            if (castedResponse[@"errors"]) {
                return deserializedResponse;

            } else {
                [castedResponse addEntriesFromDictionary:@{
                        @"token" : self.token
                }];

                [castedResponse addEntriesFromDictionary:@{
                        @"lang" : [YMUtils isPreferredRussianLanguage] ? @"ru" : @"en"
                }];

                return (id) [NSDictionary dictionaryWithDictionary:castedResponse];
            }
        }
        return deserializedResponse;
    };
}

- (void)cancel {
    if (!self.operation.isCancelled) {
        [self.operation cancel];
    }
}

- (void)dealloc {
    [self.operation cancel];
}

@end