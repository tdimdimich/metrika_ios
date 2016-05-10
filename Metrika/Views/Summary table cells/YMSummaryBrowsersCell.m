//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSummaryBrowsersCell.h"
#import "YMSummaryBrowsersCellElement.h"

static const int kMarginBetweenSummaryBrowsersCellElement = 11;

@interface YMSummaryBrowsersCell ()
@property(nonatomic, strong) YMSummaryBrowsersCellElement *firstElement;
@property(nonatomic, strong) YMSummaryBrowsersCellElement *secondElement;
@property(nonatomic, strong) YMSummaryBrowsersCellElement *thirdElement;
@end

@implementation YMSummaryBrowsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstElement = [YMSummaryBrowsersCellElement createView];
    self.secondElement = [YMSummaryBrowsersCellElement createView];
    self.thirdElement = [YMSummaryBrowsersCellElement createView];
    self.firstElement.translatesAutoresizingMaskIntoConstraints = NO;
    self.secondElement.translatesAutoresizingMaskIntoConstraints = NO;
    self.thirdElement.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.firstElement];
    [self.contentView addSubview:self.secondElement];
    [self.contentView addSubview:self.thirdElement];
    
    NSDictionary *views = @{@"firstElement": self.firstElement, @"secondElement": self.secondElement, @"thirdElement": self.thirdElement};
    NSDictionary *metrics = @{@"height": @(kSummaryBrowsersCellElementHeight), @"offset": @20};
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstElement]|" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[secondElement]|" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thirdElement]|" options:0 metrics:metrics views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-offset-[firstElement(height)]-offset-[secondElement(height)]-offset-[thirdElement(height)]" options:0 metrics:metrics views:views]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSUInteger visibleElementsCount = (self.firstElement.hidden ? 0 : 1) + (self.secondElement.hidden ? 0 : 1) + (self.thirdElement.hidden ? 0 : 1);
//    NSUInteger marginsCount = visibleElementsCount > 0 ? visibleElementsCount - 1 : 0;
//    CGFloat totalHeight = kSummaryBrowsersCellElementHeight * visibleElementsCount + kMarginBetweenSummaryBrowsersCellElement * marginsCount;
//    self.firstElement.top = self.innerCenterY - totalHeight/2;
//    self.secondElement.top = self.firstElement.bottom + kMarginBetweenSummaryBrowsersCellElement;
//    self.thirdElement.top = self.secondElement.bottom + kMarginBetweenSummaryBrowsersCellElement;
}

- (void)fillWithFirstName:(NSString *)firstName firstPercent:(CGFloat)firstPercent secondName:(NSString *)secondName secondPercent:(CGFloat)secondPercent thirdName:(NSString *)thirdName thirdPercent:(CGFloat)thirdPercent color:(UIColor *)color {
    if (firstName) {
        self.firstElement.hidden = NO;
        [self.firstElement fillWithBrowserName:firstName percent:firstPercent color:color];
        if (secondName) {
            self.secondElement.hidden = NO;
            [self.secondElement fillWithBrowserName:secondName percent:secondPercent color:[UIColor blackColor]];
            if (thirdName) {
                self.thirdElement.hidden = NO;
                [self.thirdElement fillWithBrowserName:thirdName percent:thirdPercent color:[UIColor blackColor]];
            } else {
                self.thirdElement.hidden = YES;
            }
        } else {
            self.secondElement.hidden = YES;
            self.thirdElement.hidden = YES;
        }
    } else {
        self.firstElement.hidden = YES;
        self.secondElement.hidden = YES;
        self.thirdElement.hidden = YES;
    }
}


@end