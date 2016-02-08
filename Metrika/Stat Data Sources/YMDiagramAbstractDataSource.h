//
// Created by Dmitry Korotchenkov on 06/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMDiagramDataSource.h"

@class YMDetailedElementModel;


@interface YMDiagramAbstractDataSource : NSObject <YMDiagramDataSource>

// must be overridden
- (NSArray *)typeTitles;
// must be overridden
- (NSString *)titleForData:(id)data;
// must be overridden
- (CGFloat)mainValueForData:(id)data;
// must be overridden
- (NSNumber *)data:(id)data valueForIndex:(NSUInteger)index1;
// must be overridden
- (BOOL)isIndexForPercentValue:(NSUInteger)index1;
// must be overridden
- (BOOL)isIndexForTimeValue:(NSUInteger)index1;
// must be overridden
- (BOOL)isIndexForCalculateAverageValue:(NSUInteger)index1;
// must be overridden
- (NSUInteger)indexOfValueForCalculateAverage;

- (CGFloat)totalValueForIndex:(NSUInteger)typeIndex;

- (YMDetailedElementModel *)detailedModelForPercentValue:(NSNumber *)value title:(NSString *)title;

- (YMDetailedElementModel *)detailedModelForTimeValue:(NSNumber *)value title:(NSString *)title percent:(CGFloat)percent;

- (YMDetailedElementModel *)detailedModelForNumericValue:(NSNumber *)value title:(NSString *)title percent:(CGFloat)percent;

@property(nonatomic) NSUInteger selectedTypeIndex;

@property(nonatomic) NSUInteger selectedRowIndex;
@property(nonatomic, strong) NSArray *data;

@end