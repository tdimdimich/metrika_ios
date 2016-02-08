//
// Created by Dmitry Korotchenkov on 15/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <Foundation/Foundation.h>

@class YMElementModel;

// provided by YMGraphInfoElementView.xib and YMDiagramInfoElementView.xib
static CGFloat kInfoElementViewHeight = 26;

// provided by YMAbstractInfoElementCell.xib
static NSString *const kInfoElementCellID = @"infoElementCellID";

@interface YMAbstractInfoElementCell : UITableViewCell

@property(nonatomic, strong) NSArray *elements;

@property(nonatomic, strong) IBOutlet UIButton *arrowButton;

+ (CGFloat)openedHeightForDetailsCount:(NSUInteger)count;

+ (CGFloat)closedHeight;

+ (instancetype)createCell;

- (void)fillWithTitle:(NSString *)title color:(UIColor *)color detailedModels:(NSArray *)detailedModels separatorColor:(UIColor *)separatorColor;

@end