//
//  ZFSubItemView.m
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/20.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ZFSubItemView.h"
#import "GestureConfigHeader.h"
@interface ZFSubItemView ()
@property (nonatomic, strong) NSMutableArray *array;
@end
@implementation ZFSubItemView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubView];
    }
    return self;
}
- (void)createSubView{
    
    int currentTag = 1;

    for (int i=1; i<4; i++) {
        
        for (int j=1; j<4; j++) {

            CGRect rect = CGRectMake(SubCicleSpace*(2*j-1)+(j-1)*SubCicleDiameter, SubCicleSpace*(2*i-1)+(i-1)*SubCicleDiameter, NodeCicleOutDiameter, SubCicleDiameter);
            ZFSubItemCicle *itemView = [[ZFSubItemCicle alloc] initWithFrame:rect];
            [self addSubview:itemView];
            itemView.tag = currentTag;
            [self.array addObject:itemView];
            currentTag++;
        }
    }
}
- (void)reloadSubItemLayerString:(NSString *)str color:(UIColor *)renderColor{

    for (ZFSubItemCicle *itemView in self.array) {
        
        NSString *s = [NSString stringWithFormat:@"%ld",itemView.tag];
        if ([str containsString:s]) {
            
            itemView.shapeLayer.strokeColor = renderColor.CGColor;
            itemView.shapeLayer.fillColor = renderColor.CGColor;

        }else{
            itemView.shapeLayer.strokeColor = NodeOutCicleNormalColor.CGColor;
            itemView.shapeLayer.fillColor = nil;
        }
    }
}
#pragma mark - Set && Get method
- (NSMutableArray *)array{
    
    if (!_array) {
        
        _array = [NSMutableArray array];
    }
    return _array;
}
@end

@implementation ZFSubItemCicle

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createSubview];
    }
    return self;
}
- (void)createSubview{
    
    [self.layer addSublayer:self.shapeLayer];
}
//内圈
- (CAShapeLayer *)shapeLayer{
    
    if (!_shapeLayer) {
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SubCicleRadius, SubCicleRadius) radius:SubCicleRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = nil;
        _shapeLayer.strokeColor = NodeOutCicleNormalColor.CGColor;
        _shapeLayer.path = bezierPath.CGPath;
    }
    return _shapeLayer;
}
@end
