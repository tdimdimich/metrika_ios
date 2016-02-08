//
// Created by Dmitry Korotchenkov on 02/06/14.
//

#import "UIImageView+DKAdditions.h"


@implementation UIImageView (DKAdditions)

- (CGRect)cropRectForFrame:(CGRect)frame {
    NSAssert(self.contentMode == UIViewContentModeScaleAspectFit, @"content mode must be aspect fit");

    CGFloat widthScale = self.bounds.size.width / self.image.size.width;
    CGFloat heightScale = self.bounds.size.height / self.image.size.height;

    float x, y, w, h, offset;
    if (widthScale < heightScale) {
        offset = (self.bounds.size.height - (self.image.size.height * widthScale)) / 2;
        x = frame.origin.x / widthScale;
        y = (frame.origin.y - offset) / widthScale;
        w = frame.size.width / widthScale;
        h = frame.size.height / widthScale;
    } else {
        offset = (self.bounds.size.width - (self.image.size.width * heightScale)) / 2;
        x = (frame.origin.x - offset) / heightScale;
        y = frame.origin.y / heightScale;
        w = frame.size.width / heightScale;
        h = frame.size.height / heightScale;
    }
    return CGRectMake(x, y, w, h);
}

@end