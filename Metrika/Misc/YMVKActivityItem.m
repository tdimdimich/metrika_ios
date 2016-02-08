//
// Created by Dmitry Korotchenkov on 05/05/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "YMVKActivityItem.h"
#import "MBProgressHUD.h"
#import "YMConstants.h"


@interface YMVKActivityItem ()
@property(nonatomic, strong) NSString *string;
@property(nonatomic, strong) NSURL *URL;

@property(nonatomic, strong) UIViewController *parent;
@property(nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation YMVKActivityItem

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (id)initWithParent:(UIViewController *)parent {
    if ((self = [super init])) {
        self.parent = parent;
    }

    return self;
}

- (NSString *)activityType {
    return kVKActivityType;
}

- (NSString *)activityTitle {
    return @"Vkontakte";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"vk_activity.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
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
}

- (UIViewController *)activityViewController {
    return nil;
}

- (void)performActivity {
    [VKSdk initializeWithDelegate:self andAppId:kVKAppId];
    if ([VKSdk wakeUpSession]) {
        [self postToWall];
    }
    else {
        [VKSdk authorize:@[VK_PER_WALL]];
    }
}

#pragma mark - Upload

- (void)postToWall {
    [self begin];

    [self postToWall:@{VK_API_FRIENDS_ONLY : @(0),
            VK_API_OWNER_ID : [VKSdk getAccessToken].userId,
            VK_API_MESSAGE : self.string,
            VK_API_ATTACHMENTS : [self.URL absoluteString]
    }];
}

- (void)postToWall:(NSDictionary *)params {
    VKRequest *post = [[VKApi wall] post:params];
    [post executeWithResultBlock:^(VKResponse *response) {
        [self end];
    }                 errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [self end];
    }];
}

- (void)begin {
    UIView *view = self.parent.view.window;
    self.HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:self.HUD];
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.labelText = @"Загрузка...";
    [self.HUD show:YES];
}

- (void)end {
    [self.HUD hide:YES];
    [self activityDidFinish:YES];
}

#pragma mark - vkSdk

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.parent];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [VKSdk authorize:@[VK_PER_WALL, VK_PER_PHOTOS]];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.parent presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self postToWall];
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Access denied"
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
    [alertView show];

    [self end];
}

@end