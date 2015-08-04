//
//  LocationManager.m
//  POICollect
//  位置管理类
//  Created by 常敏 on 15/7/7.
//  Copyright (c) 2015年 cm. All rights reserved.
//

NSString* const LocationManagerDidSuccessedLocateNotification = @"LocationManagerDidSuccessedLocateNotification";

NSString* const LocationManagerDidFailedLocateNotification = @"LocationManagerDidFailedLocateNotification";

NSString* const locationManagerDidSuccessFetchAddressInfoNotification = @"locationManagerDidSuccessFetchAddressInfoNotification";

NSString* const locationManagerDidFailedFetchAddressInfoNotification = @"locationManagerDidFailedFetchAddressInfoNotification";

NSString* const locationManagerAddressInfoKey = @"locationManagerAddressInfoKey";

#import "LocationManager.h"

@interface LocationManager ()

/**
 *  当前的位置
 */
@property (nonatomic, strong, readwrite) CLLocation* currentLocation;

/**
 *  地址的名字
 */
@property (nonatomic, copy, readwrite) NSString* currentLocationAddress;

/**
 *  当前的定位结果
 */
@property (nonatomic, readwrite) LocationManagerLocationResult locationResult;

/**
 *  当前的定位服务状态
 */
@property (nonatomic, readwrite) LocationManagerLocationServiceStatus locationStatus;

/**
 *  系统位置管理类
 */
@property (nonatomic, strong) CLLocationManager* locationManager;

/**
 *  反地理编码
 */
@property (nonatomic, strong) CLGeocoder* geoCoder;

/**
 *  定位成功之后就不需要再通知到外面了，防止外面的数据变化
 */
@property (nonatomic, assign) BOOL shouldNotifyOtherObjects;

@end

@implementation LocationManager

#pragma mark - RTAPIManager

- (NSString*)methodName
{
    return @"";
}

- (NSString*)serviceType
{
    return @"";
}

- (RTAPIManagerRequestType)requestType
{
    return RTAPIManagerRequestTypePost;
}

#pragma mark - 初始化

+ (instancetype)sharedManager
{
    static LocationManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Getter

- (CLGeocoder*)geoCoder
{
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    return _geoCoder;
}

- (CLLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

#pragma mark - 生命周期

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationResult = LocationManagerLocationResultDefault;
        self.locationStatus = LocationManagerLocationServiceStatusDefault;

        self.shouldNotifyOtherObjects = YES;
    }
    return self;
}

#pragma mark - 自定义公共实例方法

- (BOOL)checkLocationAndShowingAlert:(BOOL)showingAlert
{
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    LocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == LocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }
    else if (authorizationStatus == LocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    }
    else {
        result = NO;
    }

    if (serviceEnable && result) {
        result = YES;
    }
    else {
        result = NO;
    }

    if (!result) {
        [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
    }

    if (showingAlert && !result) {
        NSString* message = @"请到“设置->隐私->定位服务”中开启定位";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    return result;
}

- (void)startLocation
{
    if ([self checkLocationAndShowingAlert:NO]) {
        self.locationResult = LocationManagerLocationResultLocating;
        if (IOS_SYSTEM_VERSION_8_OR_ABOVE) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    else {
        [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

- (void)stopLocation
{
    if ([self checkLocationAndShowingAlert:NO]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)restartLocation
{
    [self stopLocation];
    [self startLocation];
}

- (void)fetchAddressInfoWithLocation:(CLLocation*)location
{
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray* placemarks, NSError* error) {
                            CLPlacemark* placemark = [placemarks lastObject];
                            if (placemark) {
                                NSDictionary* addressDictionary = placemark.addressDictionary;

                                NSString* currentAddress = [addressDictionary objectForKey:@"Name"];

                                if (!currentAddress) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [[NSNotificationCenter defaultCenter] postNotificationName:locationManagerDidFailedFetchAddressInfoNotification object:self userInfo:nil];
                                    });
                                    return;
                                }

                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:locationManagerDidSuccessFetchAddressInfoNotification object:self userInfo:@{ locationManagerAddressInfoKey : currentAddress }];
                                });
                            }
                        }];
}

/**
 *  逆编码得到地址信息
 *
 *  @param location 位置坐标
 *  @param geocoder geocoder
 */
- (void)fetchAddressInfoWithLocation:(CLLocation*)location geocoder:(CLGeocoder*)geocoder
{
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       CLPlacemark* placemark = [placemarks lastObject];
                       if (placemark) {
                           NSDictionary* addressDictionary = placemark.addressDictionary;

                           self.currentLocationAddress = [addressDictionary objectForKey:@"Name"];

                           self.currentLocation = location;

                           if (!self.currentLocationAddress) {
                               [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
                               return;
                           }

                           NSLog(@"定位的地址是：%@", self.currentLocationAddress);

                           self.locationResult = LocationManagerLocationResultSuccess;
                           self.shouldNotifyOtherObjects = NO;

                           [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidSuccessedLocateNotification object:self userInfo:nil];
                       }
                   }];
}

#pragma mark - 自定义私有实例方法

/**
 *  定位是否可用
 *
 *  @return YES 可用  NO 不可用
 */
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = LocationManagerLocationServiceStatusOK;
        return YES;
    }
    else {
        self.locationStatus = LocationManagerLocationServiceStatusUnknownError;
        return NO;
    }
}

/**
 *  得到当前的定位状态
 *
 *  @return 状态
 */
- (LocationManagerLocationServiceStatus)locationServiceStatus
{
    self.locationStatus = LocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            self.locationStatus = LocationManagerLocationServiceStatusNotDetermined;
            break;
#ifdef __IPHONE_8_0
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            self.locationStatus = LocationManagerLocationServiceStatusOK;
            break;
#else
        case kCLAuthorizationStatusAuthorized:
            self.locationStatus = LocationManagerLocationServiceStatusOK;
            break;
#endif
        case kCLAuthorizationStatusDenied:
            self.locationStatus = LocationManagerLocationServiceStatusNoAuthorization;
            break;
        default:
            if (![self isReachable]) {
                self.locationStatus = LocationManagerLocationServiceStatusNoNetwork;
            }
            break;
        }
    }
    else {
        self.locationStatus = LocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

/**
 *  设置错误信息
 *
 *  @param result <#result description#>
 *  @param status <#status description#>
 */
- (void)failedLocationWithResultType:(LocationManagerLocationResult)result statusType:(LocationManagerLocationServiceStatus)status
{
    self.locationResult = result;
    self.locationStatus = status;
    [self locationManager:self.locationManager didFailWithError:nil];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray*)locations
{
    //一开始启动的时候会跑到这里4次。所以如果以后的坐标都不变的话，后面的逻辑也就没有必要跑了
    if (manager.location.coordinate.latitude == self.currentLocation.coordinate.latitude && manager.location.coordinate.longitude == self.currentLocation.coordinate.longitude) {
        return;
    }

    [self fetchAddressInfoWithLocation:manager.location geocoder:self.geoCoder];
}

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    if (!self.shouldNotifyOtherObjects) {
        return;
    }
    if (self.locationStatus == LocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    if (self.locationStatus == LocationManagerLocationResultLocating) {
        return;
    }
    NSLog(@"定位失败");
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationManagerDidFailedLocateNotification object:nil userInfo:nil];
}

- (void)locationManager:(CLLocationManager*)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
#ifdef __IPHONE_8_0
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        self.locationStatus = LocationManagerLocationServiceStatusOK;
        [self restartLocation];
    }
#else
    if (status == kCLAuthorizationStatusAuthorized) {
        self.locationStatus = LocationManagerLocationServiceStatusOK;
        [self restartLocation];
    }
#endif
    else {
        if (self.locationStatus != LocationManagerLocationServiceStatusNotDetermined) {
            [self failedLocationWithResultType:LocationManagerLocationResultDefault statusType:LocationManagerLocationServiceStatusNoAuthorization];
        }
    }
}

@end
