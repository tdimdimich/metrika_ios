//
// Created by Dmitry Korotchenkov on 16/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/DKUtils.h>
#import "YMSummaryGenderCell.h"
#import "YMValueTypeStringFormat.h"
#import "YMUtils.h"
#import "UIImage+DKAdditions.h"

@interface YMSummaryGenderCell ()

@property(nonatomic, strong) IBOutlet UIImageView *maleImageView;
@property(nonatomic, strong) IBOutlet UIImageView *femaleImageView;
@property(nonatomic, strong) IBOutlet UILabel *percentLabel;


@end

@implementation YMSummaryGenderCell

- (void)fillWithMaleValue:(CGFloat)maleValue femaleValue:(CGFloat)femaleValue color:(UIColor *)color {
    static NSDictionary *bigAttributes = nil;
    static NSDictionary *smallAttributes = nil;
    static UIColor *defaultColor = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        defaultColor = [DKUtils colorWithRed:204 green:204 blue:204];
        bigAttributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:30]
        };
        smallAttributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:19]
        };
    });
    if (maleValue > femaleValue) {
        self.maleImageView.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-male-icon.png"] color:color];
        self.femaleImageView.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-female-icon.png"] color:defaultColor];
    } else if (femaleValue > maleValue) {
        self.maleImageView.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-male-icon.png"] color:defaultColor];
        self.femaleImageView.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-female-icon.png"] color:color];
    } else {
        self.maleImageView.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-male-icon.png"] color:defaultColor];
        self.femaleImageView.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-female-icon.png"] color:defaultColor];
    }

    NSMutableAttributedString *maleString = [self createAttributedString:maleValue bigAttributes:bigAttributes smallAttributes:smallAttributes];
    NSMutableAttributedString *femaleString = [self createAttributedString:femaleValue bigAttributes:bigAttributes smallAttributes:smallAttributes];
    NSMutableAttributedString *slashString = [[NSMutableAttributedString alloc] initWithString:@" / " attributes:bigAttributes];
    [slashString addAttribute:NSForegroundColorAttributeName value:defaultColor range:NSMakeRange(0, slashString.length)];
    [maleString addAttribute:NSForegroundColorAttributeName value:((maleValue > femaleValue) ? color : defaultColor) range:NSMakeRange(0, maleString.length)];
    [femaleString addAttribute:NSForegroundColorAttributeName value:((maleValue < femaleValue) ? color : defaultColor) range:NSMakeRange(0, femaleString.length)];

    [maleString appendAttributedString:slashString];
    [maleString appendAttributedString:femaleString];
    self.percentLabel.attributedText = maleString;
}

- (NSMutableAttributedString *)createAttributedString:(CGFloat)value bigAttributes:(NSDictionary *)bigAttributes smallAttributes:(NSDictionary *)smallAttributes {
    CGFloat roundedValue = (CGFloat) (round(value * 1000) / 10.0f);
    NSAttributedString *firstPart = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.1f", roundedValue] attributes:bigAttributes];
    NSAttributedString *secondPart = [[NSAttributedString alloc] initWithString:@"%" attributes:smallAttributes];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:firstPart];
    [attributedString appendAttributedString:secondPart];
    return attributedString;
}

@end