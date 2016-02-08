//
// Created by Dmitry Korotchenkov on 16/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMSummaryAgeCell.h"
#import "UIImage+DKAdditions.h"

@interface YMSummaryAgeCell ()

@property(nonatomic, strong) IBOutlet UIImageView *firstLine;
@property(nonatomic, strong) IBOutlet UIView *secondLine;
@property(nonatomic, strong) IBOutlet UIImageView *thirdLine;
@property(nonatomic, strong) IBOutlet UILabel *firstTitle;
@property(nonatomic, strong) IBOutlet UILabel *secondTitle;
@property(nonatomic, strong) IBOutlet UILabel *thirdTitle;
@property(nonatomic, strong) IBOutlet UILabel *firstPercent;
@property(nonatomic, strong) IBOutlet UILabel *secondPercent;
@property(nonatomic, strong) IBOutlet UILabel *thirdPercent;

@end

@implementation YMSummaryAgeCell

- (void)fillWithFirstTitle:(NSString *)firstTitle firstPercent:(CGFloat)firstPercent secondTitle:(NSString *)secondTitle secondPercent:(CGFloat)secondPercent thirdTitle:(NSString *)thirdTitle thirdPercent:(CGFloat)thirdPercent color:(UIColor *)color {
    self.firstLine.hidden = self.firstPercent.hidden = self.firstTitle.hidden = firstTitle == nil;
    self.secondLine.hidden = self.secondPercent.hidden = self.secondTitle.hidden = secondTitle == nil;
    self.thirdLine.hidden = self.thirdPercent.hidden = self.thirdTitle.hidden = thirdTitle == nil;
    self.firstTitle.textColor = self.firstPercent.textColor = color;
    self.firstLine.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-age-top-line.png"] color:color];
    self.firstTitle.text = firstTitle ?: @"";
    self.secondTitle.text = secondTitle ?: @"";
    self.thirdTitle.text = thirdTitle ?: @"";
    self.firstPercent.attributedText = [self percentAttributedStringWithValue:firstPercent * 100];
    self.secondPercent.attributedText = [self percentAttributedStringWithValue:secondPercent * 100];
    self.thirdPercent.attributedText = [self percentAttributedStringWithValue:thirdPercent * 100];
}

- (NSAttributedString *)percentAttributedStringWithValue:(CGFloat)percent {
    static NSDictionary *regular20Attributes = nil;
    static NSDictionary *bold20Attributes = nil;
    static NSDictionary *bold12Attributes = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        regular20Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:20]
        };
        bold20Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
        };
        bold12Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12]
        };
    });
    percent = (CGFloat) (round(percent * 10) / 10.0f);
    NSString *percentString;
    if (percent == roundf(percent)) {
        percentString = [NSString stringWithFormat:@"%0.0f", percent];
    } else {
        percentString = [NSString stringWithFormat:@"%0.1f", percent];
    }
    NSAttributedString *firstPart = [[NSAttributedString alloc] initWithString:@"(" attributes:regular20Attributes];
    NSAttributedString *secondPart = [[NSAttributedString alloc] initWithString:percentString attributes:bold20Attributes];
    NSAttributedString *thirdPart = [[NSAttributedString alloc] initWithString:@"%" attributes:bold12Attributes];
    NSAttributedString *fourthPart = [[NSAttributedString alloc] initWithString:@")" attributes:regular20Attributes];

    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:firstPart];
    [resultString appendAttributedString:secondPart];
    [resultString appendAttributedString:thirdPart];
    [resultString appendAttributedString:fourthPart];
    return resultString;
}

@end