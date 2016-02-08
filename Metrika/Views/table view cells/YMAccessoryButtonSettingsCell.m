//
// Created by Dmitry Korotchenkov on 19.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMAccessoryButtonSettingsCell.h"

@interface YMAccessoryButtonSettingsCell ()

@property(nonatomic, strong) IBOutlet UIButton *accessoryButton;

@end

@implementation YMAccessoryButtonSettingsCell

- (void)fillWithMainText:(NSString *)mainText detailedText:(NSString *)detailedText accessoryButtonTitle:(NSString *)accessoryButtonTitle {
    [self fillWithMainText:mainText detailedText:detailedText];
    [self.accessoryButton setTitle:accessoryButtonTitle forState:UIControlStateNormal];
}

- (void)addAccessoryTapTarget:(id)target action:(SEL)action {
    [self.accessoryButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end