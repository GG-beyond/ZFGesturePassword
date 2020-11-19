//
//  GestureConfigHeader.h
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/14.
//  Copyright © 2018年 58. All rights reserved.
//

#ifndef GestureConfigHeader_h
#define GestureConfigHeader_h

#define NavHeight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

#define ZFRGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define GestureViewBackgroundColor  ZFRGBColor(12,44,80)//手势画布背景默认颜色

#define ScreenEdgeSpace 20//距离屏幕  左 或 右 边距

#define NodeCicleOutRadius 35//圆的外圈半径
#define NodeCicleInRadius 10//圆的内圈半径
#define SubCicleRadius 4//小圆的半径

#define NodeCicleOutDiameter NodeCicleOutRadius*2//圆的外圈直径
#define NodeCicleInDiameter NodeCicleInRadius*2//圆的内圈直径
#define SubCicleDiameter SubCicleRadius*2//小圆的直径

#define NodeCicleSpace 30//圆之间的上下左右间距
#define SubCicleSpace 4//小圆之间的上下左右间距

#define NodeInCicleNormalColor  ZFRGBColor(12,44,80)//默认颜色
#define NodeOutCicleNormalColor  [UIColor whiteColor]//默认颜色

#define NodeSelectColor  ZFRGBColor(5,169,247)//选中颜色
#define NodeErrorColor  ZFRGBColor(255,33,33)//错误颜色

#define NodeLeastCount 4//最少连接点数
#define GestureErrorCount 5//最大错误密码输入次数

#define GestureNormalTip @"为了您的账户安全，请至少连续绘制4个点"
#define GestureConfirmTip @"请确认手势设定"

#define GestureErrorLeastCountTip @"至少连续绘制4个点"
#define GestureErrorLastTimeTip @"两次手势设定不一致"
#define GestureErrorVerifyCountTip(n) [NSString stringWithFormat:@"密码错误，还可以再输入%d次",n]

#endif /* GestureConfigHeader_h */
