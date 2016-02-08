//
// File: YMMessageActivity.m
// Project: Metrika
//
// Created by dkorneev on 5/16/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//


#import <BlocksKit/NSArray+BlocksKit.h>
#import <MessageUI/MessageUI.h>
#import "YMMessageActivity.h"
#import "YMUtils.h"


@interface YMMessageActivity ()
@property(nonatomic, strong) NSString *string;
@property(nonatomic, strong) NSURL *URL;
@property(nonatomic, strong) MFMessageComposeViewController *controller;
@property(nonatomic, strong) UIViewController *parent;
@end

@implementation YMMessageActivity

- (id)initWithParent:(UIViewController *)parent {
    self = [super init];
    if (self) {
        self.parent = parent;
        self.controller = [[MFMessageComposeViewController alloc] init];
        self.controller.messageComposeDelegate = self;
    }
    return self;
}

- (NSString *)activityType {
    return @"YMMessageActivity";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"share-message-icon43-test.png"];
    if ( IDIOM == IPAD ) {
        if (SYSTEM_VERSION_LESS_THAN_7) {
            return [UIImage imageNamed:@"share-message-icon.png"];

        } else {
            return [UIImage imageNamed:@"share-message-icon76.png"];
        }

    } else {
        if (SYSTEM_VERSION_LESS_THAN_7) {
            return [UIImage imageNamed:@"share-message-icon43.png"];

        } else {
            return [UIImage imageNamed:@"share-message-icon.png"];
        }
    }
}

- (NSString *)activityTitle {
    return @"Message";
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if (![MFMessageComposeViewController canSendText])
        return NO;

    BOOL hasString = [activityItems bk_any:^BOOL(id obj) {
        return [obj isKindOfClass:[NSString class]];
    }];
    BOOL hasUrl = [activityItems bk_any:^BOOL(id obj) {
        return [obj isKindOfClass:[NSURL class]];
    }];

    return (hasString && hasUrl);
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.string = [activityItems bk_match:^BOOL(id obj) {
        return [obj isKindOfClass:[NSString class]];
    }];

    self.URL = [activityItems bk_match:^BOOL(id obj) {
        return [obj isKindOfClass:[NSURL class]];
    }];
    self.controller.body = [self.string stringByAppendingFormat:@"\n%@", self.URL.absoluteString];
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (UIViewController *)activityViewController {
    return self.controller;
}

//- (void)performActivity {
//    [self.parent presentViewController:self.controller animated:YES completion:nil];
//}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self.parent dismissViewControllerAnimated:YES completion:nil];
}

@end