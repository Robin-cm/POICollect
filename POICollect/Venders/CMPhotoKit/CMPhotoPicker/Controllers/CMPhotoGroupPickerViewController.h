//
//  CMPhotoGroupPickerViewController.h
//  POICollect
//
//  Created by 敏梵 on 15/6/26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPhotoPickerViewController.h"

@interface CMPhotoGroupPickerViewController : UIViewController

@property (nonatomic, weak) id<CMPhotoPickerViewControllerDelegate> delegate;
//@property (nonatomic, assign) PickerViewShowStatus status;
@property (nonatomic, assign) NSInteger minCount;
// 记录选中的值
@property (strong, nonatomic) NSArray* selectAsstes;

@end
