//
//  PickerGroupTableViewCell.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-13.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "CMPhotoPickerGroupTableViewCell.h"
#import "CMPhotoPickerGroup.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CMPhotoPickerGroupTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView* groupImageView;
@property (weak, nonatomic) IBOutlet UILabel* groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* groupPicCountLabel;

@end

@implementation CMPhotoPickerGroupTableViewCell

- (void)setGroup:(CMPhotoPickerGroup*)group
{
    _group = group;

    self.groupNameLabel.text = group.groupName;
    self.groupImageView.image = group.thumbImage;
    self.groupPicCountLabel.text = [NSString stringWithFormat:@"(%ld)", group.assetsCount];
}

+ (instancetype)instanceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

@end
