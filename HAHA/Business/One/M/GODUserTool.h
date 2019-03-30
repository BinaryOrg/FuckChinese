//
//  GODUserTool.h
//  小灯塔
//
//  Created by Maker on 2018/4/4.
//  Copyright © 2018年 Maker. All rights reserved.
//  用户信息管理工具类 - 单例

#import <Foundation/Foundation.h>
#import "GODUserModel.h"

@interface GODUserTool : NSObject
+ (GODUserTool *)shared;
/** 是否登陆 */
+ (BOOL)isLogin;

/** 用户信息类 */
@property (nonatomic, strong) GODUserModel *user;
/** token */
@property (nonatomic, strong) NSString *token;
/** 用户的手机号码 */
@property (nonatomic, strong) NSString *mobile_number;


/**
 清除用户信息的方法, 如果有手机号码, 手机号码保留不清除
 */
- (void)clearUserInfo;

@end
