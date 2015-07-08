//
//  AIFServiceFactory.m
//  POICollect
//  service的工厂类
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFServiceFactory.h"
#import "TestService.h"
#import "UserLoginService.h"
#import "UserRegistService.h"
#import "UserLogoutService.h"
#import "POIUploadService.h"

#pragma mark - Service的名称

NSString* const kAIFServiceTest = @"kAIFServiceTest";

NSString* const kAIFServiceUserLogin = @"kAIFServiceUserLogin";

NSString* const kAIFServiceUserRegist = @"kAIFServiceUserRegist";

NSString* const kAIFServicePOIUpdate = @"kAIFServicePOIUpdate";

NSString* const kAIFServiceUserLogout = @"kAIFServiceUserLogout";

@interface AIFServiceFactory ()

/**
 *  保存所有的已经创建的Service
 */
@property (nonatomic, strong) NSMutableDictionary* serviceStorage;

@end

@implementation AIFServiceFactory

#pragma mark - Getter

- (NSMutableDictionary*)serviceStorage
{
    if (!_serviceStorage) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - 方法

+ (instancetype)sharedInstance
{
    static AIFServiceFactory* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFServiceFactory alloc] init];
    });
    return sharedInstance;
}

/**
 *  得到标识对应的Service
 *
 *  @param identifier 标识
 *
 *  @return 返回对应的Service
 */
- (AIFService<AIFServiceProtocol>*)serviceWithIdentifier:(NSString*)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - 私有方法

- (AIFService<AIFServiceProtocol>*)newServiceWithIdentifier:(NSString*)identifier
{
    if ([identifier isEqualToString:kAIFServiceTest]) {
        return [[TestService alloc] init];
    }

    if ([identifier isEqualToString:kAIFServiceUserLogin]) {
        return [[UserLoginService alloc] init];
    }

    if ([identifier isEqualToString:kAIFServiceUserRegist]) {
        return [[UserRegistService alloc] init];
    }

    if ([identifier isEqualToString:kAIFServiceUserLogout]) {
        return [[UserLogoutService alloc] init];
    }

    if ([identifier isEqualToString:kAIFServicePOIUpdate]) {
        return [[POIUploadService alloc] init];
    }

    return nil;
}

@end
