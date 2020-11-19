//
//  ZFGesturePasswordStore.h
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/17.
//  Copyright © 2018年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFGesturePasswordStore : NSObject
+ (instancetype)instance;
- (void)storePassword:(NSString *)gesturePassword;
- (NSString *)getGesturePassword;
@end

NS_ASSUME_NONNULL_END
