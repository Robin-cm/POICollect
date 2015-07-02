//
//  AIFCommonParamsGenerator.h
//  POICollect
//  公共参数生成器
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface AIFCommonParamsGenerator : NSObject

/**
 *  得到公共参数
 *
 *  @return 返回参数的字典
 */
+ (NSDictionary*)commonParamsDictionary;

/**
 *  得到log的公共参数
 *
 *  @return 返回参数的字典
 */
+ (NSDictionary*)commonParamsDictionaryForLog;

@end
