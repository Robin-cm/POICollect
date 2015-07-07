//
//  UserLogoutService.m
//  POICollect
//  用户注销
//  Created by 常敏 on 15/7/7.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UserLogoutService.h"
#import "AIFNetworkingConfiguration.h"

@implementation UserLogoutService

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
