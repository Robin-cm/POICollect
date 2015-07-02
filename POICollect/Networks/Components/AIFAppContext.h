//
//  AIFAppContext.h
//  POICollect
//
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface AIFAppContext : NSObject

#pragma mark - 属性

@property (nonatomic, copy) NSString* appName;

/**
 *  设备名称
 */
@property (nonatomic, copy, readonly) NSString* mName;

/**
 *  系统的名称
 */
@property (nonatomic, copy, readonly) NSString* osName;

/**
 *  系统版本
 */
@property (nonatomic, copy, readonly) NSString* osVersion;

/**
 *  bundle版本
 */
@property (nonatomic, copy, readonly) NSString* bundleVersion;

/**
 *  请求来源，都是“mobile”
 */
@property (nonatomic, copy, readonly) NSString* from;

/**
 *  系统的类型
 */
@property (nonatomic, copy, readonly) NSString* osType;

/**
 *  发送请求的时间
 */
@property (nonatomic, copy, readonly) NSString* qTime;

/**
 *  macid Mac地址
 */
@property (nonatomic, copy, readonly) NSString* macid;

/**
 *  当前的时间
 */
@property (nonatomic, copy, readonly) NSString* ct;

/**
 *  uuid
 */
//@property (nonatomic, copy, readonly) NSString* uuid;

/**
 *  udid2
 */
//@property (nonatomic, copy, readonly) NSString* udid2;

/**
 *  uuid2
 */
//@property (nonatomic, copy, readonly) NSString* uuid2;

/**
 *  网络是否接通
 */
@property (nonatomic, readonly) BOOL isReachable;

/**
 *  ip地址
 */
@property (nonatomic, copy, readonly) NSString* ip;

/**
 *  网络状态 
 */
@property (nonatomic, copy, readonly) NSString* net;

/**
 *  手机的型号
 */
@property (nonatomic, copy, readonly) NSString* pModel;

#pragma mark - 方法

+ (instancetype)sharedInstance;

@end
