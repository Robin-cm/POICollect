//
//  POIPoint.m
//  POICollect
//  POI点的实体类
//  Created by 敏梵 on 15/7/4.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIPoint.h"
#import "CMPhoto.h"
#import <CoreLocation/CoreLocation.h>

@implementation POIPoint

/**
 *  得到所有的图片的地址拼接的字符串
 *
 *  @return 字符串
 */
- (NSString*)getImagesString
{
    NSMutableString* imgStr = [[NSMutableString alloc] init];
    if (self.images && self.images.count > 0) {
        for (CMPhoto* photo in self.images) {
            NSString* appendStr = [NSString stringWithFormat:@"%@;", photo.imageURLString];
            [imgStr appendString:appendStr];
        }
        //        [imgStr deleteCharactersInRange:NSMakeRange(imgStr.length - 2, imgStr.length - 1)];
        return [imgStr substringToIndex:(imgStr.length - 1)];
    }
    return @"";
}

+ (NSArray*)getImagesByString:(NSString*)str
{
    NSArray* urls = [str componentsSeparatedByString:@";"];
    NSMutableArray* results = [NSMutableArray array];
    if (urls && urls.count > 0) {
        for (NSString* url in urls) {
            CMPhoto* photo = [[CMPhoto alloc] init];
            photo.imageURLString = url;
            [results addObject:photo];
        }
    }
    return [results mutableCopy];
}

- (CLLocation*)getLocation
{
    return [[CLLocation alloc] initWithLatitude:self.poiLat.doubleValue longitude:self.poiLon.doubleValue];
}

- (void)cleanAllImages
{
    if (self.images && self.images.count > 0) {
        for (CMPhoto* photo in self.images) {
            [photo deleteImageFile];
        }
    }
}

@end
