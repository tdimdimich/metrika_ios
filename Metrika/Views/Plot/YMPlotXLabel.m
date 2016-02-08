//
// Created by Dmitry Korotchenkov on 01.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/DKUtils.h>
#import "YMPlotXLabel.h"
#import "UIView+DKViewAdditions.h"
#import "YMUtils.h"
#import "NSString+YMAdditions.h"

static const int kSecondLabelOffset = 6;

@interface YMPlotXLabel ()
@property(nonatomic, strong) UILabel *firstLabel;
@property(nonatomic, strong) UILabel *secondLabel;
@property(nonatomic, strong) UIImageView *arrow;
@property(nonatomic) CGFloat centerLabelPosition;
@end

@implementation YMPlotXLabel

+ (UIFont *)font {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9];
    }
    return font;
}

- (id)initWithFirstLineText:(NSString *)firstText secondLineText:(NSString *)secondText value:(CGFloat)value {
    CGSize size = [firstText sizeForFont:[YMPlotXLabel font]];
    CGFloat firstWidth = size.width;
    CGFloat secondWidth = [secondText sizeForFont:[YMPlotXLabel font]].width + kSecondLabelOffset;
    CGFloat width = firstWidth > secondWidth ? firstWidth : secondWidth;

    self = [super initWithFrame:CGRectMake(0, 0, width, kPlotXLabelViewHeight)];
    if (self) {
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        self.value = value;
        self.centerLabelPosition = self.height - 5 - size.height;

        CGSize secondLineSize = [secondText sizeForFont:[YMPlotXLabel font]];
        self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSecondLabelOffset, [self topForPosition:YMPlotXLabelTextPositionBottom], secondLineSize.width, secondLineSize.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multilines-label-wrap.png"]];
        imageView.bottom = self.secondLabel.centerY + 1;
        imageView.left = 0;
        YMPlotXLabelTextPosition firstLinePosition;
        if (secondText && secondText.length) {
            firstLinePosition = YMPlotXLabelTextPositionTop;
        } else {
            firstLinePosition = YMPlotXLabelTextPositionCenter;
            self.secondLabel.hidden = YES;
            imageView.hidden = YES;
        }
        self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [self topForPosition:firstLinePosition], firstWidth, size.height)];
        self.firstLabel.font = self.secondLabel.font = [YMPlotXLabel font];
        self.firstLabel.backgroundColor = self.secondLabel.backgroundColor = [UIColor clearColor];
        self.firstLabel.text = firstText;
        self.secondLabel.text = secondText;
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        [self addSubview:imageView];

        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-down.png"]];
        self.arrow.userInteractionEnabled = NO;
        self.arrow.top = 5;
        self.arrow.centerX = self.innerCenterX;
        [self addSubview:self.arrow];
        self.selected = NO;
        [self showArrow:NO];
    }

    return self;

}

- (CGFloat)topForPosition:(YMPlotXLabelTextPosition)position {
    NSInteger offset = (NSInteger) ceilf([YMPlotXLabel font].pointSize / 2);
    switch (position) {
        case YMPlotXLabelTextPositionTop:
            return self.centerLabelPosition - offset;
        case YMPlotXLabelTextPositionBottom:
            return self.centerLabelPosition + offset;
        default:
            return self.centerLabelPosition;
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        self.firstLabel.textColor = self.secondLabel.textColor = [UIColor whiteColor];
    } else {
        self.firstLabel.textColor = self.secondLabel.textColor = [DKUtils colorWithRed:165 green:165 blue:165];
    }
}

- (void)showArrow:(BOOL)yesNo {
    self.arrow.hidden = !yesNo;
}

@end