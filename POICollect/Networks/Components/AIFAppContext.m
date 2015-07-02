//
//  AIFAppContext.m
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "AIFAppContext.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "UIDevice+IdentifierAddition.h"
#import "NSObject+AXNetworkingMethods.h"

@interface AIFAppContext ()

@property (nonatomic, strong) UIDevice* device;

/**
 *  设备名称 
 */
@property (nonatomic, copy, readwrite) NSString* mName;

/**
 *  网络状态
 */
@property (nonatomic, copy, readwrite) NSString* net;

/**
 *  ip地址
 */
@property (nonatomic, copy, readwrite) NSString* ip;

/**
 *  系统的名称
 */
@property (nonatomic, copy, readwrite) NSString* osName;

/**
 *  系统版本
 */
@property (nonatomic, copy, readwrite) NSString* osVersion;

/**
 *  bundle版本
 */
@property (nonatomic, copy, readwrite) NSString* bundleVersion;

/**
 *  macid Mac地址
 */
@property (nonatomic, copy, readwrite) NSString* macid;

/**
 *  请求来源，都是“mobile”
 */
@property (nonatomic, copy, readwrite) NSString* from;

/**
 *  系统的类型
 */
@property (nonatomic, copy, readwrite) NSString* osType;

/**
 *  当前的时间
 */
@property (nonatomic, copy, readwrite) NSString* ct;

/**
 *  手机的型号
 */
@property (nonatomic, copy, readwrite) NSString* pModel;

@end

@implementation AIFAppContext

#pragma mark - 公用方法

+ (instancetype)sharedInstance
{
    static AIFAppContext* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFAppContext alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Getter

- (UIDevice*)device
{
    if (!_device) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString*)mName
{
    if (!_mName) {
        _mName = [[self.device.model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] AIF_defaultValue:@""];
    }
    return _mName;
}

- (NSString*)net
{
    if (!_net) {
        _net = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            _net = @"2G3G";
        }
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            _net = @"WiFi";
        }
    }
    return _net;
}

- (NSString*)ip
{
    if (!_ip) {
        _ip = @"Error";
        struct ifaddrs* interfaces = NULL;
        struct ifaddrs* temp_addr = NULL;
        int success = 0;
        success = getifaddrs(&interfaces);
        if (success == 0) {
            temp_addr = interfaces;
            while (temp_addr != NULL) {
                if (temp_addr->ifa_addr->sa_family == AF_INET) {
                    if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);
    }
    return _ip;
}

- (NSString*)osName
{
    if (!_osName) {
        _osName = [[self.device.systemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] AIF_defaultValue:@""];
    }
    return _osName;
}

- (NSString*)osVersion
{
    if (!_osVersion) {
        _osVersion = [self.device systemVersion];
    }
    return _osVersion;
}

- (NSString*)bundleVersion
{
    if (!_bundleVersion) {
        _bundleVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] AIF_defaultValue:@""];
    }
    return _bundleVersion;
}

- (NSString*)macid
{
    if (!_macid) {
        _macid = [[self.device AIF_macaddressMD5] AIF_defaultValue:@""];
    }
    return _macid;
}

- (NSString*)from
{
    if (!_from) {
        _from = @"mobile";
    }
    return _from;
}

- (NSString*)osType
{
    if (!_osType) {
        _osType = [self.device.AIF_ostype AIF_defaultValue:@""];
    }
    return _osType;
}

- (NSString*)qTime
{
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:NSLocalizedString(@"yyyyMMddHHmmss", nil)];
    return [dateFormater stringFromDate:[NSDate date]];
}

- (NSString*)ct
{
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [dateFormater stringFromDate:[NSDate date]];
}

- (NSString*)pModel
{
    if (!_pModel) {
        _pModel = [self.device AIF_machineType];
    }
    return _pModel;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    }
    else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

@end
