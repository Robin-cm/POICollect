//
//  CMPhotoPickerCollectionViewCell.m
//  POICollect
//  CELL
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerCollectionViewCell.h"

@implementation CMPhotoPickerCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{

    CMPhotoPickerCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];

    if ([[cell.contentView.subviews lastObject] isKindOfClass:[UIImageView class]]) {
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }

    return cell;
}

@end
