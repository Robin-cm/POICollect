//
//  AIFApiProxy.m
//  POICollect
//  请求的代理类
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AIFApiProxy.h"
#import "AIFServiceFactory.h"
#import "AIFURLResponse.h"
#import "AIFRequestGenerator.h"
#import "AIFLogger.h"

@interface AIFApiProxy ()

@property (nonatomic, strong) NSMutableDictionary* dispatchTable;

@property (nonatomic, strong) NSNumber* recordedRequestId;

@property (nonatomic, strong) AFHTTPRequestOperationManager* operationManager;

@end

@implementation AIFApiProxy

#pragma mark - Getter

- (NSMutableDictionary*)dispatchTable
{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPRequestOperationManager*)operationManager
{
    if (!_operationManager) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

#pragma mark - 类方法，单例

+ (instancetype)sharedInstance
{
    static AIFApiProxy* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 实例方法

- (NSInteger)callGETWithParams:(NSDictionary*)params serviceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest* request = [[AIFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSNumber* requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary*)params serviceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName success:(AXCallback)success fail:(AXCallback)fail
{
    NSURLRequest* request = [[AIFRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    NSNumber* requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

/**
 *  取消requestID对应的请求
 *
 *  @param requestID requestID
 */
- (void)cancelRequestWithRequestID:(NSNumber*)requestID
{
    NSOperation* requestOperation = self.dispatchTable[requestID];
    if (requestOperation) {
        [requestOperation cancel];
        [self.dispatchTable removeObjectForKey:requestID];
    }
}

/**
 *  取消一个数组的请求
 *
 *  @param requestIDList requestID的数组
 */
- (void)cancelRequestWithRequestIDList:(NSArray*)requestIDList
{
    for (NSNumber* requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - 实力私有方法

/**
 *  这个函数的存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现就行了
 *
 *  @param request NSURLRequest
 *  @param success 成功回调
 *  @param fail    失败回调
 *
 *  @return 返回requestID
 */
- (NSNumber*)callApiWithRequest:(NSURLRequest*)request success:(AXCallback)success fail:(AXCallback)fail
{
    NSNumber* requestId = [self generateRequestId];

    AFHTTPRequestOperation* httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:request
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            AFHTTPRequestOperation* storedOperation = self.dispatchTable[requestId];
            if (!storedOperation) {
                return;
            }
            else {
                [self.dispatchTable removeObjectForKey:requestId];
            }

            [AIFLogger logDebugInfoWithResponse:operation.response resposeString:operation.responseString request:operation.request error:nil];

            AIFURLResponse* response = [[AIFURLResponse alloc] initWithResponseString:operation.responseString requestId:requestId request:operation.request responseData:operation.responseData status:AIFURLResponseStatusSuccess];

            success ? success(response) : nil;
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            AFHTTPRequestOperation* storedOperation = self.dispatchTable[requestId];
            if (!storedOperation) {
                return;
            }
            else {
                [self.dispatchTable removeObjectForKey:requestId];
            }

            [AIFLogger logDebugInfoWithResponse:operation.response resposeString:operation.responseString request:operation.request error:nil];

            AIFURLResponse* response = [[AIFURLResponse alloc] initWithResponseString:operation.responseString requestId:requestId request:operation.request responseData:operation.responseData error:error];

            fail ? fail(response) : nil;

        }];

    self.dispatchTable[requestId] = httpRequestOperation;
    [[self.operationManager operationQueue] addOperation:httpRequestOperation];
    return requestId;
}

- (NSNumber*)generateRequestId
{
    if (!_recordedRequestId) {
        _recordedRequestId = @(1);
    }
    else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        }
        else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

@end
