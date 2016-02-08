//
// Created by Dmitry Korotchenkov on 30/01/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMGraphInfoElementCell.h"
#import "YMGraphInfoElementView.h"


@implementation YMGraphInfoElementCell

+ (instancetype)getInstance {
    return [[[NSBundle mainBundle] loadNibNamed:@"YMGraphInfoElementCell" owner:nil options:nil] objectAtIndex:0];
}

- (UIView *)createElementView {
    YMGraphInfoElementView *elementView = [YMGraphInfoElementView createView];
    return elementView;
}

-(CGFloat)elementRightMargin {
    return 36;
}

- (void)fillWithTitle:(NSString *)title model:(YMElementModel *)model color:(UIColor *)color separatorColor:(UIColor *)separatorColor {
    [self fillWithTitle:title model:model color:color detailedModels:nil separatorColor:separatorColor];
}

- (void)fillWithTitle:(NSString *)title model:(YMElementModel *)model color:(UIColor *)color detailedModels:(NSArray *)detailedModels separatorColor:(UIColor *)separatorColor {
    YMGraphInfoElementView *element = self.elements[0];
    [element fillWithModel:model color:color];
//    for (NSUInteger i = 0; i < array.count && i < self.elements.count; i++) {
//        YMElementModel *model = array[i];
//    }
    [self fillWithTitle:title color:color detailedModels:detailedModels separatorColor:separatorColor];

}

@end