//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMSummaryOSCell.h"
#import "NSString+DKAdditions.h"

@interface YMSummaryOSCell ()

@property(nonatomic, strong) IBOutlet UIView *firstBlockView;
@property(nonatomic, strong) IBOutlet UILabel *firstIcon;
@property(nonatomic, strong) IBOutlet UILabel *secondIcon;
@property(nonatomic, strong) IBOutlet UILabel *thirdIcon;
@property(nonatomic, strong) IBOutlet UILabel *firstNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *secondNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *thirdNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *firstPercentLabel;
@property(nonatomic, strong) IBOutlet UILabel *secondPercentLabel;
@property(nonatomic, strong) IBOutlet UILabel *thirdPercentLabel;


@end

@implementation YMSummaryOSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstIcon.font = self.secondIcon.font = self.thirdIcon.font = [UIFont fontWithName:@"FontAwesome" size:20];
}


- (void)fillWithFirstName:(NSString *)firstName firstPercent:(CGFloat)firstPercent secondName:(NSString *)secondName secondPercent:(CGFloat)secondPercent thirdName:(NSString *)thirdName thirdPercent:(CGFloat)thirdPercent color:(UIColor *)color {
    self.firstBlockView.backgroundColor = color;
    self.firstIcon.textColor = color;
    if (firstName) {
        self.firstNameLabel.hidden = self.firstPercentLabel.hidden = self.firstIcon.hidden = NO;
        self.firstNameLabel.text = firstName;
        self.firstIcon.text = [self findCharacterForOSName:firstName];
        [self fillLabel:self.firstPercentLabel withPercent:firstPercent];
        if (secondName) {
            self.secondNameLabel.hidden = self.secondPercentLabel.hidden = self.secondIcon.hidden = NO;
            self.secondNameLabel.text = secondName;
            self.secondIcon.text = [self findCharacterForOSName:secondName];
            [self fillLabel:self.secondPercentLabel withPercent:secondPercent];
            if (thirdName) {
                self.thirdNameLabel.hidden = self.thirdPercentLabel.hidden = self.thirdIcon.hidden = NO;
                self.thirdNameLabel.text = thirdName;
                self.thirdIcon.text = [self findCharacterForOSName:thirdName];
                [self fillLabel:self.thirdPercentLabel withPercent:thirdPercent];
            } else {
                self.thirdNameLabel.hidden = self.thirdPercentLabel.hidden = self.thirdIcon.hidden = YES;
            }
        } else {
            self.secondNameLabel.hidden = self.secondPercentLabel.hidden = self.secondIcon.hidden = YES;
            self.thirdNameLabel.hidden = self.thirdPercentLabel.hidden = self.thirdIcon.hidden = YES;
        }
    } else {
        self.firstNameLabel.hidden = self.firstPercentLabel.hidden = self.firstIcon.hidden = YES;
        self.secondNameLabel.hidden = self.secondPercentLabel.hidden = self.secondIcon.hidden = YES;
        self.thirdNameLabel.hidden = self.thirdPercentLabel.hidden = self.thirdIcon.hidden = YES;
    }
}

- (void)fillLabel:(UILabel *)label withPercent:(CGFloat)percent {
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
    label.attributedText = resultString;
}

-(NSString *)findCharacterForOSName:(NSString *)osName {
    NSString *lowerCaseOsName = [osName lowercaseString];
    if ([lowerCaseOsName matchesSubstring:@"ios"] || [lowerCaseOsName matchesSubstring:@"mac"]) {
        return @"";
    } else if ([lowerCaseOsName matchesSubstring:@"gnu"] || [lowerCaseOsName matchesSubstring:@"linux"]) {
        return @"";
    } else if ([lowerCaseOsName matchesSubstring:@"windows"]) {
        return @"";
    } else if ([lowerCaseOsName matchesSubstring:@"android"]) {
        return @"";
    } else {
        return @"";
    }
}

@end