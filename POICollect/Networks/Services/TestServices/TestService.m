//
//  TestService.m
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "TestService.h"

@implementation TestService

#pragma mark - AIFServiceProtocol

- (BOOL)isOnline
{
    return YES;
}

- (NSString*)onlineApiBaseURL
{
    return @"http://www.baidu.com";
}

- (NSString*)offlineApiBaseURL
{
    return @"http://www.baidu.com";
}

@end
