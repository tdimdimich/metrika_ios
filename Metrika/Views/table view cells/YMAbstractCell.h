//
// Created by Dmitry Korotchenkov on 23.09.13.
// Copyright (c) 2013 Progress Engine. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface YMAbstractCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
- (void)fillWithTitle:(NSString *)title;
@end