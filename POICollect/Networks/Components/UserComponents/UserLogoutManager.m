//
//  UserLogoutManager.m
//  POICollect
//  用户注销
//  Created by 常敏 on 15/7/7.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UserLogoutManager.h"
#import "AIFNetworking.h"

@implementation UserLogoutManager

- (NSString*)methodName
{
    return @"user!mobile_logout.tdt";
}

- (NSString*)serviceType
{
    return kAIFServiceUserLogout;
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypePost;
}

@end
