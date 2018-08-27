//
//  ViewController.m
//  SLFreedomPop
//
//  Created by 林欣达 on 2018/8/27.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SLFreedomPop.h"

@interface ViewController ()

@end

@implementation ViewController
{
    __weak UIView *_red;
    SLViewDirection _direction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *blue = ({
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(160, 160, 80, 80)];
        view.backgroundColor = [UIColor blueColor];
        view;
    });
    
    UIView *red = ({
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 60, 60)];
        view.backgroundColor = [UIColor redColor];
        view;
    });
    
    UIButton *pop = ({
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(160, 400, 120, 40)];
        button.backgroundColor = [UIColor redColor];
        [button setTitle: @"pop" forState: UIControlStateNormal];
        [button addTarget: self action: @selector(popView) forControlEvents: UIControlEventTouchUpInside];
        button;
    });
    
    UIButton *remove = ({
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(160, 480, 120, 40)];
        button.backgroundColor = [UIColor redColor];
        [button setTitle: @"remove" forState: UIControlStateNormal];
        [button addTarget: self action: @selector(removeViews) forControlEvents: UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview: pop];
    [self.view addSubview: remove];
    [self.view addSubview: blue];
    [blue addSubview: red];
    red.tag = 101;
    _red = red;
}

- (void)didClickedGreenView: (UITapGestureRecognizer *)sender {
    NSLog(@"did click view");
}

- (void)popView {
    if (_direction > SLViewDirectionRight) {
        return;
    }
    
    UIView *green = ({
        UIView *view = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 40, 40)];
        [view addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(didClickedGreenView:)]];
        view.backgroundColor = [UIColor greenColor];
        view;
    });
    [_red sl_popView: green withDirection: _direction];
    _direction++;
}

- (void)removeViews {
    [_red.subviews enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _direction = 0;
}


@end
