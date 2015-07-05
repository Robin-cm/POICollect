//
//  POIPoint.h
//  POICollect
//  POI点的实体类
//  Created by 敏梵 on 15/7/4.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@interface POIPoint : NSObject

#pragma mark - 属性

@property (nonatomic, copy) NSString* poiName;

@property (nonatomic, copy) NSString* poiAddress;

@property (nonatomic, strong) NSArray* images;

@property (nonatomic, assign) BOOL poiSelected;

@end
