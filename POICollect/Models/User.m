//
//  User.m
//  POICollect
//  登录用户的实体类
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "User.h"
#import "NSObject+ObjectMap.h"

@implementation User

#pragma mark - 类方法

+ (User*)userFromJson:(NSDictionary*)userDic
{
    return [NSObject objectOfClass:@"User" fromJSON:userDic];
}

@end
