//
// Created by Dmitry Korotchenkov on 16/02/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (DKAdditions)

+ (UIImage *)imageWithFrame:(CGRect)rect color:(UIColor *)color;

+ (UIImage *)imageWithFrame:(CGRect)rect color:(UIColor *)color scale:(CGFloat)scale;

+ (UIImage *)imageWithMaskImage:(UIImage *)maskImage color:(UIColor *)color;

- (UIImage *)insertImageBelowSelf:(UIImage *)insertedImage withPosition:(CGPoint)position;

+ (UIImage *)createEllipseWithSize:(CGSize)size color:(UIColor *)color;

@end