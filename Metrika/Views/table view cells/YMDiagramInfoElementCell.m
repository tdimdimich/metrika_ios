//
// Created by Dmitry Korotchenkov on 30/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMDiagramInfoElementCell.h"
#import "YMGraphInfoElementView.h"
#import "YMUtils.h"
#import "YMDiagramInfoElementView.h"


@implementation YMDiagramInfoElementCell

+ (instancetype)getInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"YMDiagramInfoElementCell" owner:nil options:nil] objectAtIndex:0];
}

- (UIView *)createElementView {
    return [YMDiagramInfoElementView createView];
}

- (void)fillWithTitle:(NSString *)title value:(CGFloat)value color:(UIColor *)color separatorColor:(UIColor *)separatorColor {
    [self fillWithTitle:title value:value color:color detailedModels:nil separatorColor:separatorColor];
}

- (void)fillWithTitle:(NSString *)title value:(CGFloat)value color:(UIColor *)color detailedModels:(NSArray *)detailedModels separatorColor:(UIColor *)separatorColor {
    YMDiagramInfoElementView *element = self.elements[0];
    [element fillWithValue:value color:color];
    [self fillWithTitle:title color:color detailedModels:detailedModels separatorColor:separatorColor];
}


@end