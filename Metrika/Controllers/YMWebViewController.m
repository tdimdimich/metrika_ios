//
// File: YMWebViewController.m
// Project: Metrika
//
// Created by dkorneev on 10/3/13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//


#import "YMWebViewController.h"
#import "Config.h"

@interface YMWebViewController ()
@property(weak, nonatomic) IBOutlet UIWebView *webView;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@end

@implementation YMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"Отмена")];
    NSString *const urlString = [NSString stringWithFormat:@"https://oauth.yandex.ru/authorize?response_type=token&client_id=%@", kApplicationID];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

+ (void)clearCookies {
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest: %@", request);
//    NSLog(@"scheme: %@", request.URL.scheme);
    if ([request.URL.scheme isEqualToString:@"metrikatest"]) { // "metrikatest" - some value from metrika-info.plist

        NSString *string = request.URL.absoluteString;
        NSRange range = [string rangeOfString:@"#access_token="];
        if (range.location == NSNotFound) {
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }

        NSUInteger loc = range.location + range.length;
        NSString *tmp = [string substringWithRange:NSMakeRange(loc, string.length - loc)];
        NSScanner *scanner = [NSScanner scannerWithString:tmp];

        NSString *token = nil;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"&"] intoString:&token];

        if (self.delegate && [self.delegate respondsToSelector:@selector(didObtainToken:)]) {
            [self.delegate didObtainToken:token];
        }
        [YMWebViewController clearCookies];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - Buttons Methods

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end