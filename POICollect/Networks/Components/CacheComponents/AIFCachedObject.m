//
//  AIFCachedObject.m
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFCachedObject.h"
#import "AIFNetworkingConfiguration.h"

@interface AIFCachedObject ()

@property (nonatomic, copy, readwrite) NSData* content;

@property (nonatomic, copy, readwrite) NSDate* lastUpdateTime;

@end

@implementation AIFCachedObject

#pragma mark - Getter

- (BOOL)isEmpty
{
    return self.content == nil;
}

- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kAIFCacheOutdateTimeSeconds;
}

#pragma mark - Setter

- (void)setContent:(NSData*)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

#pragma mark - 生命周期

- (instancetype)initWithContent:(NSData*)content
{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - 公共方法

- (void)updateContent:(NSData*)content
{
    self.content = content;
}

@end
