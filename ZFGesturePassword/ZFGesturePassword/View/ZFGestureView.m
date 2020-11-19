//
//  ZFGestureView.m
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ZFGestureView.h"
#import "ZFNodeView.h"
#import "GestureConfigHeader.h"
#import "ZFGesturePasswordStore.h"
//self是正方形
@interface ZFGestureView ()
@property (nonatomic, strong) NSMutableArray *allNodeArray;
@property (nonatomic, strong) NSMutableArray *selNodeArray;

@property (nonatomic, strong) CAShapeLayer *lineShapeLayer;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) NSString *currentPwd;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) UILabel *tipLabel;

@end
@implementation ZFGestureView{
    
    int setCount;
    int vertifyCount;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer addSublayer:self.lineShapeLayer];
        self.layer.masksToBounds = YES;
        [self creatSubview];
        self.backgroundColor = GestureViewBackgroundColor;
    }
    return self;
}
/**
 创建子视图
 */
- (void)creatSubview{
    //添加 子 提示视图
    [self addSubview:self.tipLabel];
    vertifyCount = GestureErrorCount;
    CGFloat nodeSpace = (CGRectGetWidth(self.frame) - 3*NodeCicleOutDiameter)/6.0;//间距
    CGFloat top = NodeCicleSpace + 30;
    int currentTag = 1;
    for (int i=1; i<4; i++) {
        
        for (int j=1; j<4; j++) {
            
            CGRect rect = CGRectMake(nodeSpace*(2*j-1)+(j-1)*NodeCicleOutDiameter, top+nodeSpace*(2*i-1)+(i-1)*NodeCicleOutDiameter, NodeCicleOutDiameter, NodeCicleOutDiameter);
            ZFNodeView *nodeView = [[ZFNodeView alloc] initWithFrame:rect];
            [self addSubview:nodeView];
            nodeView.tag = currentTag;
            [self.allNodeArray addObject:nodeView];
            currentTag++;
        }
    }
    
}

/**
 当手离开屏幕，节点回归到出事状态
 */
- (void)reloadToInitState{
    
    for (ZFNodeView *nodeView in self.allNodeArray) {
        nodeView.toSelect = NO;
        nodeView.nState = ZFNodeViewStateNormal;
    }
    _lineShapeLayer.path = nil;
    _lineShapeLayer.strokeColor = NodeSelectColor.CGColor;
}
/**
 当前点（point）是否在某个node节点内部

 @param startPoint 点
 @return 是否在某个节点内部
 */
- (BOOL)isContainNodeView:(CGPoint)startPoint{
    
    BOOL isContainNode = NO;
    
    for (ZFNodeView *nodeView in _allNodeArray) {
        
        if (CGRectContainsPoint(nodeView.frame, startPoint)&&!nodeView.toSelect) {
            nodeView.nState = ZFNodeViewStateSelect;
            isContainNode = YES;
            nodeView.toSelect = YES;
            [self.selNodeArray addObject:nodeView];
            break;
        }
    }
    return isContainNode;
}
#pragma mark - Touch 方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint beganPoint = [touch locationInView:self];
    [self isContainNodeView:beganPoint];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self];
    for (ZFNodeView *nodeView in self.allNodeArray) {
        
        if (![self.selNodeArray containsObject:nodeView]&&CGRectContainsPoint(nodeView.frame, self.lastPoint)) {
            nodeView.nState = ZFNodeViewStateSelect;
            [self.selNodeArray addObject:nodeView];
        }
    }
    [self drawRectNewLine];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self drawRectCicleAndLine];
    [self verifyGesturePassword];
}
#pragma mark - 画UI的线
//立刻清除UI
- (void)clearUINow{
    
    self.lastPoint = CGPointMake(0, 0);
    [self reloadToInitState];//在draw后边
    [self.selNodeArray removeAllObjects];
    self.userInteractionEnabled = YES;
}
//延迟1s清除 点线 等UI
- (void)clearUIDelay{
    
    self.userInteractionEnabled = NO;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        self.lastPoint = CGPointMake(0, 0);
        [self reloadToInitState];//在draw后边
        [self.selNodeArray removeAllObjects];
        self.userInteractionEnabled = YES;
    });
}
//校验手势密码：（1、连接点数；2、（验证）验证是否正确；3、（设置）两次是否一样）
- (void)verifyGesturePassword{
    
    //判断是否选中过点，否则退出
    if (self.selNodeArray.count<=0) {
        return;
    }
    //判断连接点数 小于 最少连接数
    if (self.selNodeArray.count<NodeLeastCount) {
        [self modifyErrorUI];
        [self setPwdJudgeAction:NodeErrorColor str:GestureErrorLeastCountTip];
        [self shake:self.tipLabel];
        return;
    }
    
    //获取当前输入的密码
    NSMutableString *pwd = [NSMutableString string];
    for (ZFNodeView *nodeView in self.selNodeArray) {
        
        [pwd appendString:[NSString stringWithFormat:@"%ld",(long)nodeView.tag]];
    }
    //设置密码
    if (self.gesPwdType == ZFGesturePasswordTypeSetting){
    
        [self setGesturePwd:pwd];
    }else if (self.gesPwdType == ZFGesturePasswordTypeVerify){//验证手势密码
        [self verifyGesturePwd:pwd];
    }else if (self.gesPwdType == ZFGesturePasswordTypeResetting){
        //重新设置
    }
}
- (void)setGesturePwd:(NSString *)pwd{
    
    if (setCount<1) {
        setCount = 1;
        self.currentPwd = pwd;
        self.userInteractionEnabled = NO;
        [self clearUINow];
        [self setPwdJudgeAction:NodeOutCicleNormalColor str:GestureConfirmTip];
        //去画小圆
        [self.subItemView reloadSubItemLayerString:pwd color:NodeSelectColor];
    }else{
        
        if (![pwd isEqualToString:self.currentPwd]){//验证手势密码是否正确
            [self modifyErrorUI];
            [self clearUIDelay];
            [self setPwdJudgeAction:NodeErrorColor str:GestureErrorLastTimeTip];
            [self shake:self.tipLabel];

        }else{
            setCount = 0;
            [[ZFGesturePasswordStore instance] storePassword:pwd];
            NSLog(@"第二次设置完成");//toasts提示
            [self clearUIDelay];
            if (self.setSuccBlock) {
                self.setSuccBlock();
            }
        }
    }
}
- (void)verifyGesturePwd:(NSString *)pwd{
    
    //判断密码是否一样
    if ([pwd isEqualToString:[[ZFGesturePasswordStore instance]getGesturePassword]]){
        NSLog(@"解锁成功");
        
        if (self.verifySuccBlock) {
            self.verifySuccBlock();
        }
    }else{
        [self modifyErrorUI];
        vertifyCount = vertifyCount - 1;
        [self setPwdJudgeAction:NodeErrorColor str:GestureErrorVerifyCountTip(vertifyCount)];
        [self shake:self.tipLabel];
    }
}
- (void)modifyErrorUI{
    
    for (ZFNodeView *nodeView in self.selNodeArray) {
        
        nodeView.nState = ZFNodeViewStateError;
    }
    _lineShapeLayer.strokeColor = NodeErrorColor.CGColor;
    [self clearUIDelay];
}
- (void)setPwdJudgeAction:(UIColor *)color str:(NSString *)tipStr{
    
    self.tipLabel.text = tipStr;
    self.tipLabel.textColor = color;
}
/**
 判断两点之间距离是否超过外圈半径
 @param startPoint 圆心
 @param lastPoint 当前touch点
 @return 是否超过外圈半径
 */
- (BOOL)coordinateDistance:(CGPoint)startPoint withLastPoint :(CGPoint)lastPoint{
    
    CGFloat distance = sqrt(pow(startPoint.x-lastPoint.x, 2)+pow(startPoint.y-lastPoint.y, 2));
    if (distance>NodeCicleOutRadius) {
        return YES;
    }else{
        return NO;
    }
}
/**
 开始绘制
 */
- (void)drawRectNewLine{
    
    [self drawRectCicleAndLine];
    [self drawRectOtherLine];
}
//画 圆之间、两点三角方向 的连线
- (void)drawRectCicleAndLine{
    
    [self.bezierPath removeAllPoints];

    for (int i=0; i<_selNodeArray.count; i++) {
        ZFNodeView *nodeView = _selNodeArray[i];
        if (i==0) {
            
            [self.bezierPath moveToPoint:nodeView.center];
        }else{
            [self.bezierPath addLineToPoint:nodeView.center];
        }
        
        //三角形方向
        if (i<_selNodeArray.count-1) {
            
            ZFNodeView *endNodeView = _selNodeArray[i+1];
            CGPoint beginPoint = nodeView.center;
            CGPoint endPoint = endNodeView.center;
            [nodeView getTriangleAngle:beginPoint endPoint:endPoint isShow:YES];
        }
    }
    self.lineShapeLayer.path = self.bezierPath.CGPath;

}
- (void)drawRectOtherLine{
    
    //最后一个圆与多余的线
    if (_selNodeArray.count>0) {
        
        ZFNodeView *nodeView = _selNodeArray.lastObject;
        if (self.lastPoint.x!=0&&self.lastPoint.y!=0&&[self coordinateDistance:nodeView.center withLastPoint:self.lastPoint]) {
            [self.bezierPath addLineToPoint:self.lastPoint];
        }
    }
    self.lineShapeLayer.path = self.bezierPath.CGPath;
}
#pragma mark 抖动动画
- (void)shake:(UIView *)myView
{
    int offset = 8 ;
    
    CALayer *lbl = [myView layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-offset, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+offset, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.06];
    [animation setRepeatCount:2];
    [lbl addAnimation:animation forKey:nil];
}

#pragma mark - Setter && Getter 方法

- (NSMutableArray *)allNodeArray{
    
    if (!_allNodeArray) {
        
        _allNodeArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _allNodeArray;
}
- (NSMutableArray *)selNodeArray{
    
    if (!_selNodeArray) {
        
        _selNodeArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selNodeArray;
}

- (CAShapeLayer *)lineShapeLayer{
    
    if (!_lineShapeLayer) {
        
        _lineShapeLayer = [CAShapeLayer layer];
        _lineShapeLayer.fillColor = nil;
        _lineShapeLayer.lineWidth = 2.0f;
        _lineShapeLayer.strokeColor = NodeSelectColor.CGColor;
        _lineShapeLayer.path = self.bezierPath.CGPath;
    }
    return _lineShapeLayer;
}
- (UIBezierPath *)bezierPath{
    
    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}
- (UILabel *)tipLabel{
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 20)];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = NodeOutCicleNormalColor;
        _tipLabel.backgroundColor = NodeInCicleNormalColor;
    }
    return _tipLabel;
}
- (void)setGesPwdType:(ZFGesturePasswordType)gesPwdType{
    
    _gesPwdType = gesPwdType;
    switch (gesPwdType) {
        case ZFGesturePasswordTypeSetting:
            
            self.tipLabel.text = GestureNormalTip;
            break;
        case ZFGesturePasswordTypeVerify:
            self.tipLabel.text = @"";
            break;
        case ZFGesturePasswordTypeResetting:
            self.tipLabel.text = @"";
            break;
        default:
            break;
    }
}
@end
