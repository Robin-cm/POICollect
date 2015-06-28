//
//  CMPhotoPickerFooterCollectionReusableView.m
//  POICollect
//  collectionView的footer
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerFooterCollectionReusableView.h"

@interface CMPhotoPickerFooterCollectionReusableView ()

@property (nonatomic, strong) UILabel* countLabel;

@end

@implementation CMPhotoPickerFooterCollectionReusableView

#pragma mark - Getter

- (UILabel*)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.frame = self.bounds;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}

#pragma mark - Setter

- (void)setCount:(NSUInteger)count
{
    _count = count;
    if (_count > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"有%ld张图片", (unsigned long)_count];
    }
}

@end
