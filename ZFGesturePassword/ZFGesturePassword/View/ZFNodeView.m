//
//  ZFNodeView.m
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ZFNodeView.h"
#import "GestureConfigHeader.h"

@interface ZFNodeView ()
@property (nonatomic, strong) CAShapeLayer *outCicleShapeLayer;
@property (nonatomic, strong) CAShapeLayer *inCicleShapeLayer;
@property (nonatomic, strong) CAShapeLayer *triangleShapeLayer;

@end
@implementation ZFNodeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createSubview];
        self.userInteractionEnabled = false;
    }
    return self;
}
- (void)createSubview{
    
    [self.layer addSublayer:self.outCicleShapeLayer];
    [self.layer addSublayer:self.inCicleShapeLayer];
    [self.layer addSublayer:self.triangleShapeLayer];
}
- (void)getTriangleAngle:(CGPoint)beginPoint endPoint:(CGPoint)endPoint isShow:(BOOL)isShow{

    //beginPoint 和 endPoint的顺序不能改变
    CGFloat x = endPoint.x - beginPoint.x;
    CGFloat y = endPoint.y - beginPoint.y;
    
    if (beginPoint.x ==endPoint.x&&beginPoint.y==endPoint.y) {
        return;
    }
    if (endPoint.x==0&&endPoint.y==0) {
        return;
    }
    self.triangleShapeLayer.hidden = !isShow;
    
    CGFloat hypotenuse = sqrt(pow(x, 2)+pow(y, 2));
    //斜边长度
    CGFloat cos = x/hypotenuse;
    //求出弧度
    CGFloat angle = acos(cos);
    
    if (y<0) {
        angle = -angle;
    }
    self.transform = CGAffineTransformMakeRotation(angle+0.5*M_PI);
}

#pragma mark Setter && Getter
- (void)setToSelect:(BOOL)toSelect{
    
    _toSelect = toSelect;
    if (!toSelect) {
        
        self.triangleShapeLayer.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.transform = CGAffineTransformMakeRotation(0);
        });
    }
}
- (void)setNState:(ZFNodeViewState)state{
    
    _nState = state;
    if (state == ZFNodeViewStateNormal) {
        
        self.outCicleShapeLayer.strokeColor = NodeOutCicleNormalColor.CGColor;
        self.inCicleShapeLayer.fillColor = NodeInCicleNormalColor.CGColor;
        self.triangleShapeLayer.fillColor = NodeInCicleNormalColor.CGColor;
    }else if (state == ZFNodeViewStateSelect){
        
        self.outCicleShapeLayer.strokeColor = NodeSelectColor.CGColor;
        self.inCicleShapeLayer.fillColor = NodeSelectColor.CGColor;
        self.triangleShapeLayer.fillColor = NodeSelectColor.CGColor;
    }else if (state == ZFNodeViewStateError){
        
        self.outCicleShapeLayer.strokeColor = NodeErrorColor.CGColor;
        self.inCicleShapeLayer.fillColor = NodeErrorColor.CGColor;
        self.triangleShapeLayer.fillColor = NodeErrorColor.CGColor;
    }
}
//外圈
- (CAShapeLayer *)outCicleShapeLayer{
    
    if (!_outCicleShapeLayer) {
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(NodeCicleOutRadius, NodeCicleOutRadius) radius:NodeCicleOutRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        _outCicleShapeLayer = [CAShapeLayer layer];
        _outCicleShapeLayer.fillColor = GestureViewBackgroundColor.CGColor;
        _outCicleShapeLayer.lineWidth = 2.0f;
        _outCicleShapeLayer.strokeColor = NodeOutCicleNormalColor.CGColor;
        _outCicleShapeLayer.path = bezierPath.CGPath;
    }
    return _outCicleShapeLayer;
}
//内圈
- (CAShapeLayer *)inCicleShapeLayer{
    
    if (!_inCicleShapeLayer) {
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(NodeCicleOutRadius, NodeCicleOutRadius) radius:NodeCicleInRadius startAngle:0 endAngle:2*M_PI clockwise:YES];

        _inCicleShapeLayer = [CAShapeLayer layer];
        _inCicleShapeLayer.fillColor = NodeInCicleNormalColor.CGColor;
        _inCicleShapeLayer.path = bezierPath.CGPath;
    }
    return _inCicleShapeLayer;
}
//三角
- (CAShapeLayer *)triangleShapeLayer{
    
    if (!_triangleShapeLayer) {
        
        CGPoint center = CGPointMake(NodeCicleOutRadius, NodeCicleOutRadius);
        CGPoint point1 = CGPointMake(center.x, center.y-NodeCicleInRadius-11);
        CGPoint point2 = CGPointMake(center.x-6, center.y-NodeCicleInRadius-5);
        CGPoint point3 = CGPointMake(center.x+6, center.y-NodeCicleInRadius-5);

        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:point1];
        [bezierPath addLineToPoint:point2];
        [bezierPath addLineToPoint:point3];
        
        _triangleShapeLayer = [CAShapeLayer layer];
        _triangleShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _triangleShapeLayer.path = bezierPath.CGPath;
        _triangleShapeLayer.hidden = YES;
    }
    return _triangleShapeLayer;
}
@end
