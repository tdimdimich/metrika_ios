//
// Created by Dmitry Korotchenkov on 31/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMListControl;


@interface YMDiagramLandscapeView : UIView

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet YMListControl *listControl;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalValueTypeLabel;

+ (instancetype)createView;

- (void)configUI;

- (void)setTotalValue:(NSString *)totalValue totalType:(NSString *)totalType;

- (void)hideTotalValue;
@end