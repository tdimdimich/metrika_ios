//
// Created by Dmitry Korotchenkov on 04/03/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <DKHelper/UIView+DKViewAdditions.h>
#import "YMErrorAndLoadingCellsFactory.h"

@interface YMErrorAndLoadingCellsFactory ()

@property(nonatomic, strong) IBOutlet UILabel *textLabel;

@end

@implementation YMErrorAndLoadingCellsFactory

+ (UITableViewCell *)errorConnectionCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"YMNoConectionErrorCell" owner:nil options:nil] objectAtIndex:0];
}

+ (UITableViewCell *)errorPeriodCellWithText:(NSString *)text {
    YMErrorAndLoadingCellsFactory *factory = [[self alloc] init];
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YMErrorPeriodCell" owner:factory options:nil] objectAtIndex:0];
    factory.textLabel.text = text;
    return cell;
}

+ (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [indicator startAnimating];
    [indicator setCenter:cell.innerCenter];
    [cell.contentView addSubview:indicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end