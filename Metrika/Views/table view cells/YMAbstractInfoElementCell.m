//
// Created by Dmitry Korotchenkov on 15/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMAbstractInfoElementCell.h"
#import "YMGraphInfoElementView.h"
#import "UIView+DKViewAdditions.h"
#import "YMElementModel.h"
#import "DKUtils.h"
#import "YMDetailedInfoElementView.h"
#import "YMDetailedElementModel.h"

static const int kTableSeparatorHeight = 1;
static CGFloat kElementRightMargin = 34;
static CGFloat kMarginBetweenElements = 10;
static CGFloat kMarginBetweenDatailedElements = 4;

@interface YMAbstractInfoElementCell ()

@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) NSMutableArray *detailedElements;
@property(nonatomic, strong) UIColor *defaultSeparatorColor;
@property(nonatomic, strong) UIView *separator;
@end

@implementation YMAbstractInfoElementCell

+ (CGFloat)openedHeightForDetailsCount:(NSUInteger)count {
    CGFloat height = [self closedHeightForCount:1];
    height += count * kDetailedInfoElementViewHeight + (count - 1) * kMarginBetweenDatailedElements + kMarginBetweenElements;
    return height;
}

+ (CGFloat)closedHeight {
    return [self closedHeightForCount:1];
}

+ (CGFloat)closedHeightForCount:(NSUInteger)count {
    return count * (kInfoElementViewHeight + kMarginBetweenElements) + kMarginBetweenElements + kTableSeparatorHeight;
}

+ (instancetype)createCell {
    return [self createCellForCount:1];
}

+ (YMAbstractInfoElementCell *)createCellForCount:(NSUInteger)count {
    YMAbstractInfoElementCell *instance= [self getInstance];
    [instance setupForCount:count];
    return instance;
}

// must be overridden
+ (instancetype)getInstance {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)setupForCount:(NSUInteger)count {
    self.detailedElements = [NSMutableArray new];
    NSMutableArray *elements = [NSMutableArray new];
    for (NSUInteger i = 0; i < count; i++) {
        UIView *elementView= [self createElementView];
        [self addSubview:elementView];
        [elements addObject:elementView];
    }
    self.defaultSeparatorColor = [DKUtils colorWithRed:192 green:192 blue:192];
    self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kTableSeparatorHeight, self.width, kTableSeparatorHeight)];
    self.separator.backgroundColor = self.defaultSeparatorColor;
    self.separator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.separator];
    self.elements = [NSArray arrayWithArray:elements];
}

// must be overridden
- (UIView *)createElementView {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)fillWithTitle:(NSString *)title color:(UIColor *)color detailedModels:(NSArray *)detailedModels separatorColor:(UIColor *)separatorColor {
    self.titleLabel.text = title;

    NSUInteger detailedCountNew = detailedModels ? detailedModels.count : 0;
    NSUInteger detailedCountCurrent = self.detailedElements.count;
    if (detailedCountCurrent < detailedCountNew) {
        for (NSUInteger i = 0; i < detailedCountNew - detailedCountCurrent; i++) {
            YMDetailedInfoElementView *view = [YMDetailedInfoElementView createView];
            [self addSubview:view];
            [self.detailedElements addObject:view];
        }
    } else if (detailedCountCurrent > detailedCountNew) {
        for (NSUInteger i = 0; i < detailedCountCurrent - detailedCountNew; i++) {
            YMDetailedInfoElementView *view = [self.detailedElements lastObject];
            [view removeFromSuperview];
            [self.detailedElements removeObject:view];
        }
    }

    for (NSUInteger i = 0; i < detailedModels.count; i++) {
        YMDetailedElementModel *detailedModel = detailedModels[i];
        YMDetailedInfoElementView *detailedElement = self.detailedElements[i];
        [detailedElement fillWithColor:color model:detailedModel];
    }

    self.separator.backgroundColor = color ?: separatorColor ?: self.defaultSeparatorColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat topOffset = -kTableSeparatorHeight;
    if (self.detailedElements.count == 0) {
        self.arrowButton.selected = NO;
        topOffset += (self.height - [YMAbstractInfoElementCell closedHeightForCount:self.elements.count]) / 2;
        self.titleLabel.centerY = self.innerCenterY;
    } else {
        self.arrowButton.selected = YES;
        self.titleLabel.centerY = [YMAbstractInfoElementCell closedHeightForCount:self.elements.count] / 2;
    }
    for (NSUInteger i = 0; i < self.elements.count; i++) {
        YMGraphInfoElementView *element = [self.elements objectAtIndex:i];
        element.right = self.width - kElementRightMargin;
        element.top = topOffset + kMarginBetweenElements + i * (kInfoElementViewHeight + kMarginBetweenElements);
        if (i == 0) {
            self.arrowButton.bottom = element.bottom;
        }
    }
    CGFloat detailedElementsTop = [YMAbstractInfoElementCell closedHeight];
    for (NSUInteger i = 0; i < self.detailedElements.count; i++) {
        YMDetailedInfoElementView *detailedElement = [self.detailedElements objectAtIndex:i];
        detailedElement.left = 8;
        detailedElement.top = detailedElementsTop + topOffset + i * (kMarginBetweenDatailedElements + kDetailedInfoElementViewHeight);
    }
}

@end