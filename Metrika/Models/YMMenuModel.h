//
// File: YMMenuModel.h
// Project: Metrika
//
// Created by dkorneev on 9/23/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef enum {
    YMMenuModelLevelFirst,
    YMMenuModelLevelSecond
} YMMenuModelLevel;

@interface YMMenuModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Class controllerClass;
@property (nonatomic, strong) NSArray *subRecords;
@property (nonatomic, weak, readonly) YMMenuModel *superRecord;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL opened;
@property (nonatomic) YMMenuModelLevel level;

+ (YMMenuModel *)newModelWithName:(NSString *)name controllerClass:(Class)controllerClass level:(YMMenuModelLevel)level;

+ (YMMenuModel *)newModelWithName:(NSString *)name controllerClass:(Class)controllerClass level:(YMMenuModelLevel)level andSubrecords:(NSArray *)subRecords;

- (BOOL)canBeOpened;

@end