//
// Created by Dmitry Korotchenkov on 09/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMSummaryBrowsersCellElement.h"
#import "NSString+DKAdditions.h"

@interface YMSummaryBrowsersCellElement ()

@property(nonatomic, strong) IBOutlet UIView *percentView;
@property(nonatomic, strong) IBOutlet UIImageView *iconView;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *percentLabel;

@end

@implementation YMSummaryBrowsersCellElement

+ (instancetype)createView {
    return [[[NSBundle mainBundle] loadNibNamed:@"YMSummaryBrowsersCellElement" owner:nil options:nil] objectAtIndex:0];
}

- (void)fillWithBrowserName:(NSString *)browserName percent:(CGFloat)percent color:(UIColor *)color {
    color = color ?: [UIColor blackColor];
    self.percentView.backgroundColor = self.titleLabel.textColor = self.percentLabel.textColor = color;
    self.titleLabel.text = browserName;
    self.percentView.width = (percent / 100) * self.percentView.superview.width;
    [self fillPercentLabelWithValue:percent];
    self.iconView.image = [self findIconForBrowserName:browserName];
}

- (UIImage *)findIconForBrowserName:(NSString *)osName {
    NSString *lowerCaseOsName = [osName lowercaseString];
    if ([lowerCaseOsName matchesSubstring:@"chrome"]) {
        return [UIImage imageNamed:@"browser-icon-chrome.png"];
    } else if ([lowerCaseOsName matchesSubstring:@"safari"]) {
        return [UIImage imageNamed:@"browser-icon-safari.png"];
    } else if ([lowerCaseOsName matchesSubstring:@"firefox"]) {
        return [UIImage imageNamed:@"browser-icon-firefox.png"];
    } else if ([lowerCaseOsName matchesSubstring:@"opera"]) {
        return [UIImage imageNamed:@"browser-icon-opera.png"];
    } else if ([lowerCaseOsName matchesSubstring:@"msie"]) {
        return [UIImage imageNamed:@"browser-icon-ie.png"];
    } else {
        return [UIImage imageNamed:@"browser-icon-unknown.png"];
    }
}

- (void)fillPercentLabelWithValue:(CGFloat)percent {
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
    percent = (CGFloat) (round(percent*10) / 10.0f);
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
    self.percentLabel.attributedText = resultString;
}

@end