//
//  POIUploadService.m
//  POICollect
//
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIUploadService.h"
#import "AIFNetworkingConfiguration.h"

@implementation POIUploadService

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
