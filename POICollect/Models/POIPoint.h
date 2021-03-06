//
//  POIPoint.h
//  POICollect
//  POI点的实体类
//  Created by 敏梵 on 15/7/4.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class CLLocation;

@interface POIPoint : NSObject

#pragma mark - 属性

@property (nonatomic, copy) NSString* poiId;

@property (nonatomic, copy) NSString* poiName;

@property (nonatomic, copy) NSString* poiAddress;

@property (nonatomic, strong) NSArray* images;

@property (nonatomic, assign) BOOL poiSelected;

@property (nonatomic, assign) BOOL isUploaded;

/**
 *  POI点的纬度
 */
@property (nonatomic, retain) NSNumber* poiLat;

/**
 *  POI点的经度
 */
@property (nonatomic, retain) NSNumber* poiLon;

/**
 *  POI点的分类
 */
@property (nonatomic, strong) NSNumber* poiCategory;

///**
// *  数据对应的当前的视图
// */
//@property (nonatomic, assign) MainListTableViewCell* currentCell;

/**
 *  得到所有的图片的地址拼接的字符串
 *
 *  @return 字符串
 */
- (NSString*)getImagesString;

+ (NSArray*)getImagesByString:(NSString*)str;

- (CLLocation*)getLocation;

/**
 *  删除所有的图片
 */
- (void)cleanAllImages;

@end
