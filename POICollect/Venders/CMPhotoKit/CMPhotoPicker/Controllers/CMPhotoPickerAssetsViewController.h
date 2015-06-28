//
//  CMPhotoPickerAssetsViewController.h
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPhotoPickerGroup.h"

#import "CMPhotoGroupPickerViewController.h"

@interface CMPhotoPickerAssetsViewController : UIViewController

@property (strong, nonatomic) CMPhotoGroupPickerViewController* groupVc;
//@property (nonatomic, assign) PickerViewShowStatus status;
@property (nonatomic, strong) CMPhotoPickerGroup* assetsGroup;
@property (nonatomic, assign) NSInteger minCount;
// 需要记录选中的值的数据
@property (strong, nonatomic) NSArray* selectPickerAssets;

@end
