//
//  AIFService.h
//  POICollect
//  所有的service的基类
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@protocol AIFServiceProtocol <NSObject>

/**
 *  是否正式上线
 */
@property (nonatomic, readonly) BOOL isOnline;

/**
 *  测试环境的基本地址
 */
@property (nonatomic, strong, readonly) NSString* offlineApiBaseURL;

/**
 *  正式环境的基本地址
 */
@property (nonatomic, strong, readonly) NSString* onlineApiBaseURL;

@end

@interface AIFService : NSObject

/**
 *  基本路径
 */
@property (nonatomic, strong, readonly) NSString* apiBaseURL;

/**
 *  子类
 */
@property (nonatomic, weak) id<AIFServiceProtocol> child;

@end
