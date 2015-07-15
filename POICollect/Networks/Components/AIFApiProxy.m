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
#import "AIFRequestURLGenerator.h"
#import "CMPhoto.h"
#import "NSString+AXNetworkingMethods.h"

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

- (NSInteger)uploadPostWithParams:(NSDictionary*)params photos:(NSArray*)photos serviceIdentifier:(NSString*)serviceIdentifiler methodName:(NSString*)methodName success:(AXCallback)success fail:(AXCallback)fail progress:(ProgressBlock)progress
{

    NSURLRequest* request = [[AIFRequestGenerator sharedInstance] generatePOSTUploadRequestWithServiceIdentifier:serviceIdentifiler
                                                                                                   requestParams:params
                                                                                                      methodName:methodName
                                                                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                           if (photos && photos.count > 0) {
                                                                                               NSObject* firstObj = [photos objectAtIndex:0];
                                                                                               if ([firstObj isKindOfClass:[CMPhoto class]]) {
                                                                                                   //数组中是CMPhoto类型
                                                                                                   for (CMPhoto* photo in photos) {
                                                                                                       //                        NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:@"AssetsPickerChecked"], 1);

                                                                                                       NSLog(@"图片的地址是: %@", [photo getImageName]);
                                                                                                       NSString* picCacheDirPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:photo.imageURLString];

                                                                                                       NSData* data = [[NSData alloc] initWithContentsOfFile:picCacheDirPath];
                                                                                                       if (data) {
                                                                                                           //                            [formData appendPartWithFormData:data name:@"img"];
                                                                                                           [formData appendPartWithFileData:data name:@"img" fileName:[photo getImageName] mimeType:@"image/jpeg"];
                                                                                                       }

                                                                                                       //                        [formData appendPartWithFileURL:[NSURL URLWithString:photo.imageURLString] name:@"img" error:nil];
                                                                                                   }
                                                                                               }
                                                                                               else if ([firstObj isKindOfClass:[NSString class]]) {
                                                                                                   //数组中是字符串类型
                                                                                                   for (NSString* urlStr in photos) {
                                                                                                       [formData appendPartWithFileURL:[NSURL URLWithString:urlStr] name:@"image" error:nil];
                                                                                                   }
                                                                                               }
                                                                                               else if ([firstObj isKindOfClass:[UIImage class]]) {
                                                                                                   //数组中是UIImage类型
                                                                                                   for (UIImage* img in photos) {
                                                                                                       [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.5f) name:@"img" fileName:[NSString stringWithFormat:@"image_%@", [NSString currentDateStr]] mimeType:@"image/jpeg"];
                                                                                                   }
                                                                                               }
                                                                                           }
                                                                                       }];

    NSNumber* requestId = [self callUploadDataWithRequest:request success:success fail:fail progress:progress];

    //旧的实现方法

    //    NSString* uploadURL = [[AIFRequestURLGenerator sharedInstance] generateUploadRequestURLWithServiceIdentifier:serviceIdentifiler methodName:methodName];

    //    NSNumber* requestId = [self uploadDataWithRequestURL:uploadURL photos:photos params:params success:success fail:fail progress:progress];
    return [requestId integerValue];
}

- (NSInteger)callGETWithParams:(NSDictionary*)params serviceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName
                       success:(AXCallback)success
                          fail:(AXCallback)fail
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

- (NSNumber*)callUploadDataWithRequest:(NSURLRequest*)request success:(AXCallback)success fail:(AXCallback)fail progress:(ProgressBlock)progress
{
    NSNumber* requestId = [self generateRequestId];
    AFHTTPRequestOperation* httpUploadOperation = [self.operationManager HTTPRequestOperationWithRequest:request
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

    [httpUploadOperation setUploadProgressBlock:progress];
    self.dispatchTable[requestId] = httpUploadOperation;
    [[self.operationManager operationQueue] addOperation:httpUploadOperation];
    return requestId;
}

- (NSNumber*)uploadDataWithRequestURL:(NSString*)url photos:(NSArray*)photos params:(NSDictionary*)params success:(AXCallback)success fail:(AXCallback)fail progress:(ProgressBlock)progress
{
    NSNumber* requestId = [self generateRequestId];

    AFHTTPRequestOperation* httpUploadOperation = [self.operationManager POST:url
        parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (photos && photos.count > 0) {
                NSObject* firstObj = [photos objectAtIndex:0];
                if ([firstObj isKindOfClass:[CMPhoto class]]) {
                    //数组中是CMPhoto类型
                    for (CMPhoto* photo in photos) {
                        //                        NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:@"AssetsPickerChecked"], 1);

                        NSLog(@"图片的地址是: %@", [photo getImageName]);
                        NSString* picCacheDirPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:photo.imageURLString];

                        NSData* data = [[NSData alloc] initWithContentsOfFile:picCacheDirPath];
                        if (data) {
                            //                            [formData appendPartWithFormData:data name:@"img"];
                            [formData appendPartWithFileData:data name:@"img" fileName:[photo getImageName] mimeType:@"image/jpeg"];
                        }

                        //                        [formData appendPartWithFileURL:[NSURL URLWithString:photo.imageURLString] name:@"img" error:nil];
                    }
                }
                else if ([firstObj isKindOfClass:[NSString class]]) {
                    //数组中是字符串类型
                    for (NSString* urlStr in photos) {
                        [formData appendPartWithFileURL:[NSURL URLWithString:urlStr] name:@"image" error:nil];
                    }
                }
                else if ([firstObj isKindOfClass:[UIImage class]]) {
                    //数组中是UIImage类型
                    for (UIImage* img in photos) {
                        [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.5f) name:@"img" fileName:[NSString stringWithFormat:@"image_%@", [NSString currentDateStr]] mimeType:@"image/jpeg"];
                    }
                }
            }
        }
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

    [httpUploadOperation setUploadProgressBlock:progress];
    self.dispatchTable[requestId] = httpUploadOperation;
    //    [[self.operationManager operationQueue] addOperation:httpUploadOperation];
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
