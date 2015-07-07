//
//  RegistUser.h
//  POICollect
//
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistUser : NSObject

@property (nonatomic, copy) NSString* registName;

@property (nonatomic, copy) NSString* registPass;

@property (nonatomic, copy) NSString* registConformPass;

- (NSString*)validateForm;

@end
