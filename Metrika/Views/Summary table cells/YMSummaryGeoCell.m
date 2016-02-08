//
// Created by Dmitry Korotchenkov on 16/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSummaryGeoCell.h"
#import "UIImage+DKAdditions.h"
#import "YMValueTypeStringFormat.h"
#import "NSString+YMAdditions.h"

@interface YMSummaryGeoCell ()

@property(nonatomic, strong) IBOutlet UIView *containerView;

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

@implementation YMSummaryGeoCell

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize maxSize = CGSizeMake(145, 31);
    self.firstTitle.width = ceilf([self.firstTitle.text sizeForFont:self.firstTitle.font constrainedToSize:maxSize].width);
    self.secondTitle.width = ceilf([self.secondTitle.text sizeForFont:self.secondTitle.font constrainedToSize:maxSize].width);
    self.thirdTitle.width = ceilf([self.thirdTitle.text sizeForFont:self.thirdTitle.font constrainedToSize:maxSize].width);
    CGFloat maxRight = MAX(MAX(self.firstTitle.right, self.secondTitle.right), self.thirdTitle.right);
    self.containerView.width = maxRight;
    self.containerView.right = self.firstPercent.left - 5;
}


- (void)fillWithFirstTitle:(NSString *)firstTitle firstValue:(YMValueTypeStringFormat *)firstValue secondTitle:(NSString *)secondTitle secondValue:(YMValueTypeStringFormat *)secondValue thirdTitle:(NSString *)thirdTitle thirdValue:(YMValueTypeStringFormat *)thirdValue color:(UIColor *)color {
    self.firstLine.hidden = self.firstPercent.hidden = self.firstTitle.hidden = firstTitle == nil;
    self.secondLine.hidden = self.secondPercent.hidden = self.secondTitle.hidden = secondTitle == nil;
    self.thirdLine.hidden = self.thirdPercent.hidden = self.thirdTitle.hidden = thirdTitle == nil;
    self.firstTitle.textColor = self.firstPercent.textColor = color;
    self.firstLine.image = [UIImage imageWithMaskImage:[UIImage imageNamed:@"summary-age-top-line.png"] color:color];
    self.firstTitle.text = firstTitle ?: @"";
    self.secondTitle.text = secondTitle ?: @"";
    self.thirdTitle.text = thirdTitle ?: @"";
    if (firstValue) {
        self.firstPercent.attributedText = [self percentAttributedStringWithValue:firstValue];
    }
    if (secondValue) {
        self.secondPercent.attributedText = [self percentAttributedStringWithValue:secondValue];
    }
    if (thirdValue) {
        self.thirdPercent.attributedText = [self percentAttributedStringWithValue:thirdValue];
    }
    [self setNeedsLayout];
}

- (NSAttributedString *)percentAttributedStringWithValue:(YMValueTypeStringFormat *)stringFormat {
    static NSDictionary *regular20Attributes = nil;
    static NSDictionary *bold20Attributes = nil;
    static NSDictionary *regular10Attributes = nil;
    static NSDictionary *bold10Attributes = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        regular20Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:20]
        };
        bold20Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20]
        };
        regular10Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10]
        };
        bold10Attributes = @{
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10]
        };
    });
    NSAttributedString *firstPart = [[NSAttributedString alloc] initWithString:@"(" attributes:regular20Attributes];

    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:firstPart];
    [resultString appendAttributedString:[[NSAttributedString alloc] initWithString:stringFormat.value attributes:bold20Attributes]];
    if (stringFormat.type && stringFormat.type.length > 0) {
        [resultString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@.", stringFormat.type] attributes:bold10Attributes]];
    }
    [resultString appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"visits", @" визитов") attributes:regular10Attributes]];
    [resultString appendAttributedString:[[NSAttributedString alloc] initWithString:@")" attributes:regular20Attributes]];
    return resultString;
}

@end