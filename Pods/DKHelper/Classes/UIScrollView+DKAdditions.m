//
// Created by Dmitry Korotchenkov on 27/02/14.
//

#import "UIScrollView+DKAdditions.h"


@implementation UIScrollView (DKAdditions)

- (void)setTopInset:(CGFloat)top {
    self.contentInset = UIEdgeInsetsMake(top, self.leftInset, self.bottomInset, self.rightInset);
}

- (CGFloat)topInset {
    return self.contentInset.top;
}

- (void)setBottomInset:(CGFloat)bottom {
    self.contentInset = UIEdgeInsetsMake(self.topInset, self.leftInset, bottom, self.rightInset);
}

- (CGFloat)bottomInset {
    return self.contentInset.bottom;
}

- (void)setLeftInset:(CGFloat)left {
    self.contentInset = UIEdgeInsetsMake(self.topInset, left, self.bottomInset, self.rightInset);
}

- (CGFloat)leftInset {
    return self.contentInset.left;
}

- (void)setRightInset:(CGFloat)right {
    self.contentInset = UIEdgeInsetsMake(self.topInset, self.leftInset, self.bottomInset, right);
}

- (CGFloat)rightInset {
    return self.contentInset.right;
}

- (void)setOffsetX:(CGFloat)x {
    self.contentOffset = CGPointMake(x, self.offsetY);
}

- (CGFloat)offsetX {
    return self.contentOffset.x;
}

- (void)setOffsetY:(CGFloat)y {
    self.contentOffset = CGPointMake(self.offsetX, y);
}

- (CGFloat)offsetY {
    return self.contentOffset.y;
}

@end