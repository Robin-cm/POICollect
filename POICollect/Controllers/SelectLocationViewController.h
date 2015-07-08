//
//  SelectLocationViewController.h
//  POICollect
//  选点的页面
//  Created by 常敏 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "BaseViewController.h"
#import "TMapView.h"
#import <CoreLocation/CoreLocation.h>

static NSString* const selectedLocation = @"selectedLocation";

static NSString* const selectedLocationAddress = @"selectedLocationAddress";

static NSString* const kDefaultSelectedNotifacitionidentifier = @"kDefaultSelectedNotifacitionidentifier";

@class SelectLocationViewController;

@protocol SelectLocationViewControllerProtocal <NSObject>

- (void)selectVC:(SelectLocationViewController*)selectVC didSelectLocation:(CLLocation*)location;

@end

@interface SelectLocationViewController : BaseViewController <TMapViewDelegate>

@property (nonatomic, weak) id<SelectLocationViewControllerProtocal> delegate;

@property (nonatomic, strong, readonly) CLLocation* currentCenterLocation;

@end
