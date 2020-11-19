//
//  ZFSubItemView.h
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/20.
//  Copyright © 2018年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFSubItemView : UIView

- (void)reloadSubItemLayerString:(NSString *)str color:(UIColor *)renderColor;
@end
@interface ZFSubItemCicle : UIView
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end
NS_ASSUME_NONNULL_END
