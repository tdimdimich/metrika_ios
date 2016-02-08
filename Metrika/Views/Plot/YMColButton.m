//
// Created by Dmitry Korotchenkov on 09.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMColButton.h"
#import "YMColGroup.h"
#import "YMGradientColor.h"
#import "YMColButtonView.h"

@implementation YMColButton

+ (YMColButton *)buttonWithGroup:(YMColGroup *)group color:(YMGradientColor *)color {
    return [[self alloc] initWithGroup:group color:color];
}

- (id)initWithGroup:(YMColGroup *)group color:(YMGradientColor *)color {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.colView = [YMColButtonView buttonWithGroup:group color:color];
        [self addSubview:self.colView];
    }

    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self.colView setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.colView setSelected:selected];
}

@end