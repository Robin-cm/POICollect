//
//  CMDropdownButtonTableViewCell.m
//  POICollect
//
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMDropdownButtonTableViewCell.h"
#import "UIView+CMExpened.h"

#import "CMDropdownButtonArrowView.h"

static const CGFloat sDefaultLeftPadding = 50;

@interface CMDropdownButtonTableViewCell ()

@property (nonatomic, strong) UIImageView* selectedImageView;

@end

@implementation CMDropdownButtonTableViewCell

- (instancetype)init
{
    self = [super init];
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

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialization
{
    //    UIView* bgView = [[UIView alloc] init];
    //    bgView.backgroundColor = [UIColor colorWithHexString:@"0xCFDFE9"];
    //    self.backgroundView = bgView;
    //
    //    UIView* selBgView = [[UIView alloc] init];
    //    selBgView.backgroundColor = [[UIColor colorWithHexString:@"0xCFDFE9"] darkenedColorWithBrightnessFloat:0.8];
    //    self.selectedBackgroundView = selBgView;

    //    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    view.backgroundColor = [UIColor whiteColor];
    //    [self.contentView addSubview:view];

    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[CMDropdownButtonArrowView getRightImageWithFrame:CGRectMake(0, 0, 20, 20) andWithBgcolor:kAppThemeThirdColor]];
        _selectedImageView.hidden = YES;
        [self.contentView addSubview:_selectedImageView];
    }

    self.backgroundColor = [UIColor colorWithHexString:@"0xCFDFE9"];
    self.accessoryType = UITableViewCellAccessoryNone;

    self.textLabel.textColor = kAppThemePrimaryColor;
    self.textLabel.backgroundColor = [UIColor clearColor];

    //    self.textLabel.layer.borderColor = [UIColor blackColor].CGColor;
    //    self.textLabel.layer.borderWidth = 1;
    self.textLabel.font = [UIFont systemFontOfSize:14];

    self.frame = CGRectMake(0, 0, kScreenWidth, sDefaultCell_Height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_selectedImageView) {
        _selectedImageView.frame = CGRectMake((sDefaultLeftPadding - 20) / 2.0, (sDefaultCell_Height - 20) / 2.0, 20, 20);
    }
    self.textLabel.frame = CGRectMake(sDefaultLeftPadding, 0, kScreenWidth - sDefaultLeftPadding * 2, sDefaultCell_Height);
}

- (void)setCellSelected:(BOOL)selected
{
    if (selected) {
        _selectedImageView.hidden = NO;
    }
    else {
        _selectedImageView.hidden = YES;
    }
}

@end
