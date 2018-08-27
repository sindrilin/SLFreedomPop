//
//  UIView+SLFreedomPop.h
//  GPUImageDemo
//
//  Created by 林欣达 on 2018/8/24.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @enum   SLViewDirection
 *  弹窗视图所在的方向（dismiss和pop应当保持一致）
 */
typedef NS_ENUM(NSInteger, SLViewDirection)
{
    SLViewDirectionCenter,
    SLViewDirectionTop,
    SLViewDirectionLeft,
    SLViewDirectionBottom,
    SLViewDirectionRight
};


/*!
 *  @category   UIView+SLFreedomPop
 *  自由弹窗扩展
 */
@interface UIView (SLFreedomPop)

/*!
 *  @method sl_popView:
 *  居中弹出view
 *  @param  view    要弹出的view
 */
- (void)sl_popView: (UIView *)view;

/*!
 *  @method sl_popView:WithDirection:
 *  控制弹窗方向
 *  @param  view        要弹出的view
 *  @param  direction   弹出方向
 */
- (void)sl_popView: (UIView *)view withDirection: (SLViewDirection)direction;

@end
