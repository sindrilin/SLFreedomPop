//
//  UIView+SLEasyLayout.m
//  GPUImageDemo
//
//  Created by 林欣达 on 2018/8/24.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "UIView+SLEasyLayout.h"


@implementation UIView (SLEasyLayout)


#pragma mark - Getter
- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}


#pragma mark - Setter
- (void)setX: (CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = round(x);
    self.frame = frame;
}

- (void)setY: (CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = round(y);
    self.frame = frame;
}

- (void)setTop: (CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = round(top);
    self.frame = frame;
}

- (void)setLeft: (CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = round(left);
    self.frame = frame;
}

- (void)setRight: (CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = round(right - frame.size.width);
    self.frame = frame;
}

- (void)setBottom: (CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = round(bottom - frame.size.height);
    self.frame = frame;
}

- (void)setWidth: (CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = round(width);
    self.frame = frame;
}

- (void)setHeight: (CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = round(height);
    self.frame = frame;
}


@end
