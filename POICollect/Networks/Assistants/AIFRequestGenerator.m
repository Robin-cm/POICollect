//
//  AIFRequestGenerator.m
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>
#import "AIFNetworkingConfiguration.h"
#import "AIFService.h"
#import "AIFServiceFactory.h"
#import "AIFCommonParamsGenerator.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "NSURLRequest+AIFNetworkingMethods.h"
#import "AIFLogger.h"

@interface AIFRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer* httpRequestSerializer;

@end

@implementation AIFRequestGenerator

#pragma mark - 类方法

+ (instancetype)sharedInstance
{
    static AIFRequestGenerator* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFRequestGenerator alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 类方法

- (AFHTTPRequestSerializer*)httpRequestSerializer
{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kAIFCacheOutdateTimeSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - 实力公共方法

- (NSURLRequest*)generateGETRequestWithServiceIdentifier:(NSString*)serviceIdentifier requestParams:(NSDictionary*)requestParams methodName:(NSString*)methodName
{
    AIFService* service = [[AIFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSMutableDictionary* allParams = [NSMutableDictionary dictionaryWithDictionary:[AIFCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@?%@", service.apiBaseURL, methodName, [allParams AIF_urlParamsStringSignature:NO]];
    NSMutableURLRequest* request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    request.timeoutInterval = kAIFNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    [AIFLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSURLRequest*)generatePOSTRequestWithServiceIdentifier:(NSString*)serviceIdentifier requestParams:(NSDictionary*)requestParams methodName:(NSString*)methodName
{
    AIFService* service = [[AIFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@?%@", service.apiBaseURL, methodName, [[AIFCommonParamsGenerator commonParamsDictionary] AIF_urlParamsStringSignature:NO]];
    NSURLRequest* request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:nil];
    request.requestParams = requestParams;
    [AIFLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"POST"];
    return request;
}

@end
