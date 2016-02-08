//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSummarySourcesCell.h"
#import "YMValueTypeStringFormat.h"

@interface YMSummarySourcesCell ()

@property(nonatomic, strong) IBOutlet UILabel *maxValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *maxTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel *maxTextLabel;
@property(nonatomic, strong) IBOutlet UILabel *secondResultLabel;
@property(nonatomic, strong) IBOutlet UILabel *thirdResultLabel;

@end

@implementation YMSummarySourcesCell

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGFloat kTotalValueCenterY = 57;
    static CGFloat kTotalTypeCenterY = 68;
    static CGFloat kSpaceBetweenTotalLabels = 7;
    [self.maxValueLabel sizeToFit];
    [self.maxTypeLabel sizeToFit];
    self.maxValueLabel.centerY = kTotalValueCenterY;
    self.maxTypeLabel.centerY = kTotalTypeCenterY;
    self.maxTypeLabel.left = self.maxValueLabel.right + kSpaceBetweenTotalLabels;
}

- (void)fillWithMaxValue:(YMValueTypeStringFormat *)maxValue
                 maxText:(NSString *)maxText
             secondValue:(YMValueTypeStringFormat *)secondValue
              secondText:(NSString *)secondText
              trirdValue:(YMValueTypeStringFormat *)thirdValue
               thirdText:(NSString *)thirdText {
    self.maxValueLabel.text = maxValue.value;
    self.maxTypeLabel.text = (maxValue.type != nil && maxValue.type.length > 0) ? [NSString stringWithFormat:@"%@.", maxValue.type] : @"";
    self.maxTextLabel.text = maxText;

    if (secondValue) {
        self.secondResultLabel.hidden = NO;
        self.secondResultLabel.attributedText = [self attributedStringForValue:secondValue secondText:secondText];
        if (thirdValue) {
            self.thirdResultLabel.hidden = NO;
            self.thirdResultLabel.attributedText = [self attributedStringForValue:thirdValue secondText:thirdText];
        }
        else {
            self.thirdResultLabel.hidden = YES;
        }
    } else {
        self.secondResultLabel.hidden = YES;
        self.thirdResultLabel.hidden = YES;
    }
}

- (NSMutableAttributedString *)attributedStringForValue:(YMValueTypeStringFormat *)value secondText:(NSString *)text {
    static NSDictionary *regularAttributes = nil;
    static NSDictionary *boldAttributes = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        regularAttributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10]
        };
        boldAttributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10]
        };
    });
    NSAttributedString *firstPart;
    if (value.type && value.type.length > 0) {
        firstPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@.", value.value, value.type] attributes:boldAttributes];
    } else {
        firstPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", value.value] attributes:boldAttributes];
    }
    NSAttributedString *secondPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@", text] attributes:regularAttributes];

    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:firstPart];
    [resultString appendAttributedString:secondPart];
    return resultString;
}

@end