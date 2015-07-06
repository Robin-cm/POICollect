//
//  POIObj.h
//  POICollect
//
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface POIObj : NSManagedObject

@property (nonatomic, retain) NSString * poiName;
@property (nonatomic, retain) NSString * poiAddress;
@property (nonatomic, retain) NSNumber * isUploaded;
@property (nonatomic, retain) NSNumber * poiLat;
@property (nonatomic, retain) NSNumber * poiLon;
@property (nonatomic, retain) NSNumber * poiCategory;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSString * poiImages;
@property (nonatomic, retain) NSNumber * poiId;

@end
