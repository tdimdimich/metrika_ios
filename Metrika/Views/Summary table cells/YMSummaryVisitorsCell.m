//
// Created by Dmitry Korotchenkov on 07/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSummaryVisitorsCell.h"
#import "YMValueTypeStringFormat.h"

@interface YMSummaryVisitorsCell ()

@property(nonatomic, strong) IBOutlet UILabel *totalValueLabel;
@property(nonatomic, strong) IBOutlet UILabel *totalTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel *dailyLabel;

@end

@implementation YMSummaryVisitorsCell

- (void)layoutSubviews {
    [super layoutSubviews];
//    static CGFloat kTotalValueCenterY = 60;
//    static CGFloat kTotalTypeCenterY = 71;
//    static CGFloat kSpaceBetweenTotalLabels = 7;
//    [self.totalValueLabel sizeToFit];
//    [self.totalTypeLabel sizeToFit];
//    self.totalValueLabel.centerY = kTotalValueCenterY;
//    self.totalTypeLabel.centerY = kTotalTypeCenterY;
//    CGFloat totalWidth = self.totalValueLabel.width + self.totalTypeLabel.width + kSpaceBetweenTotalLabels;
//    self.totalValueLabel.left = self.width / 2 - totalWidth / 2;
//    self.totalTypeLabel.left = self.totalValueLabel.right + kSpaceBetweenTotalLabels;
}


- (void)fillWithColor:(UIColor *)color totalValue:(YMValueTypeStringFormat *)totalValue dailyValue:(YMValueTypeStringFormat *)dailyValue {
    self.backgroundColor = self.contentView.backgroundColor = color;
    self.totalValueLabel.text = totalValue.value;
    self.totalTypeLabel.text = (totalValue.type != nil && totalValue.type.length > 0) ? [NSString stringWithFormat:@"%@.", totalValue.type] : @"";

    if (dailyValue && ![dailyValue.value isEqualToString:@"0"]) {
        self.dailyLabel.hidden = NO;
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

        NSAttributedString *firstPart = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"From them", @"Из них ") attributes:regularAttributes];
        NSString *dailyTypeString;
        if (dailyValue.type && dailyValue.type.length > 0) {
            dailyTypeString = [NSString stringWithFormat:@" %@.", dailyValue.type];
        } else {
            dailyTypeString = @"";
        }
        NSAttributedString *secondPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", dailyValue.value, dailyTypeString] attributes:boldAttributes];
        NSAttributedString *thirdPart = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"max auditory per day", @" - максимальная аудитория за сутки.") attributes:regularAttributes];

        NSMutableAttributedString *dailyAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:firstPart];
        [dailyAttributedString appendAttributedString:secondPart];
        [dailyAttributedString appendAttributedString:thirdPart];
        self.dailyLabel.attributedText = dailyAttributedString;
    } else {
        self.dailyLabel.hidden = YES;
    }

    [self setNeedsLayout];
}

@end