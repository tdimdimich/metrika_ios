//
// Created by Dmitry Korotchenkov on 26.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMCounterSettingsCell.h"
#import "YMCounterInfo.h"
#import "YMCircleView.h"
#import "YMCheckButton.h"
#import "YMConstants.h"
#import "YMGradientColor.h"

@interface YMCounterSettingsCell ()
@property(nonatomic, strong) IBOutlet YMCircleView *circleView;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet YMCheckButton *visibilityButton;
@property(nonatomic, weak) NSObject <YMCounterSettingsCellDelegate> *delegate;
@end

@implementation YMCounterSettingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)fillWithCounter:(YMCounterInfo *)counterInfo {
    [self fillWithCounter:counterInfo delegate:nil];
}

- (void)fillWithCounter:(YMCounterInfo *)counterInfo delegate:(NSObject <YMCounterSettingsCellDelegate> *)delegate {
    self.delegate = delegate;
    self.titleLabel.textColor = counterInfo.color.startColor;
    self.titleLabel.text = counterInfo.siteName;
    self.circleView.selected = YES;
    self.visibilityButton.selected = !counterInfo.hidden;
    self.circleView.color = counterInfo.color.startColor;
}

- (IBAction)visibilityDidChangeState:(YMCheckButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didChangeVisibleState:)]) {
        [self.delegate cell:self didChangeVisibleState:button.selected];
    }
}

- (IBAction)editButtonTap:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidEditTap:)]) {
        [self.delegate cellDidEditTap:self];
    }
}

@end