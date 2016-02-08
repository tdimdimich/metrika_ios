//
// Created by Dmitry Korotchenkov on 19.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMAbstractSettingsCell : UITableViewCell
+ (CGFloat)heightForDetailedText:(NSString *)text;

- (void)fillWithMainText:(NSString *)mainText detailedText:(NSString *)detailedText;
@end