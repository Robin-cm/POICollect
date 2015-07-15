//
//  MainListTableViewCell.m
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "MainListTableViewCell.h"
#import "NSString+Expanded.h"
#import "UIView+CMExpened.h"
#import "CMSimpleCheckBoxBtn.h"
#import "CMPhoto.h"

static const CGFloat sDefaultPadding = 10;

@interface MainListTableViewCell ()

@property (nonatomic, strong) UILabel* poiNameLabel;

@property (nonatomic, strong) UILabel* poiAddressLabel;

@property (nonatomic, copy) NSString* mainTitle;

@property (nonatomic, copy) NSString* subTitle;

@property (nonatomic, strong) UIButton* moreBtn;

@property (nonatomic, strong) UIView* whiteBg;

@property (nonatomic, strong) UIView* subContainerView;

@property (nonatomic, strong) UIProgressView* progressView;

@property (nonatomic, strong) CMSimpleCheckBoxBtn* selectBtn;

@property (nonatomic, strong) NSMutableArray* subContentConstraints;

@property (nonatomic, strong) UIImageView* firstImageView;

@property (nonatomic, strong) UIImageView* secondImageView;

@property (nonatomic, strong) UIImageView* thirdImageView;

@property (nonatomic, strong) NSArray* imageViewsArray;

@end

@implementation MainListTableViewCell

@synthesize mEdit = _mEdit;

@synthesize mSeledted = _mSeledted;

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

- (void)setPoiPoint:(POIPoint*)poiPoint
{
    _mainTitle = poiPoint.poiName;
    _subTitle = poiPoint.poiAddress;
    _poiNameLabel.text = _mainTitle;
    _poiAddressLabel.text = _subTitle;

    for (UIImageView* imageView in _imageViewsArray) {
        imageView.image = [UIImage imageNamed:@"main_bg"];
    }

    if (poiPoint.images && poiPoint.images.count > 0 && _imageViewsArray && _imageViewsArray.count > 0) {
        for (int i = 0; i < poiPoint.images.count; i++) {
            ((UIImageView*)[_imageViewsArray objectAtIndex:i]).image = ((CMPhoto*)[poiPoint.images objectAtIndex:i]).thumbImage;
        }
    }
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.whiteBg.backgroundColor = highlighted ? [[UIColor colorWithHexString:@"0xD0E0E8"] darkenedColorWithBrightnessFloat:0.95] : [UIColor colorWithHexString:@"0xD0E0E8"];
}

- (void)updateConstraints
{
    __weak typeof(self) weakSelf = self;
    if (_subContainerView) {
        [_subContainerView updateConstraints:^(MASConstraintMaker* make) {
            make.top.and.bottom.and.right.equalTo(weakSelf.whiteBg).offset(0);
            make.left.equalTo(weakSelf.whiteBg.left).offset(_mEdit ? @(30) : @(0));
        }];
    }
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)layoutView
{
    __weak typeof(self) weakSelf = self;

    //    self.selectBtn.hidden = _mEdit;

    if (_whiteBg) {
        [_whiteBg makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.contentView.top).offset(sDefaultPadding);
            make.bottom.equalTo(weakSelf.contentView.bottom).offset(-sDefaultPadding);
            make.left.equalTo(weakSelf.contentView.left).offset(sDefaultPadding * 2);
            make.right.equalTo(weakSelf.contentView.right).offset(-sDefaultPadding * 2);
        }];
    }

    if (_selectBtn) {
        [_selectBtn makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.whiteBg.top).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.whiteBg.left).offset(sDefaultPadding);
            make.width.equalTo(20);
        }];
    }

    if (_subContainerView) {
        [_subContainerView makeConstraints:^(MASConstraintMaker* make) {
            make.top.and.bottom.and.right.equalTo(weakSelf.whiteBg).offset(0);
            make.left.equalTo(weakSelf.whiteBg.left).offset(0);
            //            make.edges.equalTo(weakSelf.whiteBg);
        }];
    }

    if (_poiNameLabel) {
        [_poiNameLabel makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.subContainerView.left).offset(sDefaultPadding);
            make.top.equalTo(weakSelf.subContainerView.top).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.moreBtn.left).offset(-sDefaultPadding);
            make.height.equalTo(@20);
        }];
    }

    if (_moreBtn) {
        [_moreBtn makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.subContainerView.top).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.subContainerView.right).offset(-sDefaultPadding);
            make.left.equalTo(weakSelf.poiNameLabel.right).offset(sDefaultPadding);
            make.height.equalTo(@20);
            make.width.equalTo(@30);
        }];
    }

    if (_poiAddressLabel) {
        [_poiAddressLabel makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(weakSelf.subContainerView.left).offset(sDefaultPadding);
            make.top.equalTo(weakSelf.poiNameLabel.bottom).offset(ceil(sDefaultPadding / 4.0));
            make.right.equalTo(weakSelf.subContainerView.right).offset(-sDefaultPadding);
            make.width.lessThanOrEqualTo(weakSelf.subContainerView.width);
            //            make.height.equalTo([weakSelf.subTitle getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreenWidth - sDefaultPadding * 2, 30)]);

            make.height.equalTo(@(25));
        }];
    }

    if (_progressView) {
        [_progressView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.poiAddressLabel.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.subContainerView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.subContainerView.right).offset(-sDefaultPadding);
            make.height.equalTo(@1);
        }];
    }

    if (_firstImageView) {
        [_firstImageView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.progressView.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.subContainerView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.secondImageView.left).offset(-sDefaultPadding);
            make.width.and.height.equalTo(@(50));
        }];
    }

    if (_secondImageView) {
        [_secondImageView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.progressView.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.firstImageView.right).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.thirdImageView.left).offset(-sDefaultPadding);
            make.width.and.height.equalTo(@(50));

        }];
    }

    if (_thirdImageView) {
        [_thirdImageView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.progressView.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.secondImageView.right).offset(sDefaultPadding);

            make.width.and.height.equalTo(@(50));

        }];
    }
}

#pragma mark - 自定义私有方法

- (void)initialization
{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //    UIView* selectedView = [[UIView alloc] init];
    //    selectedView.backgroundColor = [UIColor clearColor];
    //    self.selectedBackgroundView = selectedView;

    if (!_whiteBg) {
        _whiteBg = [[UIView alloc] init];
        _whiteBg.backgroundColor = [UIColor colorWithHexString:@"0xD0E0E8"];
        [_whiteBg circleCornerWithRadius:7];
        [self.contentView addSubview:_whiteBg];
    }

    if (!_selectBtn) {
        _selectBtn = [[CMSimpleCheckBoxBtn alloc] initBoxButtonWithSize:CMSimpleCheckBoxBtnSize_Tint];
        _selectBtn.selected = NO;
        _selectBtn.hidden = YES;
        [_selectBtn addTarget:self action:@selector(selectBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_whiteBg addSubview:_selectBtn];
    }

    if (!_subContainerView) {
        _subContainerView = [[UIView alloc] init];
        _subContainerView.backgroundColor = [UIColor clearColor];
        [_whiteBg addSubview:_subContainerView];
    }

    if (!_poiNameLabel) {
        _poiNameLabel = [[UILabel alloc] init];
        //        _poiNameLabel.layer.borderWidth = 1;
        //        _poiNameLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _poiNameLabel.textColor = [UIColor colorWithHexString:@"0x0076AA"];
        _poiNameLabel.font = [UIFont systemFontOfSize:14];
        _poiNameLabel.numberOfLines = 1;
        _poiNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_subContainerView addSubview:_poiNameLabel];
    }

    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _moreBtn.layer.borderColor = [UIColor blackColor].CGColor;
        //        _moreBtn.layer.borderWidth = 1;
        [_moreBtn setTitle:@"···" forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [_subContainerView addSubview:_moreBtn];
    }

    if (!_poiAddressLabel) {
        _poiAddressLabel = [[UILabel alloc] init];
        _poiAddressLabel.textColor = [UIColor colorWithHexString:@"0x7B7B7B"];
        _poiAddressLabel.numberOfLines = 1;
        //        _poiAddressLabel.layer.borderWidth = 1;
        //        _poiAddressLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _poiAddressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _poiAddressLabel.font = [UIFont systemFontOfSize:12];
        [_subContainerView addSubview:_poiAddressLabel];
    }

    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"0x98C7E5"];
        _progressView.tintColor = [UIColor whiteColor];
        [_subContainerView addSubview:_progressView];
    }

    if (!_firstImageView) {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.image = [UIImage imageNamed:@"main_bg"];
        [_subContainerView addSubview:_firstImageView];
    }

    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.image = [UIImage imageNamed:@"main_bg"];
        [_subContainerView addSubview:_secondImageView];
    }

    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.image = [UIImage imageNamed:@"main_bg"];
        [_subContainerView addSubview:_thirdImageView];
    }

    _imageViewsArray = @[ _firstImageView, _secondImageView, _thirdImageView ];

    [self layoutView];
}

#pragma mark - Setter

- (void)setMEdit:(BOOL)mEdit
{
    if (_mEdit == mEdit)
        return;
    [self changeEditStatu:mEdit];
}

- (void)setMSeledted:(BOOL)mSeledted
{
    if (_mSeledted != mSeledted) {
        _mSeledted = mSeledted;
        [self changeSelectedStatu:_mSeledted];
    }
}

#pragma mark - Getter

- (BOOL)mEdit
{
    return _mEdit;
}

- (BOOL)mSeledted
{
    return _mSeledted;
}

- (NSMutableArray*)subContentConstraints
{
    if (!_subContentConstraints) {
        _subContentConstraints = [[NSMutableArray alloc] init];
    }
    return _subContentConstraints;
}

#pragma mark - 事件

- (void)selectBtnTaped:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(self, _mSeledted);
    }
}

- (void)moreBtnTaped:(id)sender
{
    if (self.moreTapBlock) {
        self.moreTapBlock(self);
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

- (void)changeEditStatu:(BOOL)isEdit
{
    _mEdit = isEdit;

    [self setNeedsUpdateConstraints];

    [self updateConstraintsIfNeeded];

    if (isEdit) {
        [UIView animateWithDuration:0.4
            animations:^{
                [self layoutIfNeeded];
            }
            completion:^(BOOL finished) {
                self.selectBtn.hidden = !_mEdit;
            }];
    }
    else {
        self.selectBtn.hidden = !_mEdit;
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self layoutIfNeeded];
                         }];
    }
}

- (void)changeSelectedStatu:(BOOL)isSelected
{
    _selectBtn.selected = isSelected;
}

- (void)setProgressPersent:(CGFloat)persent
{
    if (_progressView) {
        [_progressView setProgress:persent];
    }
}

#pragma mark - 类方法

+ (CGFloat)getSubtitleHeightWithTitle:(NSString*)subTitle
{
    return -1;
}

+ (CGFloat)getCellHeightWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle
{
    return sDefaultPadding * 2 + ceilf(sDefaultPadding / 4) + 20 + 25 + 20 + 11 + 60;
}

@end
