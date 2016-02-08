//
// File: YMMenuModel.m
// Project: Metrika
//
// Created by dkorneev on 9/23/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMMenuModel.h"
#import "NSArray+BlocksKit.h"


@implementation YMMenuModel

+ (YMMenuModel *)newModelWithName:(NSString *)name controllerClass:(Class)controllerClass level:(YMMenuModelLevel)level {
    return [self newModelWithName:name controllerClass:controllerClass level:level andSubrecords:nil];
}

+ (YMMenuModel *)newModelWithName:(NSString *)name controllerClass:(Class)controllerClass level:(YMMenuModelLevel)level andSubrecords:(NSArray *)subRecords {
    YMMenuModel *ret = [[YMMenuModel alloc] init];
    ret.name = name;
    ret.controllerClass = controllerClass;
    ret.subRecords = subRecords;
    [subRecords bk_each:^(YMMenuModel *subRecord) {
        subRecord->_superRecord = ret;
    }];
    ret.selected = NO;
    ret.opened = NO;
    ret.level = level;
    return ret;
}

- (BOOL)canBeOpened {
    return self.subRecords && self.subRecords.count;
}

@end