//
//  UserRegistManager.m
//  POICollect
//  用户注册
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UserRegistManager.h"
#import "AIFNetworking.h"

@implementation UserRegistManager

#pragma mark - RTAPIManager

- (NSString*)methodName
{
    return @"user!doNotNeedSessionAndSecurity_reg.tdt";
}

- (NSString*)serviceType
{
    return kAIFServiceUserRegist;
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypePost;
}

@end
