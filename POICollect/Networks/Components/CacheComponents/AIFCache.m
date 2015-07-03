//
//  AIFCache.m
//  POICollect
//
//  Created by 常敏 on 15/7/3.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AIFCache.h"
#import "NSDictionary+AXNetworkingMethods.h"
#import "AIFNetworkingConfiguration.h"
#import "AIFCachedObject.h"

@interface AIFCache ()

@property (nonatomic, strong) NSCache* cache;

@end

@implementation AIFCache

#pragma mark - 生命周期

+ (instancetype)sharedInstance
{
    static AIFCache* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIFCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - getter

- (NSCache*)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kAIFCacheCountLimit;
    }
    return _cache;
}

#pragma mark - 公共方法

- (NSString*)keyWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams
{
    return [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams AIF_urlParamsStringSignature:NO]];
}

- (NSData*)fetchCachedDataWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData*)cacheData serviceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams
{
    [self saveCacheWithData:cacheData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString*)serviceIdentifier methodName:(NSString*)methodName requestParams:(NSDictionary*)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData*)fetchCachedDataWithKey:(NSString*)key
{
    AIFCachedObject* cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    }
    else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData*)cacheData key:(NSString*)key
{
    AIFCachedObject* cachedObject = [self.cache objectForKey:key];
    if (!cachedObject) {
        cachedObject = [[AIFCachedObject alloc] init];
    }
    [cachedObject updateContent:cacheData];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString*)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

@end
