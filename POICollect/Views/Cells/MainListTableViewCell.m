//
//  MainListTableViewCell.m
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "MainListTableViewCell.h"
#import "NSString+Expanded.h"

static const CGFloat sDefaultPadding = 10;

@interface MainListTableViewCell ()

@property (nonatomic, strong) UILabel* poiNameLabel;

@property (nonatomic, strong) UILabel* poiAddressLabel;

@property (nonatomic, copy) NSString* mainTitle;

@property (nonatomic, copy) NSString* subTitle;

@end

@implementation MainListTableViewCell

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialization];
    }
    return self;
}

#pragma 生命周期

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    __weak typeof(self) weakSelf = self;
    if (_poiNameLabel) {
        [_poiNameLabel makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.left).offset(sDefaultPadding);
            make.top.equalTo(weakSelf.top).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.right).offset(-sDefaultPadding);
            make.width.lessThanOrEqualTo(weakSelf.width);
            make.height.equalTo(@20);
        }];
    }

    if (_poiAddressLabel) {
        [_poiAddressLabel makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.left).offset(sDefaultPadding);
            make.top.equalTo(_poiNameLabel.bottom).offset(ceil(sDefaultPadding / 4.0));
            make.right.equalTo(weakSelf.right).offset(-sDefaultPadding);
            make.width.lessThanOrEqualTo(weakSelf.width);
            make.height.equalTo([weakSelf.subTitle getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - sDefaultPadding * 2, CGFLOAT_MAX)]);
        }];
    }
}

#pragma mark - 自定义私有方法

- (void)initialization
{
    self.accessoryType = UITableViewCellAccessoryNone;

    if (!_poiNameLabel) {
        _poiNameLabel = [[UILabel alloc] init];
        _poiNameLabel.layer.borderWidth = 1;
        _poiNameLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _poiNameLabel.textColor = [UIColor lightGrayColor];
        _poiNameLabel.font = [UIFont systemFontOfSize:14];
        _poiNameLabel.numberOfLines = 1;
        _poiNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_poiNameLabel];
    }

    if (!_poiAddressLabel) {
        _poiAddressLabel = [[UILabel alloc] init];
        _poiAddressLabel.textColor = [UIColor lightGrayColor];
        _poiAddressLabel.numberOfLines = 10;
        _poiAddressLabel.layer.borderWidth = 1;
        _poiAddressLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _poiAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _poiAddressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_poiAddressLabel];
    }
}

#pragma mark - 自定义公共方法

- (void)setTitle:(NSString*)title andSubTitle:(NSString*)subTitle
{
    _mainTitle = title;
    _subTitle = subTitle;
    _poiNameLabel.text = _mainTitle;
    _poiAddressLabel.text = _subTitle;
}

#pragma mark - 类方法

+ (CGFloat)getSubtitleHeightWithTitle:(NSString*)subTitle
{
    return -1;
}

+ (CGFloat)getCellHeightWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle
{
    return sDefaultPadding * 2 + ceilf(sDefaultPadding / 4) + 20 + [subTitle getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - sDefaultPadding * 2, CGFLOAT_MAX)];
}

@end
