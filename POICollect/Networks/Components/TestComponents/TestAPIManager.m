//
//  TestAPIManager.m
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "TestAPIManager.h"
#import "AIFNetworking.h"

@interface TestAPIManager ()

@property (nonatomic, copy, readwrite) NSString* methodname;

@property (nonatomic, strong) NSString* serviceType;

@end

@implementation TestAPIManager

#pragma mark - 生命周期

+ (instancetype)sharedInstance
{
    static TestAPIManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TestAPIManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _methodname = @"";
        _serviceType = kAIFServiceTest;

        self.delegate = self;
        self.paramSource = self;
        self.validator = self;
    }
    return self;
}

#pragma mark - RTAPIManager

- (NSString*)methodName
{
    return @"";
}

- (NSString*)serviceType
{
    return kAIFServiceTest;
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypeGet;
}

#pragma mark - RTAPIManagerValidator

- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithCallBackData:(NSDictionary*)data
{
    return YES;
}

- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithParamsData:(NSDictionary*)data
{
    return YES;
}

#pragma mark - RTAPIManagerParamSourceDelegate

- (NSDictionary*)paramsForAPI:(RTAPIBaseManager*)manager
{
    return @{};
}

#pragma mark - RTAPIManagerApiCallBackDelegate

- (void)managerCallAPIDidSuccess:(RTAPIBaseManager*)manager
{
    if ([manager isKindOfClass:[TestAPIManager class]]) {
        NSDictionary* result = [manager fetchDataWithReformer:nil];
        NSLog(@"成功返回了数据了: %@", result);
    }
}

- (void)managerCallAPIDidFailed:(RTAPIBaseManager*)manager
{
    NSLog(@"请求数据失败: %@", manager.errorMessage);
}

@end
