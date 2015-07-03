//
//  AIFLogger.h
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class AIFService;
@class AIFURLResponse;

@interface AIFLogger : NSObject

+ (void)logDebugInfoWithRequest:(NSURLRequest*)request apiName:(NSString*)apiName service:(AIFService*)service requestParams:(id)requestParams httpMethod:(NSString*)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse*)response resposeString:(NSString*)responseString request:(NSURLRequest*)request error:(NSError*)error;

+ (void)logDebugInfoWithCachedResponse:(AIFURLResponse*)response methodName:(NSString*)methodName serviceIdentifier:(AIFService*)service;

+ (instancetype)sharedInstance;
- (void)logWithActionCode:(NSString*)actionCode params:(NSDictionary*)params;

@end
