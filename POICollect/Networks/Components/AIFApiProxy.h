//
//  AIFApiProxy.h
//  POICollect
//  请求的代理类
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class AIFURLResponse;

/**
 *  回调block
 *
 *  @param response 
 */
typedef void (^AXCallback)(AIFURLResponse* response);

typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface AIFApiProxy : NSObject

#pragma mark - 类方法

+ (instancetype)sharedInstance;

#pragma mark - 实例方法

- (NSInteger)uploadPostWithParams:(NSDictionary*)params
                           photos:(NSArray*)photos
                serviceIdentifier:(NSString*)serviceIdentifiler
                       methodName:(NSString*)methodName
                          success:(AXCallback)success
                             fail:(AXCallback)fail
                         progress:(ProgressBlock)progress;

- (NSInteger)callGETWithParams:(NSDictionary*)params
             serviceIdentifier:(NSString*)serviceIdentifier
                    methodName:(NSString*)methodName
                       success:(AXCallback)success
                          fail:(AXCallback)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary*)params
              serviceIdentifier:(NSString*)serviceIdentifier
                     methodName:(NSString*)methodName
                        success:(AXCallback)success
                           fail:(AXCallback)fail;

/**
 *  取消requestID对应的请求
 *
 *  @param requestID requestID
 */
- (void)cancelRequestWithRequestID:(NSNumber*)requestID;

/**
 *  取消一个数组的请求
 *
 *  @param requestIDList requestID的数组
 */
- (void)cancelRequestWithRequestIDList:(NSArray*)requestIDList;

@end
