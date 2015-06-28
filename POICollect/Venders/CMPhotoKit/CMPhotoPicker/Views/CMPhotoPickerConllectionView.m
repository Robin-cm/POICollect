//
//  CMPhotoPickerConllectionView.m
//  POICollect
//
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerConllectionView.h"
#import "CMPhotoPickerFooterCollectionReusableView.h"
#import "CMPhotoPickerCollectionViewCell.h"
#import "CMPhotoPickerImageView.h"

#define MAX_COUNT 9 // 选择图片最大数默认是9

@interface CMPhotoPickerConllectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) CMPhotoPickerFooterCollectionReusableView* footerView;

@property (nonatomic, assign, getter=isFirstLoading) BOOL firstLoading;

@end

@implementation CMPhotoPickerConllectionView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout*)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self configView];
        [self configData];
    }
    return self;
}

#pragma mark - 自定义方法

- (void)configView
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)configData
{
    self.dataSource = self;
    self.delegate = self;
    _selectAsstes = [NSMutableArray array];
}

#pragma mark - Setter

- (void)setDataArray:(NSArray*)dataArray
{
    _dataArray = dataArray;
    if (self.isRecoderSelectPicker) {
        NSMutableArray* selectAsstes = [NSMutableArray array];
        for (CMPhotoAssets* assetSel in self.selectAsstes) {
            for (CMPhotoAssets* asset in self.dataArray) {
                if ([assetSel.asset.defaultRepresentation.url isEqual:asset.asset.defaultRepresentation.url]) {
                    [selectAsstes addObject:asset];
                }
            }
        }
        _selectAsstes = selectAsstes;
    }
    [self reloadData];
}

#pragma mark - Getter

- (NSMutableArray*)selectsIndexPath
{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    return _selectsIndexPath;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CMPhotoPickerCollectionViewCell* cell = [CMPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];

    CMPhotoPickerImageView* cellImageView = [[CMPhotoPickerImageView alloc] initWithFrame:cell.bounds];
    cellImageView.maskViewFlag = YES;

    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker) {
        for (CMPhotoAssets* asset in self.selectAsstes) {
            if ([asset.asset.defaultRepresentation.url isEqual:[self.dataArray[indexPath.item] asset].defaultRepresentation.url]) {
                [self.selectsIndexPath addObject:@(indexPath.row)];
            }
        }
    }

    [cell.contentView addSubview:cellImageView];

    cellImageView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);

    CMPhotoAssets* asset = self.dataArray[indexPath.item];
    cellImageView.isVideoType = asset.isVideoType;
    if ([asset isKindOfClass:[CMPhotoAssets class]]) {
        cellImageView.image = asset.thumbImage;
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
    CMPhotoPickerFooterCollectionReusableView* reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        CMPhotoPickerFooterCollectionReusableView* footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
        self.footerView = footerView;
    }
    else {
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (!self.lastDataArray) {
        self.lastDataArray = [NSMutableArray array];
    }

    CMPhotoPickerCollectionViewCell* cell = (CMPhotoPickerCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];

    CMPhotoAssets* asset = self.dataArray[indexPath.row];
    CMPhotoPickerImageView* pickerImageView = [cell.contentView.subviews lastObject];
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag) {
        [self.selectsIndexPath removeObject:@(indexPath.row)];
        [self.selectAsstes removeObject:asset];
        [self.lastDataArray removeObject:asset];
    }
    else {
        // 1 判断图片数超过最大数或者小于0
        NSUInteger minCount = (self.minCount > MAX_COUNT || self.minCount < 0) ? MAX_COUNT : self.minCount;

        if (self.selectAsstes.count >= minCount) {
            NSString* format = [NSString stringWithFormat:@"最多只能选择%zd张图片", minCount];
            if (minCount == 0) {
                format = [NSString stringWithFormat:@"您已经选满了图片呦."];
            }
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertView show];
            return;
        }

        [self.selectsIndexPath addObject:@(indexPath.row)];
        [self.selectAsstes addObject:asset];
        [self.lastDataArray addObject:asset];
    }
    // 告诉代理现在被点击了!
    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected:deleteAsset:)]) {
        if (pickerImageView.isMaskViewFlag) {
            // 删除的情况下
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
        }
        else {
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
        }
    }

    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[CMPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
