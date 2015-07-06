//
//  AIFRequestURLGenerator.m
//  POICollect
//
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFRequestURLGenerator.h"
#import "AIFNetworkingConfiguration.h"
#import "AIFService.h"
#import "AIFServiceFactory.h"

@implementation AIFRequestURLGenerator

#pragma mark - 类方法

+ (instancetype)sharedInstance
{
    static AIFRequestURLGenerator* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFRequestURLGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSString*)generateUploadRequestURLWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName
{
    NSString* url = @"";
    AIFService* service = [[AIFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    url = [NSString stringWithFormat:@"%@/%@", service.apiBaseURL, methodName];
    //    [AIFLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    return url;
}

@end
