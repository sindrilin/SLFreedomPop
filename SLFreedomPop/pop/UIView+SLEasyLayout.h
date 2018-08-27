//
//  UIView+SLEasyLayout.h
//  GPUImageDemo
//
//  Created by 林欣达 on 2018/8/24.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @category   UIView+SLEasyLayout
 *  UIView布局扩展
 */
@interface UIView (SLEasyLayout)

@property (nonatomic, readwrite) CGFloat x;
@property (nonatomic, readwrite) CGFloat y;
@property (nonatomic, readwrite) CGFloat top;
@property (nonatomic, readwrite) CGFloat left;
@property (nonatomic, readwrite) CGFloat right;
@property (nonatomic, readwrite) CGFloat bottom;
@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, readwrite) CGFloat height;

@end
