//
//  CMPhotoPickerViewController.h
//  POICollect
//
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

// 回调
typedef void (^callBackBlock)(id obj);

@protocol CMPhotoPickerViewControllerDelegate <NSObject>
/**
 *  返回所有的Asstes对象
 */
- (void)pickerViewControllerDoneAsstes:(NSArray*)assets;
@end

@interface CMPhotoPickerViewController : UIViewController

// @optional
@property (nonatomic, weak) id<CMPhotoPickerViewControllerDelegate> delegate;
// 决定你是否需要push到内容控制器, 默认显示组
//@property (nonatomic, assign) PickerViewShowStatus status;
// 可以用代理来返回值或者用block来返回值
@property (nonatomic, copy) callBackBlock callBack;

// 每次选择图片的最小数, 默认与最大数是9
@property (nonatomic, assign) NSInteger minCount;
// 记录选中的值
@property (strong, nonatomic) NSArray* selectPickers;

#pragma mark - 公共实例方法

- (void)show;

@end
