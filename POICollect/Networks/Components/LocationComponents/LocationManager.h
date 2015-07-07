//
//  LocationManager.h
//  POICollect
//  位置管理类
//  Created by 常敏 on 15/7/7.
//  Copyright (c) 2015年 cm. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "RTAPIBaseManager.h"

extern NSString* const LocationManagerDidSuccessedLocateNotification;

extern NSString* const LocationManagerDidFailedLocateNotification;

/**
 *  定位结果
 */
typedef NS_ENUM(NSUInteger, LocationManagerLocationResult) {
    /**
     *  默认状态
     */
    LocationManagerLocationResultDefault,
    /**
     *  定位中
     */
    LocationManagerLocationResultLocating,
    /**
     *  定位成功
     */
    LocationManagerLocationResultSuccess,
    /**
     *  定位失败
     */
    LocationManagerLocationResultFail,
    /**
     *  调用API参数错误
     */
    LocationManagerLocationResultParamsError,
    /**
     *  超时
     */
    LocationManagerLocationResultTimeout,
    /**
     *  没有网络
     */
    LocationManagerLocationResultNoNetwork,
    /**
     *  API没有返回数据或者数据错误 
     */
    LocationManagerLocationResultNoContent
};

/**
 *  定位服务的状态
 */
typedef NS_ENUM(NSUInteger, LocationManagerLocationServiceStatus) {
    /**
     *  默认状态
     */
    LocationManagerLocationServiceStatusDefault,
    /**
     *  定位功能正常
     */
    LocationManagerLocationServiceStatusOK,
    /**
     *  未知错误
     */
    LocationManagerLocationServiceStatusUnknownError,
    /**
     *  定位功能关掉了
     */
    LocationManagerLocationServiceStatusUnAvailable,
    /**
     *  定位功能打开，但是用户不允许使用定位
     */
    LocationManagerLocationServiceStatusNoAuthorization,
    /**
     *  没有网络
     */
    LocationManagerLocationServiceStatusNoNetwork,
    /**
     *  用户还没有做出是否允许应用使用定位功能的决定，第一次安装应用的时候
     */
    LocationManagerLocationServiceStatusNotDetermined
};

@interface LocationManager : RTAPIBaseManager <RTAPIManager, CLLocationManagerDelegate>

#pragma mark - 属性

/**
 *  当前的位置
 */
@property (nonatomic, strong, readonly) CLLocation* currentLocation;

/**
 *  地址的名字
 */
@property (nonatomic, copy, readonly) NSString* currentLocationAddress;

/**
 *  当前的定位结果
 */
@property (nonatomic, readonly) LocationManagerLocationResult locationResult;

/**
 *  当前的定位服务状态 
 */
@property (nonatomic, readonly) LocationManagerLocationServiceStatus locationStatus;

#pragma mark - 初始化方法

+ (instancetype)sharedManager;

#pragma mark - 实例方法

/**
 *  检查定位状态，并且显示提示
 *
 *  @param showingAlert 是否显示提示框
 *
 *  @return 
 */
- (BOOL)checkLocationAndShowingAlert:(BOOL)showingAlert;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  结束定位
 */
- (void)stopLocation;

/**
 *  重新定位
 */
- (void)restartLocation;

/**
 *  逆编码得到地址信息
 *
 *  @param location 位置坐标
 *  @param geocoder geocoder
 */
- (void)fetchAddressInfoWithLocation:(CLLocation*)location geocoder:(CLGeocoder*)geocoder;

@end
