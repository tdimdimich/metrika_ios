//
// Created by Dmitry Korotchenkov on 25/02/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "YMObjectForGrouping.h"


@implementation YMObjectForGrouping

- (id)initWithName:(NSString *)name visits:(float)visits pageViews:(float)pageViews denial:(float)denial visitTime:(float)visitTime{
    self = [super init];
    if (self) {
        self.name = name;
        self.visits = visits;
        self.pageViews = pageViews;
        self.denialSum = denial * visits;
        self.visitTimeSum = visitTime * visits;
    }

    return self;
}

- (void)addVisits:(float)visits pageViews:(float)pageViews denial:(float)denial visitTime:(float)visitTime {
    self.visits += visits;
    self.pageViews += pageViews;
    self.denialSum += denial * visits;
    self.visitTimeSum += denial * visits;
}

- (float)depth {
    return self.visits ? self.pageViews / self.visits : 0;
}

- (float)visitTime {
    return self.visits ? self.visitTimeSum / self.visits : 0;
}

- (float)denial {
    return self.visits ? self.denialSum / self.visits : 0;
}

@end