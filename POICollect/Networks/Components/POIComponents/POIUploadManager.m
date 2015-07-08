//
//  POIUploadManager.m
//  POICollect
//  POI点上传管理类
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIUploadManager.h"
#import "AIFNetworking.h"

@implementation POIUploadManager

- (NSString*)methodName
{
    return @"mobile_uploadPoi.tdt";
}

- (NSString*)serviceType
{
    return kAIFServicePOIUpdate;
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypePost;
}

@end
