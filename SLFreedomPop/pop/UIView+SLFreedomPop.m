//
//  UIView+SLFreedomPop.m
//  GPUImageDemo
//
//  Created by 林欣达 on 2018/8/24.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "UIView+SLFreedomPop.h"
#import "UIView+SLEasyLayout.h"
#import <objc/runtime.h>


static void *SLExtraHitRectsKey = &SLExtraHitRectsKey;
typedef CGRect(^SLFreedomPopHandle)(UIView *contentView);

#define SLRectOverflow(subrect, rect) \
    subrect.origin.x < 0 || \
    subrect.origin.y < 0 || \
    CGRectGetMaxX(subrect) > CGRectGetWidth(rect) ||   \
    CGRectGetMaxY(subrect) > CGRectGetHeight(rect)


@implementation UIView (SLFreedomPop)


#pragma mark - Public
- (void)sl_popView: (UIView *)view {
    if (!view) {
        return;
    }
    
    [self sl_popView: view withDirection: SLViewDirectionCenter];
}

- (void)sl_popView: (UIView *)view withDirection: (SLViewDirection)direction {
    if (!view) {
        return;
    }
    
    CGPoint popedPoint = [self _sl_calculatePopSize: view.frame.size withDirection: direction];
    view.layer.anchorPoint = [self _sl_anchorPointWithDirection: direction];
    view.frame = CGRectMake(popedPoint.x, popedPoint.y, view.width, view.height);
    view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self addSubview: view];
    
    [UIView animateWithDuration: 0.2 animations: ^{
        view.transform = CGAffineTransformIdentity;
    }];
    
    CGRect popedFrame = view.frame;
    if (SLRectOverflow(popedFrame, self.frame)) {
        [self _sl_expandExtraRects: popedFrame forKey: [NSValue valueWithBytes: &view objCType: @encode(typeof(view))]];
        [self.superview _sl_addExtraRect: popedFrame inSubview: self];
    }
}


#pragma mark - Private
- (BOOL)_sl_pointInsideExtraRects: (CGPoint)point {
    NSArray *extraRects = [self extraHitRects].allValues;
    if (extraRects.count == 0) {
        return NO;
    }
    
    for (NSSet *rects in extraRects) {
        __block BOOL didFount = NO;
        [rects enumerateObjectsUsingBlock: ^(NSString *rectStr, BOOL * _Nonnull stop) {
            if (CGRectContainsPoint(CGRectFromString(rectStr), point)) {
                didFount = YES;
                *stop = YES;
            }
        }];
        if (didFount) {
            return YES;
        }
    }
    return NO;
}

- (CGPoint)_sl_anchorPointWithDirection: (SLViewDirection)direction {
    switch (direction) {
        case SLViewDirectionCenter:
            return CGPointMake(0.5, 0.5);
        case SLViewDirectionTop:
            return CGPointMake(0.5, 1);
        case SLViewDirectionLeft:
            return CGPointMake(1, 0.5);
        case SLViewDirectionBottom:
            return CGPointMake(0.5, 0);
        case SLViewDirectionRight:
            return CGPointMake(0, 0.5);
    }
}

- (CGPoint)_sl_calculatePopSize: (CGSize)popSize withDirection: (SLViewDirection)direction {
    switch (direction) {
        case SLViewDirectionCenter:
            return CGPointMake(round((self.width - popSize.width) / 2), round((self.height - popSize.height) / 2));
        case SLViewDirectionTop:
            return CGPointMake(round((self.width - popSize.width) / 2), -round(popSize.height));
        case SLViewDirectionLeft:
            return CGPointMake(-round(popSize.width), round((self.height - popSize.height) / 2));
        case SLViewDirectionBottom:
            return CGPointMake(round((self.width - popSize.width) / 2), round(self.height));
        case SLViewDirectionRight:
            return CGPointMake(round(self.width), round((self.height - popSize.height) / 2));
    }
}


#pragma mark - Rects
- (void)_sl_removeExtraRectsWithKey: (id<NSCopying>)key {
    NSMutableDictionary *extraRects = [NSMutableDictionary dictionaryWithDictionary: [self extraHitRects] ?: @{}];
    [extraRects removeObjectForKey: key];
    [self setExtraHitRects: extraRects];
    
    if (extraRects.count == 0) {
        [self.superview _sl_removeExtraRectsWithKey: [NSValue valueWithBytes: &self objCType: @encode(typeof(self))]];
    }
}

- (void)_sl_expandExtraRects: (CGRect)rect forKey: (id<NSCopying>)key {
    NSMutableDictionary *extraRects = [NSMutableDictionary dictionaryWithDictionary: [self extraHitRects] ?: @{}];
    NSMutableSet *rects = [extraRects objectForKey: key];
    if (!rects) {
        rects = [NSMutableSet set];
        [extraRects setObject: rects forKey: key];
        [self setExtraHitRects: [NSDictionary dictionaryWithDictionary: extraRects]];
    }
    [rects addObject: NSStringFromCGRect(rect)];
}

- (void)_sl_addExtraRect: (CGRect)extraRect inSubview: (UIView *)subview {
    CGRect curRect = [subview convertRect: extraRect toView: self];
    if (SLRectOverflow(curRect, self.frame)) {
        [self _sl_expandExtraRects: curRect forKey: [NSValue valueWithBytes: &subview objCType: @encode(typeof(subview))]];
        [self.superview _sl_addExtraRect: curRect inSubview: self];
    }
}


#pragma mark - Hook
- (void)sl_removeFromSuperview {
    [self.superview _sl_removeExtraRectsWithKey: [NSValue valueWithBytes: &self objCType: @encode(typeof(self))]];
    [self sl_removeFromSuperview];
}

- (BOOL)sl_pointInside: (CGPoint)point withEvent: (UIEvent *)event {
    BOOL res = [self sl_pointInside: point withEvent: event];
    if (!res) {
        return [self _sl_pointInsideExtraRects: point];
    }
    return res;
}

- (UIView *)sl_hitTest: (CGPoint)point withEvent: (UIEvent *)event {
    UIView *res = [self sl_hitTest: point withEvent: event];
    if (!res) {
        if ([self _sl_pointInsideExtraRects: point]) {
            return self;
        }
    }
    return res;
}


#pragma mark - Dynamic
- (NSDictionary<NSValue *, NSSet *> *)extraHitRects {
    return objc_getAssociatedObject(self, SLExtraHitRectsKey);
}

- (void)setExtraHitRects: (NSDictionary<NSValue *, NSSet *> *)extraHitRects {
    objc_setAssociatedObject(self, SLExtraHitRectsKey, extraHitRects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


__attribute__((constructor)) void sl_interceptRespondMethods() {
    Method origin = class_getInstanceMethod([UIView class], @selector(hitTest:withEvent:));
    Method custom = class_getInstanceMethod([UIView class], @selector(sl_hitTest:withEvent:));
    method_exchangeImplementations(origin, custom);
    
    origin = class_getInstanceMethod([UIView class], @selector(pointInside:withEvent:));
    custom = class_getInstanceMethod([UIView class], @selector(sl_pointInside:withEvent:));
    method_exchangeImplementations(origin, custom);
    
    origin = class_getInstanceMethod([UIView class], @selector(removeFromSuperview));
    custom = class_getInstanceMethod([UIView class], @selector(sl_removeFromSuperview));
    method_exchangeImplementations(origin, custom);
}

