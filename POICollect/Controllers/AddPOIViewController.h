//
//  AddPOIViewController.h
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "BaseViewController.h"
#import "POIPoint.h"

@class AddPOIViewController;

@protocol AddPOIViewControllerProtocol <NSObject>

- (void)addPoiViewControllerDidSavedPOI:(AddPOIViewController*)addPoiViewController;

@end

@interface AddPOIViewController : BaseViewController

#pragma mark - 属性

@property (nonatomic, strong) POIPoint* currentPoipoint;

@property (nonatomic, weak) id<AddPOIViewControllerProtocol> delegate;

@end
