//
// Created by Dmitry Korotchenkov on 23.06.13.
// Copyright (c) 2013 progress-engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "DKKeyboardToolbarWithHideButton.h"

typedef enum {
    DRToolbarTextInputStateFirst,
    DRToolbarTextInputStateMiddle,
    DRToolbarTextInputStateLast
} DRToolbarTextInputState;

@protocol DKKeyboardToolbarDelegate

-(void)previousTextInput;
-(void)nextTextInput;

@end

@interface DKNavigateKeyboardToolbar : DKKeyboardToolbarWithHideButton

- (id)initWithStateDelegate:(id <DKKeyboardToolbarDelegate>)delegate state:(DRToolbarTextInputState)textInputState;

+ (UIToolbar *)firstInputToolbar:(id <DKKeyboardToolbarDelegate>)delegate;

+ (UIToolbar *)middleInputToolbar:(id <DKKeyboardToolbarDelegate>)delegate;

+ (UIToolbar *)lastInputToolbar:(id <DKKeyboardToolbarDelegate>)delegate;
@end