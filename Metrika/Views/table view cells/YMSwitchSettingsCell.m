//
// Created by Dmitry Korotchenkov on 19.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMSwitchSettingsCell.h"
#import "YMiOS7Switch.h"

@interface YMSwitchSettingsCell ()
@property(nonatomic, strong) IBOutlet YMiOS7Switch *switchView;
@end

@implementation YMSwitchSettingsCell

- (void)addSwitchChangedState:(id)target action:(SEL)action {
    [self.switchView addSwitchChangeTarget:target action:action];
}

@end