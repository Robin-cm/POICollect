//
//  User.h
//  POICollect
//  登录用户的实体类
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface User : NSObject

#pragma mark - 类方法

+ (User*)userFromJson:(NSDictionary*)userDic;

@end
