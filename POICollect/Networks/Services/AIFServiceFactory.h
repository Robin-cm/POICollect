//
//  AIFServiceFactory.h
//  POICollect
//  Service的工厂类
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFService.h"

@interface AIFServiceFactory : NSObject

#pragma mark - 方法

+ (instancetype)sharedInstance;

/**
 *  得到标识对应的Service
 *
 *  @param identifier 标识
 *
 *  @return 返回对应的Service
 */
- (AIFService<AIFServiceProtocol>*)serviceWithIdentifier:(NSString*)identifier;

@end
