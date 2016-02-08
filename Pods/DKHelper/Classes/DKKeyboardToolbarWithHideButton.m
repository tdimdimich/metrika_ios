//
// Created by Dmitry Korotchenkov on 24.06.13.
// Copyright (c) 2013 progress-engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DKKeyboardToolbarWithHideButton.h"


@implementation DKKeyboardToolbarWithHideButton

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, kDRKeyboardToolbarHeight)];
    if (self) {
        self.barStyle = UIBarStyleBlackTranslucent;
        self.items = @[
                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)]
        ];
    }

    return self;
}

- (void)hideKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end