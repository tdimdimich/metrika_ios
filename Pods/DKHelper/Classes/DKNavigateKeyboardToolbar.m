//
// Created by Dmitry Korotchenkov on 23.06.13.
// Copyright (c) 2013 progress-engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DKNavigateKeyboardToolbar.h"


@implementation DKNavigateKeyboardToolbar

- (id)initWithStateDelegate:(id <DKKeyboardToolbarDelegate>)delegate state:(DRToolbarTextInputState)textInputState {
    self = [super init];
    if (self) {

        UIBarButtonItem *previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:delegate action:@selector(previousTextInput)];
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:delegate action:@selector(nextTextInput)];
        if (textInputState == DRToolbarTextInputStateFirst) {
            previous.enabled = NO;
        } else if (textInputState == DRToolbarTextInputStateLast) {
            next.enabled = NO;
        }

        self.items = [@[previous, next] arrayByAddingObjectsFromArray:self.items];
    }

    return self;
}

#pragma mark factory methods

+ (UIToolbar *)firstInputToolbar:(id <DKKeyboardToolbarDelegate>)delegate {
    return [[self alloc] initWithStateDelegate:delegate state:DRToolbarTextInputStateFirst];
}

+ (UIToolbar *)middleInputToolbar:(id <DKKeyboardToolbarDelegate>)delegate {
    return [[self alloc] initWithStateDelegate:delegate state:DRToolbarTextInputStateMiddle];
}

+ (UIToolbar *)lastInputToolbar:(id <DKKeyboardToolbarDelegate>)delegate {
    return [[self alloc] initWithStateDelegate:delegate state:DRToolbarTextInputStateLast];
}

@end