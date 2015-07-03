//
//  UserRegistService.m
//  POICollect
//  用户注册
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "UserRegistService.h"
#import "AIFNetworkingConfiguration.h"

@implementation UserRegistService

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
