//
//  AIFCommonParamsGenerator.m
//  POICollect
//  公共参数生成器
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFCommonParamsGenerator.h"
#import "AIFAppContext.h"

@implementation AIFCommonParamsGenerator

/**
 *  得到公共参数
 *
 *  @return 返回参数的字典
 */
+ (NSDictionary*)commonParamsDictionary
{
    AIFAppContext* context = [AIFAppContext sharedInstance];
    return @{
        @"ostype" : context.osType,
        @"app" : context.appName,
        @"bversion" : context.bundleVersion,
        @"from" : context.from,
        @"m" : context.mName,
        //        @"macid" : context.macid,
        @"o" : context.osName,
        @"qtime" : context.qTime,
        @"ov" : context.osVersion
    };
}

/**
 *  得到log的公共参数
 *
 *  @return 返回参数的字典
 */
+ (NSDictionary*)commonParamsDictionaryForLog
{
    AIFAppContext* context = [AIFAppContext sharedInstance];
    return @{
        @"ostype" : context.osType,
        @"app" : context.appName,
        @"bversion" : context.bundleVersion,
        @"from" : context.from,
        @"m" : context.mName,
        @"macid" : context.macid,
        @"o" : context.osName,
        @"qtime" : context.qTime,
        @"ov" : context.osVersion
    };
}

@end
