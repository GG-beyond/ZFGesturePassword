//
//  ZFNodeView.h
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ZFNodeViewStateNormal,
    ZFNodeViewStateSelect,
    ZFNodeViewStateError,
} ZFNodeViewState;
@interface ZFNodeView : UIView

@property (nonatomic, assign) ZFNodeViewState nState;
@property (nonatomic, assign) BOOL toSelect;//是否选中了（同一次画线，如果选中了，不可再次选中）
- (void)getTriangleAngle:(CGPoint)beginPoint endPoint:(CGPoint)endPoint isShow:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
