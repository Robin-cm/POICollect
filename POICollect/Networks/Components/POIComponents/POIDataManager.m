//
//  POIDataManager.m
//  POICollect
//  POI点管理类
//  Created by 常敏 on 15/7/6.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIDataManager.h"
#import "AppDelegate.h"
#import "POIPoint.h"
#import "POIObj.h"

static NSString* const poiTableName = @"POIObj";

@interface POIDataManager ()

@property (nonatomic, strong) AppDelegate* appDelegate;

@end

@implementation POIDataManager

#pragma Getter

- (AppDelegate*)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

#pragma mark - 类方法

+ (instancetype)sharedManager
{
    static POIDataManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[POIDataManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 实例方法

- (void)insertNewPOI:(POIPoint*)poi
{
    if (!poi) {
        return;
    }
    NSManagedObjectContext* context = self.appDelegate.managedObjectContext;
    POIObj* newPOI = [NSEntityDescription insertNewObjectForEntityForName:@"POIObj" inManagedObjectContext:context];
    newPOI.poiName = poi.poiName;
    newPOI.poiId = poi.poiId;
    newPOI.poiAddress = poi.poiAddress;
    newPOI.poiLon = poi.poiLon;
    newPOI.poiLat = poi.poiLat;
    newPOI.poiImages = [poi getImagesString];
    newPOI.poiCategory = poi.poiCategory;
    newPOI.isUploaded = [NSNumber numberWithBool:NO];
    newPOI.isSelected = [NSNumber numberWithBool:NO];

    NSError* error;
    if (![context save:&error]) {
        NSLog(@"保存没有成功！%@", error.localizedDescription);
    }
}

- (NSMutableArray*)queryAllPOIIsUploaded:(BOOL)isUploaded
{
    NSManagedObjectContext* context = self.appDelegate.managedObjectContext;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isUploaded = %@", [NSNumber numberWithBool:isUploaded]];
    [fetchRequest setPredicate:predicate];

    NSEntityDescription* entity = [NSEntityDescription entityForName:@"POIObj" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray* fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray* resultArray = [NSMutableArray array];

    for (POIObj* poi in fetchObjects) {
        POIPoint* point = [[POIPoint alloc] init];
        point.poiName = poi.poiName;
        point.poiAddress = poi.poiAddress;
        point.poiCategory = poi.poiCategory;
        point.poiLat = poi.poiLat;
        point.poiLon = poi.poiLon;
        point.images = [POIPoint getImagesByString:poi.poiImages];
        point.poiId = poi.poiId;
        point.isUploaded = poi.isUploaded.boolValue;
        [resultArray addObject:point];
    }

    return [resultArray mutableCopy];
}

- (void)updateByNewPOI:(POIPoint*)poi
{
    NSManagedObjectContext* context = self.appDelegate.managedObjectContext;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"poiId==%@", poi.poiId];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:poiTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];

    NSError* error = nil;
    NSArray* result = [context executeFetchRequest:request error:&error];
    for (POIObj* poiObj in result) {
        poiObj.poiName = poi.poiName;
        poiObj.poiId = poi.poiId;
        poiObj.poiAddress = poi.poiAddress;
        poiObj.poiLon = poi.poiLon;
        poiObj.poiLat = poi.poiLat;
        poiObj.poiImages = [poi getImagesString];
        poiObj.poiCategory = poi.poiCategory;
        poiObj.isUploaded = [NSNumber numberWithBool:poi.isUploaded];
    }

    if ([context save:&error]) {
        NSLog(@"更新成功");
    }
    else {
        NSLog(@"更新失败");
    }
}

- (void)deleteByPOI:(POIPoint*)poi
{
    NSManagedObjectContext* context = self.appDelegate.managedObjectContext;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"poiId==%@", poi.poiId];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:poiTableName inManagedObjectContext:context]];
    [request setPredicate:predicate];

    NSError* error = nil;
    NSArray* result = [context executeFetchRequest:request error:&error];

    if (!error && result && result.count) {
        for (NSManagedObject* obj in result) {
            [context deleteObject:obj];
        }

        if ([context save:&error]) {
            NSLog(@"更新成功");
        }
        else {
            NSLog(@"更新失败");
        }
    }
}

@end
