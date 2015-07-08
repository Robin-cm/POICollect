//
//  SelectLocationModelViewController.h
//  POICollect
//
//  Created by 常敏 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class SelectLocationModelViewController;
@class CLLocation;

@protocol SelectLocationModelViewControllerProtocol <NSObject>

- (void)selectVC:(SelectLocationModelViewController*)selectVC didSelectLocation:(NSDictionary*)locationIf;

@end

@interface SelectLocationModelViewController : UIViewController

@property (nonatomic, weak) id<SelectLocationModelViewControllerProtocol> delegate;

@property (nonatomic, strong) CLLocation* currentLocation;

@end
