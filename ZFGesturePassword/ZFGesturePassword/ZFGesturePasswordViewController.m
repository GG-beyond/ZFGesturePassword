//
//  ZFGesturePasswordViewController.m
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ZFGesturePasswordViewController.h"
#import "ZFGestureView.h"
#import "ZFSubItemView.h"
#import "GestureConfigHeader.h"

@interface ZFGesturePasswordViewController ()

@property (nonatomic, strong) ZFGestureView *gestureView;
@property (nonatomic, strong) ZFSubItemView *subItemView;

@end

@implementation ZFGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GestureViewBackgroundColor;
    [self createSetGesturePasswordView];
}

/**
 创建设置手势密码view
 */
- (void)createSetGesturePasswordView{
    
    [self.view addSubview:self.gestureView];
    [self.view addSubview:self.subItemView];
}

/**
 创建验证手势密码view
 */
- (void)createVerifyGesturePasswordView{
    
}
#pragma mark - Setter && Getter
- (ZFGestureView *)gestureView{
    
    if (!_gestureView) {
        
        __weak typeof(self)weakSelf = self;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat viewWidth = screenWidth - ScreenEdgeSpace*2;//屏幕宽度-左右边距20
        CGFloat viewHeight = viewWidth+ NodeCicleSpace + 30;
        _gestureView = [[ZFGestureView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        _gestureView.center = self.view.center;
        if (_gesIndex==0) {
            _gestureView.gesPwdType = ZFGesturePasswordTypeSetting;
        }else if (_gesIndex==1){
            _gestureView.gesPwdType = ZFGesturePasswordTypeVerify;
        }else if (_gesIndex==2){
            _gestureView.gesPwdType = ZFGesturePasswordTypeResetting;
        }
        _gestureView.setSuccBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _gestureView.verifySuccBlock  = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _gestureView.subItemView = self.subItemView;
    }
    return _gestureView;
}
- (ZFSubItemView *)subItemView{
    
    if (!_subItemView) {
        
        CGFloat width = SubCicleDiameter*3+SubCicleSpace*6;
        _subItemView = [[ZFSubItemView alloc] initWithFrame:CGRectMake(0, NavHeight+10, width, width)];
        CGPoint center = _subItemView.center;
        center.x = self.view.center.x;
        _subItemView.center = center;
    }
    return _subItemView;
}
@end
