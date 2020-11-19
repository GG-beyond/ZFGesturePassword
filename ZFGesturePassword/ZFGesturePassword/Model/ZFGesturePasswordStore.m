//
//  ZFGesturePasswordStore.m
//  ZFGesturePassword
//
//  Created by 58 on 2018/12/17.
//  Copyright © 2018年 58. All rights reserved.
//

#import "ZFGesturePasswordStore.h"
static NSString *gestureKey = @"GestureKey";
@implementation ZFGesturePasswordStore

+ (instancetype)instance{
    
    static ZFGesturePasswordStore *gestureStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!gestureStore) {
        
            gestureStore = [[ZFGesturePasswordStore alloc] init];
        }
    });
    return gestureStore;
}
- (void)storePassword:(NSString *)gesturePassword{
    
    [[NSUserDefaults standardUserDefaults] setObject:gesturePassword forKey:gestureKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getGesturePassword{
    
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:gestureKey];
    return pwd?pwd:@"";
}
@end
