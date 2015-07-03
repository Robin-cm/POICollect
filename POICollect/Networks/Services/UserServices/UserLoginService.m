//
//  UserLoginService.m
//  POICollect
//  用户登录
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UserLoginService.h"
#import "AIFNetworkingConfiguration.h"

@implementation UserLoginService

#pragma mark - AIFServiceProtocol

- (BOOL)isOnline
{
    return YES;
}

- (NSString*)onlineApiBaseURL
{
    return kAPPBaseOnlineURL;
}

- (NSString*)offlineApiBaseURL
{
    return self.onlineApiBaseURL;
}

@end
