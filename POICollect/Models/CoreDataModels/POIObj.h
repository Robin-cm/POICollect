//
//  POIObj.h
//  POICollect
//
//  Created by 敏梵 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface POIObj : NSManagedObject

@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSNumber * isUploaded;
@property (nonatomic, retain) NSString * poiAddress;
@property (nonatomic, retain) NSNumber * poiCategory;
@property (nonatomic, retain) NSString * poiId;
@property (nonatomic, retain) NSString * poiImages;
@property (nonatomic, retain) NSNumber * poiLat;
@property (nonatomic, retain) NSNumber * poiLon;
@property (nonatomic, retain) NSString * poiName;

@end
