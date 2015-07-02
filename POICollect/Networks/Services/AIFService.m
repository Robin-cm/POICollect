//
//  AIFService.m
//  POICollect
//  所有的service的基类
//  Created by 常敏 on 15/7/2.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFService.h"

@implementation AIFService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(AIFServiceProtocol)]) {
            self.child = (id<AIFServiceProtocol>)self;
        }
    }
    return self;
}

#pragma mark - Getter

- (NSString*)apiBaseURL
{
    return self.child.isOnline ? self.child.onlineApiBaseURL : self.child.offlineApiBaseURL;
}

@end
