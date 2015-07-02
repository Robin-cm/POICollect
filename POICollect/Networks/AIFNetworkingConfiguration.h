//
//  AIFNetworkingConfiguration.h
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#ifndef POICollect_AIFNetworkingConfiguration_h
#define POICollect_AIFNetworkingConfiguration_h

typedef enum {
    AIFURLResponseStatusSuccess,
    AIFURLResponseStatusErrorTimeout,
    AIFURLResponseStatusErrorNoNetwork
} AIFURLResponseStatus;

static NSTimeInterval kAIFNetworkingTimeoutSeconds = 20.f;

static BOOL kAIFShouldCache = YES;
static NSTimeInterval kAIFCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kAIFCacheCountLimit = 1000; // 最多1000条cache

#endif
