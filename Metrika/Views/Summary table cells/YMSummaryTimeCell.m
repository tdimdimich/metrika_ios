//
// Created by Dmitry Korotchenkov on 07/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSummaryTimeCell.h"
#import "YMValueTypeStringFormat.h"
#import "NSDate+DKAdditions.h"

@interface YMSummaryTimeCell ()

@property(nonatomic, strong) IBOutlet UILabel *totalValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *totalTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel *maxRecordLabel;

@end

@implementation YMSummaryTimeCell

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGFloat kTotalValueCenterY = 57;
    static CGFloat kTotalTypeCenterY = 68;
    static CGFloat kSpaceBetweenTotalLabels = 7;
    [self.totalValueLabel sizeToFit];
    [self.totalTypeLabel sizeToFit];
    self.totalValueLabel.centerY = kTotalValueCenterY;
    self.totalTypeLabel.centerY = kTotalTypeCenterY;
    self.totalTypeLabel.left = self.totalValueLabel.right + kSpaceBetweenTotalLabels;
}


- (void)fillWithTotalValue:(YMValueTypeStringFormat *)totalValue maxRecordValue:(YMValueTypeStringFormat *)maxRecordValue maxRecordDate:(NSDate *)maxRecordDate {
    self.totalValueLabel.text = totalValue.value;
    self.totalTypeLabel.text = (totalValue.type != nil && totalValue.type.length > 0) ? [NSString stringWithFormat:@"%@.", totalValue.type] : @"";

    if (maxRecordValue && maxRecordDate) {
        self.maxRecordLabel.hidden = NO;
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

        NSAttributedString *firstPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Record: %@ - ", @"Рекорд: %@ - "), [maxRecordDate stringWithFormat:@"dd.LL.yyyy"]] attributes:regularAttributes];
        NSAttributedString *secondPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@.", maxRecordValue.value, maxRecordValue.type] attributes:boldAttributes];

        NSMutableAttributedString *dailyAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:firstPart];
        [dailyAttributedString appendAttributedString:secondPart];
        self.maxRecordLabel.attributedText = dailyAttributedString;
    } else {
        self.maxRecordLabel.hidden = YES;
    }

    [self setNeedsLayout];
}

@end