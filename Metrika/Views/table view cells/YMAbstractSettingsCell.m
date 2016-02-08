//
// Created by Dmitry Korotchenkov on 19.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMAbstractSettingsCell.h"

static const int kDetailedTextLabelWidth = 250;
static const int kDetailedTextLabelTop = 39;
static const int kDetailedTextMarginToBottom = 7;

static const int kNonDetailTextCellHeight = 43;

@interface YMAbstractSettingsCell ()

@property(nonatomic, strong) IBOutlet UILabel *mainTextLabel;
@property(nonatomic, strong) IBOutlet UILabel *detailedTextLabel;

@end

@implementation YMAbstractSettingsCell

+ (CGFloat)heightForDetailedText:(NSString *)text {
    if (text) {
        return kDetailedTextLabelTop + [self detailedLabelHeightForText:text] + kDetailedTextMarginToBottom;
    } else {
        return kNonDetailTextCellHeight;
    }
}

+ (CGFloat)detailedLabelHeightForText:(NSString *)text {
    static UIFont *font = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    });
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(kDetailedTextLabelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail].height;
}

- (void)fillWithMainText:(NSString *)mainText detailedText:(NSString *)detailedText {
    self.detailedTextLabel.hidden = !(detailedText.length > 0);
    self.height = [YMAbstractSettingsCell heightForDetailedText:detailedText];
    if (detailedText) {
        self.detailedTextLabel.height = [YMAbstractSettingsCell detailedLabelHeightForText:detailedText];
        self.detailedTextLabel.text = detailedText;
    }
    self.mainTextLabel.text = mainText;
}

@end