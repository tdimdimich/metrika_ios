//
// Created by Dmitry Korotchenkov on 14/10/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "YMListControl.h"
#import "UIImage+DKAdditions.h"

@interface YMListControl ()
@property(nonatomic, strong) IBOutlet UILabel *title;
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) UITextField *invisibleTextField;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, weak) NSObject *target;
@property(nonatomic) SEL action;
@property(nonatomic) NSUInteger selectedIndex;
@end

@implementation YMListControl

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.text = @"";
    self.invisibleTextField = [[UITextField alloc] init];
    self.invisibleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.invisibleTextField.hidden = YES;
    [self addSubview:self.invisibleTextField];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerView sizeToFit];
    self.pickerView.showsSelectionIndicator = YES;
    self.invisibleTextField.inputView = self.pickerView;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.items = @[
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Picker-Done", @"Готово") style:UIBarButtonItemStyleDone target:self.invisibleTextField action:@selector(resignFirstResponder)]
    ];
    [toolbar sizeToFit];
    self.invisibleTextField.inputAccessoryView = toolbar;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
}

- (void)tapGesture {
    if (self.dataArray.count > 0) {
        [self.invisibleTextField becomeFirstResponder];
        [self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
    }
}

- (void)setColor:(UIColor *)color {
    UIImage *maskedImage = [UIImage imageWithMaskImage:[UIImage imageNamed:@"list-control-color-mask@2x.png"] color:color];
    UIImage *iconImage = [UIImage imageNamed:@"list-control-icon@2x.png"];
    UIImage *image = [iconImage insertImageBelowSelf:maskedImage withPosition:CGPointZero];
    [self.imageView setImage:image];
}

// array of NSString's
- (void)setData:(NSArray *)data selectedIndex:(NSUInteger)selectedIndex target:(NSObject *)target action:(SEL)action {
    if (data.count > 0) {
        self.target = target;
        self.action = action;
        self.dataArray = data;
        if (selectedIndex < data.count) {
            self.selectedIndex = selectedIndex;
        } else {
            self.selectedIndex = 0;
        }
        self.title.text = data[self.selectedIndex];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[(NSUInteger) row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = (NSUInteger) row;
    NSString *selectedString = self.dataArray[(NSUInteger) row];
    self.title.text = selectedString;
    [self.target performSelector:self.action withObject:[NSNumber numberWithInt:row]];
}


@end