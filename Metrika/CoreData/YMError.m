//
// Created by Dmitry Korotchenkov on 15.06.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKObjectMapping.h>
#import <RestKit/RestKit/Network/RKObjectManager.h>
#import "YMError.h"
#import "RKEntityMapping.h"


@implementation YMError

@dynamic text;
@dynamic code;

+(RKEntityMapping *)mapping {
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(self) inManagedObjectStore:manager.managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"code",@"text"]];
    mapping.identificationAttributes = @[@"code",@"text"];
    return mapping;
}

+ (NSError *)errorFromAllYMErrors:(NSArray *)errors {
    int index = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (YMError *error in errors) {
        [dictionary addEntriesFromDictionary:@{
                [NSNumber numberWithInt :index] : @{@"code" : error.code, @"text" : error.text}
        }];
        index++;
    }

    return [NSError errorWithDomain:@"" code:200 userInfo:dictionary];
}

@end