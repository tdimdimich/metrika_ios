//
// File: YMProgressBar.m
// Project: Metrika
//
// Created by dkorneev on 8/28/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMProgressBar.h"

static const CGFloat kMarkWidth = 2;
static const CGFloat kMarkSpace = 2;

@interface YMProgressBar ()
@property(nonatomic, strong) NSArray *marks;
@end

@implementation YMProgressBar

+ (UIColor *)markedColor {
    return [UIColor colorWithRed:36.0 / 255.0 green:161.0 / 255.0 blue:232.0 / 255.0 alpha:1];
}

+ (UIColor *)notMarkedColor {
    return [UIColor whiteColor];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initMarks];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initMarks];
    }
    return self;
}

- (void)initMarks {
    NSUInteger marksCount = (NSUInteger) roundf((self.frame.size.width / kMarkWidth - 1) / 2);
    NSMutableArray *marks = [NSMutableArray new];
    UIView *curMark = nil;
    for (NSUInteger i = 0; i < marksCount; i++) {
        curMark = [[UIView alloc] initWithFrame:CGRectMake(i * kMarkWidth + i * kMarkSpace, 0, kMarkWidth, self.frame.size.height)];
        curMark.backgroundColor = [YMProgressBar notMarkedColor];
        [self addSubview:curMark];
        [marks addObject:curMark];
    }
    self.marks = marks;
}

// TODO: доработать метод чтобы он убирал выделение ячеек
- (void)setProgress:(NSUInteger)progress animated:(BOOL)animated {
    if (progress > 100)
        return;

    NSUInteger markedMarksCount = (NSUInteger) roundf((progress / 100.0) * self.marks.count);
    UIView *curMark = nil;
    for (NSUInteger i = 0; i < markedMarksCount; i++) {
        curMark = self.marks[i];
        if (animated) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 curMark.backgroundColor = [YMProgressBar markedColor];
                             }
                             completion:nil];
        } else {
            curMark.backgroundColor = [YMProgressBar markedColor];
        }
    }
    [self setNeedsDisplay];
}

@end