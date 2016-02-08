//
// Created by Dmitry Korotchenkov on 16/02/14.
//

#import "UIImage+DKAdditions.h"


@implementation UIImage (DKAdditions)

+ (UIImage *)imageWithFrame:(CGRect)rect color:(UIColor *)color {
    return [self imageWithFrame:rect color:color scale:1];
}

+ (UIImage *)imageWithFrame:(CGRect)rect color:(UIColor *)color scale:(CGFloat)scale {
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(rect.size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageWithMaskImage:(UIImage *)maskImage color:(UIColor *)color {
    CGImageRef maskRef = [maskImage CGImage];
    UIImage *colorImage = [self imageWithFrame:CGRectMake(0, 0, maskImage.size.width, maskImage.size.height) color:color scale:maskImage.scale];
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), nil, NO);

    CGImageRef cgImage = CGImageCreateWithMask(colorImage.CGImage, mask);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:maskImage.scale orientation:maskImage.imageOrientation];

    CGImageRelease(mask);
    CGImageRelease(cgImage);
    return image;
}

- (UIImage *)insertImageBelowSelf:(UIImage *)insertedImage withPosition:(CGPoint)position {
    UIImage *image = nil;

    CGSize newImageSize = self.size;
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
    }
    [insertedImage drawAtPoint:position];
    [self drawAtPoint:CGPointZero];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)createEllipseWithSize:(CGSize)size color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end