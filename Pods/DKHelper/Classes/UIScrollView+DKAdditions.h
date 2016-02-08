//
// Created by Dmitry Korotchenkov on 27/02/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIScrollView (DKAdditions)

@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) CGFloat leftInset;
@property (nonatomic) CGFloat rightInset;

@property (nonatomic) CGFloat offsetX;
@property (nonatomic) CGFloat offsetY;

@end