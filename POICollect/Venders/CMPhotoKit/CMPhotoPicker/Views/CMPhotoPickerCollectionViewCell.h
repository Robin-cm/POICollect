//
//  CMPhotoPickerCollectionViewCell.h
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const _cellIdentifier = @"cell";

@interface CMPhotoPickerCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, strong) UIImage* cellImage;

@end
