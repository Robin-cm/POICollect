//
//  POIDataManager.h
//  POICollect
//  POI点管理类
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIObj.h"
@class POIPoint;

@interface POIDataManager : NSObject

#pragma mark - 类方法

+ (instancetype)sharedManager;

#pragma mark - 实例方法

- (void)insertNewPOI:(POIPoint*)poi;

- (NSMutableArray*)queryAllPOIIsUploaded:(BOOL)isUploaded;

- (void)updateByNewPOI:(POIPoint*)poi;

- (void)deleteByPOI:(POIPoint*)poi;

@end
