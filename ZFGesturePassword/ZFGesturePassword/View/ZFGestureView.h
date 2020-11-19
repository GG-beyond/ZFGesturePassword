//
//  ZFGestureView.h
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSubItemView.h"

typedef enum : NSUInteger {
    
    ZFGesturePasswordTypeSetting,//设置
    ZFGesturePasswordTypeVerify,//验证
    ZFGesturePasswordTypeResetting,//重新设置
} ZFGesturePasswordType;

NS_ASSUME_NONNULL_BEGIN
typedef void(^GesPwdSetSucc)(void);//设置成功block
typedef void(^GesPwdVerifySucc)(void);//校验成功block

@interface ZFGestureView : UIView
@property (nonatomic, assign) ZFGesturePasswordType gesPwdType;//设置or验证
@property (nonatomic, copy) GesPwdSetSucc setSuccBlock;
@property (nonatomic, copy) GesPwdVerifySucc verifySuccBlock;
@property (nonatomic, strong) ZFSubItemView *subItemView;

@end

NS_ASSUME_NONNULL_END
