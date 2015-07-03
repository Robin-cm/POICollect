//
//  UserLoginManager.m
//  POICollect
//  用户登录
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UserLoginManager.h"
#import "AIFNetworking.h"

@implementation UserLoginManager

#pragma mark - 生命周期

#pragma mark - RTAPIManager

- (NSString*)methodName
{
    return @"user!doNotNeedSessionAndSecurity_login.tdt";
}

- (NSString*)serviceType
{
    return kAIFServiceUserLogin;
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypePost;
}

@end
