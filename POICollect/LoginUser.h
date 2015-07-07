//
//  LoginUser.h
//  POICollect
//  登录用户
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "User.h"

@interface LoginUser : NSObject

/**
 *  登录名
 */
@property (nonatomic, copy) NSString* loginName;

/**
 *  登录密码
 */
@property (nonatomic, copy) NSString* loginPass;

#pragma mark - 实例方法

- (NSString*)validateForm;

#pragma mark - 类方法

/**
 *  是否已经登录
 *
 *  @return 登录状态 
 */
+ (BOOL)isLogin;

+ (void)doLogin:(NSDictionary*)loginCallData;

+ (void)doLogout;

+ (User*)currentLoginUser;

#pragma mark - 实例方法

@end
