//
//  CMPhotoPickerConllectionView.h
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPhotoAssets.h"

@class CMPhotoPickerConllectionView;

// 展示状态
typedef NS_ENUM(NSUInteger, CMPickerCollectionViewShowOrderStatus) {
    CMPickerCollectionViewShowOrderStatusTimeDesc = 0, // 升序
    CMPickerCollectionViewShowOrderStatusTimeAsc // 降序
};

@protocol CMPhotoPickerCollectionViewDelegate <NSObject>
// 选择相片就会调用
- (void)pickerCollectionViewDidSelected:(CMPhotoPickerConllectionView*)pickerCollectionView deleteAsset:(CMPhotoAssets*)deleteAssets;
@end

@interface CMPhotoPickerConllectionView : UICollectionView

@property (nonatomic, assign) CMPickerCollectionViewShowOrderStatus status;

// 保存所有的数据
@property (nonatomic, strong) NSArray* dataArray;
// 保存选中的图片
@property (nonatomic, strong) NSMutableArray* selectAsstes;
// 最后保存的一次图片
@property (strong, nonatomic) NSMutableArray* lastDataArray;
// delegate
@property (nonatomic, weak) id<CMPhotoPickerCollectionViewDelegate> collectionViewDelegate;
// 限制最大数
@property (nonatomic, assign) NSInteger minCount;

// 选中的索引值，为了防止重用
@property (nonatomic, strong) NSMutableArray* selectsIndexPath;
// 记录选中的值
@property (assign, nonatomic) BOOL isRecoderSelectPicker;

@end
