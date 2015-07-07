//
//  User.h
//  POICollect
//  登录用户的实体类
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface User : NSObject

#pragma mark - 属性

/**
 *  登录名
 */
@property (nonatomic, copy) NSString* loginName;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString* userName;

/**
 *  用户ID
 */
@property (nonatomic, strong) NSNumber* userId;

/**
 *  创建时间
 */
@property (nonatomic, copy) NSString* createDate;

/**
 *  token
 */
@property (nonatomic, copy) NSString* toKen;

#pragma mark - 类方法

+ (User*)userFromJson:(NSDictionary*)userDic;

@end
