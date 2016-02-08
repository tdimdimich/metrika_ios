//
// File: YMCounterInfo.m
// Project: Metrika
//
// Created by dkorneev on 8/20/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMCounterInfo.h"
#import "YMCounter.h"
#import "YMAccountInfo.h"
#import "YMGradientColor.h"


@implementation YMCounterInfo

@dynamic  color;
@dynamic selected;
@dynamic hidden;
@dynamic counter;
@dynamic accountInfo;
@dynamic dateStart;
@dynamic dateEnd;

- (NSString *)siteName {
    return self.counter.site;
}

- (void)fillWithCounterInfo:(YMCounterInfo *)info {
    self.color = info.color;
    self.selected = info.selected;
    self.hidden = info.hidden;
    self.dateStart = info.dateStart;
    self.dateEnd = info.dateEnd;
    self.counter = info.counter;
    self.accountInfo = info.accountInfo;
}

@end