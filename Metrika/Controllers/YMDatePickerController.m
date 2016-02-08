//
// File: YMDatePickerController.m
// Project: Metrika
//
// Created by dkorneev on 10/9/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import <DKHelper/UIView+DKViewAdditions.h>
#import <DKHelper/DKUtils.h>
#import "YMDatePickerController.h"
#import "YMDatePickerButton.h"
#import "YMCircleView.h"
#import "UIViewController+YMBackButtonAddition.h"
#import "YMCounterInfo.h"
#import "YMAppSettings.h"
#import "YMGradientColor.h"
#import "NSDate+YMAdditions.h"
#import "YMUtils.h"
#import "NSArray+BlocksKit.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface YMDatePickerController ()
@property(weak, nonatomic) IBOutlet UIButton *yearButton;
@property(weak, nonatomic) IBOutlet UIButton *monthButton;
@property(weak, nonatomic) IBOutlet UIButton *weekButton;
@property(weak, nonatomic) IBOutlet UIButton *todayButton;
@property(strong, nonatomic) IBOutlet UIView *datePickerAndOKButtonContainer;
@property(weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(weak, nonatomic) IBOutlet YMDatePickerButton *fromDateButton;
@property(weak, nonatomic) IBOutlet YMDatePickerButton *toDateButton;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet YMCircleView *circleView;
@property(weak, nonatomic) IBOutlet UIButton *confirmButton;
@property(nonatomic, strong) YMCounterInfo *counter;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *fromDate;
@property(nonatomic, strong) NSDate *toDate;
@property(nonatomic, weak) UIGestureRecognizer *interactivePopGestureRecognizer;
@end

@implementation YMDatePickerController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.fromDate = self.toDate = [NSDate date];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"d MMMM y";
        self.dateFormatter.locale = [NSLocale currentLocale];
    }
    return self;
}

- (void)configButtonAppearance:(UIButton *)button withString:(NSString *)string {
    NSDictionary *defaultParams = @{
            NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:15],
            NSForegroundColorAttributeName : [UIColor colorWithRed:38.0 / 255.0 green:152.0 / 255.0 blue:232.0 / 255.0 alpha:1]
    };

    NSDictionary *highlightedParams = @{
            NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:15],
            NSForegroundColorAttributeName : [UIColor colorWithRed:38.0 / 255.0 green:152.0 / 255.0 blue:232.0 / 255.0 alpha:1]
    };

    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:string attributes:defaultParams]
                      forState:UIControlStateNormal];
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:string attributes:highlightedParams]
                      forState:UIControlStateHighlighted];
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:string attributes:highlightedParams]
                      forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [self configButtonAppearance:self.todayButton withString:NSLocalizedString(@"DatePicker-Today", nil)];
    [self configButtonAppearance:self.weekButton withString:NSLocalizedString(@"DatePicker-Week", nil)];
    [self configButtonAppearance:self.monthButton withString:NSLocalizedString(@"DatePicker-Month", nil)];
    [self configButtonAppearance:self.yearButton withString:NSLocalizedString(@"DatePicker-Year", nil)];

    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.date = self.fromDate;
    self.fromDateButton.selected = YES;
    self.toDateButton.selected = NO;
    self.circleView.selected = YES;
    [self updateControls];

    NSString *selectedIntervalString;
    SEL action;
    if (self.fromDate && self.toDate) {
        if ([[self.toDate beginOfDay] isEqualToDate:[[NSDate date] beginOfDay]]) {
            if ([[self.fromDate beginOfDay] isEqualToDate:[[NSDate date] beginOfDay]]) {
                selectedIntervalString = NSLocalizedString(@"DatePicker-Today", nil);
                action = @selector(dayPeriodSelected:);
            }
        } else if ([[self.toDate beginOfDay] isEqualToDate:[[[NSDate date] dateByAddingDays:-1] beginOfDay]]) {
            if ([[self.fromDate beginOfDay] isEqualToDate:[[self.toDate dateByAddingDays:-6] beginOfDay]]) {
                selectedIntervalString = NSLocalizedString(@"DatePicker-Week", nil);
                action = @selector(weekPeriodSelected:);
            } else if ([[self.fromDate beginOfDay] isEqualToDate:[[self.toDate dateByAddingMonths:-1] beginOfDay]]) {
                selectedIntervalString = NSLocalizedString(@"DatePicker-Month", nil);
                action = @selector(monthPeriodSelected:);
            } else if ([[self.fromDate beginOfDay] isEqualToDate:[[self.toDate dateByAddingMonths:-12] beginOfDay]]) {
                selectedIntervalString = NSLocalizedString(@"DatePicker-Year", nil);
                action = @selector(yearPeriodSelected:);
            }
        }
    }
    if (selectedIntervalString) {
        UIButton *button = nil;
        if ([self.todayButton.currentAttributedTitle.string isEqualToString:selectedIntervalString]) {
            button = self.todayButton;

        } else if ([self.weekButton.currentAttributedTitle.string isEqualToString:selectedIntervalString]) {
            button = self.weekButton;

        } else if ([self.monthButton.currentAttributedTitle.string isEqualToString:selectedIntervalString]) {
            button = self.monthButton;

        } else if ([self.yearButton.currentAttributedTitle.string isEqualToString:selectedIntervalString]) {
            button = self.yearButton;
        }
        if (button) {
            [self hidePicker:NO];
            [self performSelector:action withObject:button];
        }
    } else {
        [self showPicker];
    }

    if (!SYSTEM_VERSION_LESS_THAN_7) {
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        blackView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackView];
        if (!SYSTEM_VERSION_LESS_THAN_7) {
            self.interactivePopGestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
            self.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!SYSTEM_VERSION_LESS_THAN_7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.interactivePopGestureRecognizer) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super viewDidDisappear:animated];
}

- (IBAction)dayPeriodSelected:(UIButton *)sender {
    NSDate *date = [[NSDate date] beginOfDay];
    self.fromDate = self.toDate = date;
    [self updateDateButtons];
    [self selectPeriodButtonsForButton:sender];
}

- (IBAction)weekPeriodSelected:(UIButton *)sender {
    self.toDate = [[[NSDate date] dateByAddingDays:-1] beginOfDay];
    self.fromDate = [[self.toDate dateByAddingDays:-6] beginOfDay];
    [self updateDateButtons];
    [self selectPeriodButtonsForButton:sender];
}

- (IBAction)monthPeriodSelected:(UIButton *)sender {
    self.toDate = [[[NSDate date] dateByAddingDays:-1] beginOfDay];
    self.fromDate = [[self.toDate dateByAddingMonths:-1] beginOfDay];
    [self updateDateButtons];
    [self selectPeriodButtonsForButton:sender];
}

- (IBAction)yearPeriodSelected:(UIButton *)sender {
    self.toDate = [[[NSDate date] dateByAddingDays:-1] beginOfDay];
    self.fromDate = [[self.toDate dateByAddingMonths:-12] beginOfDay];
    [self updateDateButtons];
    [self selectPeriodButtonsForButton:sender];
}

- (void)selectPeriodButton:(UIButton *)button selected:(BOOL)selected {
    NSAttributedString *string = [button attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [attributedString setAttributes:@{
            NSForegroundColorAttributeName : [DKUtils colorWithRed:38 green:152 blue:232]
    }                         range:NSMakeRange(0, string.length)];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];

    button.selected = selected;
}

- (void)selectPeriodButtonsForButton:(UIButton *)sender {
    [self selectPeriodButton:self.todayButton selected:[self.todayButton isEqual:sender]];
    [self selectPeriodButton:self.weekButton selected:[self.weekButton isEqual:sender]];
    [self selectPeriodButton:self.monthButton selected:[self.monthButton isEqual:sender]];
    [self selectPeriodButton:self.yearButton selected:[self.yearButton isEqual:sender]];

    [self.fromDateButton setGrayState:YES ];
    [self.toDateButton setGrayState:YES ];
    [self hidePicker:YES ];
}

- (void)hidePicker:(BOOL)animated {
    float duration = animated ? 0.2 : 0;
    [UIView animateFromCurrentStateWithDuration:duration animations:^{
        self.datePickerAndOKButtonContainer.top = self.view.height - 43;
    }];
}

- (void)unselectButton:(UIButton *)button {
    button.selected = NO;
    NSAttributedString *string = [button attributedTitleForState:UIControlStateNormal];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    [attributedString setAttributes:@{
            NSForegroundColorAttributeName : [DKUtils colorWithRed:200 green:200 blue:200]
    }                         range:NSMakeRange(0, string.length)];
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setTitleColor:[DKUtils colorWithRed:200 green:200 blue:200] forState:UIControlStateNormal];
}

- (void)showPicker {
    [self unselectButton:self.todayButton];
    [self unselectButton:self.weekButton];
    [self unselectButton:self.monthButton];
    [self unselectButton:self.yearButton];

    [UIView animateFromCurrentStateWithDuration:0.2 animations:^{
        self.datePickerAndOKButtonContainer.bottom = self.view.height;
    }];
}

- (void)updateControls {
    if (self.counter) {
        self.circleView.color = self.counter.color.startColor;
        self.titleLabel.textColor = self.counter.color.startColor;
        self.titleLabel.text = self.counter.siteName;
        [self updateDateButtons];

    } else {
        UIColor *color = [UIColor blueColor];
        self.circleView.color = color;
        self.titleLabel.textColor = color;
        self.titleLabel.text = NSLocalizedString(@"Site name", @"Имя сайта");
        NSString *curDateString = [self.dateFormatter stringFromDate:[NSDate date]];
        self.fromDateButton.titleLabel.text = curDateString;
        self.toDateButton.titleLabel.text = curDateString;
    }
}

- (void)updateDateButtons {
    [self.fromDateButton setTitle:[self.dateFormatter stringFromDate:self.fromDate]];
    [self.toDateButton setTitle:[self.dateFormatter stringFromDate:self.toDate]];
    NSTimeInterval timeInterval = [self.toDate timeIntervalSinceDate:self.fromDate];
    self.confirmButton.enabled = (timeInterval >= 0);
}

- (void)setCounter:(YMCounterInfo *)counter {
    _counter = counter;
    self.fromDate = counter.dateStart.copy; // copy to prevent changes in Core Data context
    self.toDate = counter.dateEnd.copy;
    [self updateControls];
}

#pragma mark Date Picker

- (void)datePickerValueChanged {
    if (self.fromDateButton.selected) {
        self.fromDate = self.datePicker.date;
    } else {
        self.toDate = self.datePicker.date;
    }
    [self updateDateButtons];
}

#pragma mark user interactions

- (IBAction)fromDateButtonTap:(id)sender {
    [self.fromDateButton setGrayState:NO];
    [self.toDateButton setGrayState:NO];
    self.fromDateButton.selected = YES;
    self.toDateButton.selected = NO;
    [self.datePicker setDate:self.fromDate animated:YES];
    [self showPicker];
}

- (IBAction)toDateButtonTap:(id)sender {
    [self.fromDateButton setGrayState:NO];
    [self.toDateButton setGrayState:NO];
    self.fromDateButton.selected = NO;
    self.toDateButton.selected = YES;
    [self.datePicker setDate:self.toDate animated:YES];
    [self showPicker];
}

- (IBAction)backButtonTap:(id)sender {
    [self back];
}

- (IBAction)confirmButtonTap:(id)sender {
    if (self.confirmBlock) {
        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];


        NSString *action = [NSString stringWithFormat:@"change period [%@ - %@]",
                                                      [self.dateFormatter stringFromDate:[self.fromDate beginOfDay]],
                                                      [self.dateFormatter stringFromDate:[self.toDate beginOfDay]]];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"change period action"
                                                              action:action
                                                               label:nil
                                                               value:nil] build]];

        self.confirmBlock([self.fromDate beginOfDay], [self.toDate beginOfDay]);
    }
}

@end