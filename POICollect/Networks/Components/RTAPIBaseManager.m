//
//  RTAPIBaseManager.m
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "RTAPIBaseManager.h"
#import "AIFURLResponse.h"
#import "AIFServiceFactory.h"
#import "AIFNetworking.h"
#import "AIFLogger.h"
#import "AIFAppContext.h"
#import "AIFApiProxy.h"
#import "AIFCache.h"

#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                                                                                                                                                                                                                                                                                                  \
    {                                                                                                                                                                                                                                                                                                                                                                          \
        REQUEST_ID = [[AIFApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(AIFURLResponse * response) { [self successedOnCallingAPI:response]; } fail:^(AIFURLResponse * response) { [self failedOnCallingAPI:response withErrorType:RTAPIManagerErrorTypeDefault]; }]; \
        [self.requestIdList addObject:@(REQUEST_ID)];                                                                                                                                                                                                                                                                                                                          \
    }

@interface RTAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRowData;

/**
 *  BaseManager是不会去设置errorMessage的，派生的子类manager可能要给controller提供错误信息。所以为了统一外部调用的出口，设置了这个变量。
 *  派生的子类需要通过extension来保证errorMessage在对外只读的情况下，使派生的manager类对errorMessage具有读写权限
 */
@property (nonatomic, copy, readwrite) NSString* errorMessage;

/**
 *  错误类型
 */
@property (nonatomic, readwrite) RTAPIManagerErrorType errorType;

@property (nonatomic, strong) NSMutableArray* requestIdList;

@property (nonatomic, strong) AIFCache* cache;

@end

@implementation RTAPIBaseManager

#pragma mark - 生命周期，life circle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;

        _fetchedRowData = nil;

        _errorMessage = nil;
        _errorType = RTAPIManagerErrorTypeDefault;

        if ([self conformsToProtocol:@protocol(RTAPIManager)]) {
            self.child = (id<RTAPIManager>)self;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - Getter

- (AIFCache*)cache
{
    if (!_cache) {
        _cache = [AIFCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray*)requestIdList
{
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [AIFAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = RTAPIManagerErrorTypeNoNetwork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    return [self.requestIdList count] > 0;
}

#pragma mark - 公共方法

- (void)cancelAllRequests
{
    [[AIFApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestId
{
    [self removeRequestIdWithRequestId:requestId];
    [[AIFApiProxy sharedInstance] cancelRequestWithRequestID:@(requestId)];
}

- (id)fetchDataWithReformer:(id<RTAPIManagerCallBackDataReformer>)reformer
{
    id resultData = nil;
    if (reformer && [reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRowData];
    }
    else {
        resultData = [self.fetchedRowData mutableCopy];
    }
    return resultData;
}

/**
 *  如果需要在调用API之前额外添加一些参数，比如pageNumber之类的，就在这里添加
 *  子类中覆盖这个函数的时候就不要调用[super reformParams:params]了
 *
 *  @param params <#params description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary*)reformParams:(NSDictionary*)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];

    if (childIMP == selfIMP) {
        return params;
    }
    else {
        //如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP
        //吐过child是另一个对象，就会跑到这里
        NSDictionary* result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        }
        else {
            return params;
        }
    }
}

- (void)cleanData
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];

    if (childIMP == selfIMP) {
        self.fetchedRowData = nil;
        self.errorMessage = nil;
        self.errorType = RTAPIManagerErrorTypeDefault;
    }
    else {
        //如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP
        //吐过child是另一个对象，就会跑到这里
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

- (BOOL)shouldCache
{
    return kAIFShouldCache;
}

/**
 *  开始加载数据，尽量使用这个方法，这个方法会通过param source来获取参数，这使得参数的生成逻辑位于controller中的固定位置
 *
 *  @return 返回的是 NSInteger 的 requestId
 */
- (NSInteger)loadData
{
    NSDictionary* params = [self.paramSource paramsForAPI:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

#pragma mark - 私有方法,call API

- (NSInteger)loadDataWithParams:(NSDictionary*)params
{
    NSInteger requestId = 0;
    NSDictionary* apiParams = [self reformParams:params];

    if ([self shouldCallAPIWithParams:params]) {
        if ([self.validator manager:self isCorrectWithParamsData:params]) {

            if ([self shouldCache] && [self hasCacheWithParams:params]) {
                return 0;
            }

            //有网络，进行请求
            if ([self isReachable]) {
                switch (self.child.requestType) {
                case RTAPIManagerRequestTypeGet:
                    AXCallAPI(GET, requestId);
                    break;
                case RTAPIManagerRequestTypePost:
                    AXCallAPI(POST, requestId);
                    break;

                case RTAPIManagerRequestTypePush:
                    AXCallAPI(POST, requestId);
                    break;

                case RTAPIManagerRequestTypeDelete:
                    AXCallAPI(GET, requestId);
                    break;

                default:
                    break;
                }

                NSMutableDictionary* params = [apiParams mutableCopy];
                params[kRTAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
            }
            else {
                [self failedOnCallingAPI:nil withErrorType:RTAPIManagerErrorTypeNoNetwork];
            }
        }
        else {
            [self failedOnCallingAPI:nil withErrorType:RTAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - 拦截器的方法

- (void)beforePreformSuccessWithResponse:(AIFURLResponse*)response
{
    self.errorType = RTAPIManagerErrorTypeSuccess;
    if (self != self.intercepter && [self.intercepter respondsToSelector:@selector(manager:afterPreformSuccessWithResponse:)]) {
        [self.intercepter manager:self beforePreformSuccessWithResponse:response];
    }
}

- (void)afterPreformSuccessWithResponse:(AIFURLResponse*)response
{
    if (self != self.intercepter && [self.intercepter respondsToSelector:@selector(manager:afterPreformSuccessWithResponse:)]) {
        [self.intercepter manager:self afterPreformSuccessWithResponse:response];
    }
}

- (void)beforePreformFailWithResponse:(AIFURLResponse*)response
{
    if (self != self.intercepter && [self.intercepter respondsToSelector:@selector(manager:beforePreformFailWithResponse:)]) {
        [self.intercepter manager:self beforePreformFailWithResponse:response];
    }
}

- (void)afterPreformFailWithResponse:(AIFURLResponse*)response
{
    if (self != self.intercepter && [self.intercepter respondsToSelector:@selector(manager:afterPreformFailWithResponse:)]) {
        [self.intercepter manager:self afterPreformFailWithResponse:response];
    }
}

/**
 *  返回YES才能继续调用API
 *
 *  @param params 参数字典
 *
 *  @return 是否继续执行
 */
- (BOOL)shouldCallAPIWithParams:(NSDictionary*)params
{
    if (self != self.intercepter && [self.intercepter respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.intercepter manager:self shouldCallAPIWithParams:params];
    }
    else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary*)params
{
    if (self != self.intercepter && [self.intercepter respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.intercepter manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - 回调的私有方法

- (void)apiCallBack:(AIFURLResponse*)response
{
}

- (void)successedOnCallingAPI:(AIFURLResponse*)response
{
    if (response.content) {
        self.fetchedRowData = [response.content copy];
    }
    else {
        self.fetchedRowData = [response.responseData copy];
    }

    [self removeRequestIdWithRequestId:response.requestId];

    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        if (kAIFShouldCache && !response.isCache) {

            //如果需要缓存的话，在这里缓存返回来的数据
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }

        [self beforePreformSuccessWithResponse:response];
        [self.delegate managerCallAPIDidSuccess:self];
        [self afterPreformSuccessWithResponse:response];
    }
    else {
        [self failedOnCallingAPI:response withErrorType:RTAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(AIFURLResponse*)response withErrorType:(RTAPIManagerErrorType)errorType
{
    self.errorType = errorType;
    [self removeRequestIdWithRequestId:response.requestId];
    [self beforePreformFailWithResponse:response];
    [self.delegate managerCallAPIDidFailed:self];
    [self afterPreformFailWithResponse:response];
}

#pragma mark - 私有方法

- (void)removeRequestIdWithRequestId:(NSInteger)requestId
{
    NSNumber* requestIdToRemove = nil;
    for (NSNumber* storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIdToRemove = storedRequestId;
            break;
        }
    }
    if (requestIdToRemove) {
        [self.requestIdList removeObject:requestIdToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary*)params
{
    NSString* serviceIdentifier = self.child.serviceType;
    NSString* methodName = self.child.methodName;
    NSData* result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    if (!result) {
        return NO;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        AIFURLResponse* response = [[AIFURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [AIFLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[AIFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [self successedOnCallingAPI:response];
    });

    return YES;
}

@end
