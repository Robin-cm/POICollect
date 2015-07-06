//
//  LoginUser.m
//  POICollect
//  登录用户
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginUser.h"
#import "User.h"

static NSString* const sLoginStatus = @"sLoginStatus";
static NSString* const sLoginUserDict = @"sLoginUserDict";

static User* CurrentLoginUser;

@implementation LoginUser

/**
 *  是否已经登录
 *
 *  @return 登录状态
 */
+ (BOOL)isLogin
{
    NSNumber* loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:sLoginStatus];
    if (loginStatus.boolValue && [LoginUser currentLoginUser]) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (void)doLogin:(NSDictionary*)loginCallData
{
    if (loginCallData) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:sLoginStatus];
        [defaults setObject:loginCallData forKey:sLoginUserDict];
        CurrentLoginUser = [User userFromJson:loginCallData];
        [defaults synchronize];
    }
}

+ (void)doLogout
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:sLoginStatus];
    [defaults synchronize];
}

+ (User*)currentLoginUser
{
    if (!CurrentLoginUser) {
        NSDictionary* loginData = [[NSUserDefaults standardUserDefaults] objectForKey:sLoginUserDict];
        CurrentLoginUser = loginData ? [User userFromJson:loginData] : nil;
    }
    return CurrentLoginUser;
}

@end
