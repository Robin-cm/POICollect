//
//  AIFCache.h
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface AIFCache : NSObject

#pragma mark - 类方法

+ (instancetype)sharedInstance;

#pragma mark - 实例方法

- (NSString*)keyWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams;

- (NSData*)fetchCachedDataWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams;

- (void)saveCacheWithData:(NSData*)cacheData serviceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams;

- (void)deleteCacheWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams;

- (NSData*)fetchCachedDataWithKey:(NSString*)key;

- (void)saveCacheWithData:(NSData*)cacheData key:(NSString*)key;

- (void)deleteCacheWithKey:(NSString*)key;

- (void)clean;

@end
