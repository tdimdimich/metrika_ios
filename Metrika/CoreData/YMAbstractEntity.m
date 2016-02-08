//
// Created by Dmitry Korotchenkov on 12.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMAbstractEntity.h"
#import "RKEntityMapping.h"
#import "RKObjectManager.h"
#import "RKRelationshipMapping.h"
#import "YMError.h"
#import "NSArray+BlocksKit.h"

@implementation YMAbstractEntity

@dynamic errors;

+ (RKEntityMapping *)entityMapping {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];

    mapping.setNilForMissingRelationships = YES;
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"errors"
                                                                            toKeyPath:@"errors"
                                                                          withMapping:[YMError mapping]]];
    return mapping;
}

- (BOOL)hasError {
    return self.errors.count > 0;
}

- (NSError *)error {

    int index = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (YMError *error in self.errors) {
        [dictionary addEntriesFromDictionary:@{
                [NSNumber numberWithInt:index] : @{@"code" : error.code, @"text" : error.text}
        }];
        index++;
    }

    return [NSError errorWithDomain:@"" code:200 userInfo:dictionary];
}

+ (NSArray *)textsForError:(NSError *)error {
    NSMutableArray *array = [NSMutableArray array];
    [error.userInfo.allValues bk_each:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [[(NSDictionary *) obj allKeys] bk_each:^(id sender) {
                if ([sender isKindOfClass:[NSString class]] && [sender isEqualToString:@"text"]) {
                    [array addObject:obj[@"text"]];
                }
            }];
        }
    }];
    if (array.count)
        return [NSArray arrayWithArray:array];
    else
        return nil;

}

+ (NSString *)textForError:(NSError *)error {
    NSArray *errorTexts = [self textsForError:error];
    NSMutableString *string = [NSMutableString new];
    [errorTexts bk_each:^(id sender) {
        if ([sender isKindOfClass:[NSString class]]) {
            if (string.length > 0) {
                [string appendString:@", "];
            }
            [string appendString:sender];
        }
    }];
    return string.length > 0 ? string : nil;
}

+ (NSArray *)codesForError:(NSError *)error {
    NSMutableArray *array = [NSMutableArray array];
    [error.userInfo.allValues bk_each:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [[(NSDictionary *) obj allKeys] bk_each:^(id sender) {
                if ([sender isKindOfClass:[NSString class]] && [sender isEqualToString:@"code"]) {
                    [array addObject:obj[@"code"]];
                }
            }];
        }
    }];

    return array.count ? array : nil;
}

+ (BOOL)isCodeForPeriodError:(NSString *)errorCode {
    return ([errorCode isEqualToString:@"ERR_NO_DATA"] ||
            [errorCode isEqualToString:@"ERR_DATE_END"] ||
            [errorCode isEqualToString:@"ERR_DATE_DELTA"] ||
            [errorCode isEqualToString:@"ERR_DATE_BEGIN"]);
}

@end