//
//  CMDropdownButton.m
//  POICollect
//  下拉菜单
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMDropdownButton.h"
#import "CMDropdownButtonArrowView.h"
#import "CMDropdownButtonTableViewCell.h"
#import "UITableView+Expanded.h"

#define kDefautlBgColor [UIColor colorWithHexString:@"0x97C6E4"]
#define kDefaultFgColor [UIColor colorWithHexString:@"0xffffff"]

#define kDefaultDropdownCellIdentifier @"kDefaultDropdownCellIdentifier"

static const CGFloat sDefaultMaxCellcount = 5;

static const CGFloat sDefaultCornerRadius = 4;

static const CGFloat sDefaultAnimationDismissDuration = 0.3;
static const CGFloat sDefaultAnimationShowDuration = 0.3;

@interface CMDropdownButton () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView* arrowImageView;

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UIView* tapBgView;

@property (nonatomic, assign) BOOL isOpening;

@end

@implementation CMDropdownButton

#pragma mark - 方法

- (id)initDropdownButtonWithTitle:(NSString*)title
{
    return [self initDropdownButtonWithTitle:title andWithDatas:nil];
}

- (id)initDropdownButtonWithTitle:(NSString*)title andWithDatas:(NSArray*)datas
{
    self = [super init];
    if (self) {
        //        _title = title;
        [self setTitle:title forState:UIControlStateNormal];
        //        [self setBtnTitle:title];
        _datas = datas;
        [self configView];
        [self updateView];
    }
    return self;
}

#pragma mark - 生命周期

- (void)layoutSubviews
{
    if (_arrowImageView) {
        _arrowImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_arrowImageView.bounds) - 10, (CGRectGetHeight(self.bounds) - CGRectGetHeight(_arrowImageView.frame)) / 2.0, CGRectGetWidth(_arrowImageView.bounds), CGRectGetHeight(_arrowImageView.bounds));
    }

    self.titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.bounds) - 40, CGRectGetHeight(self.bounds));
}

#pragma mark - 继承

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.backgroundColor = !highlighted ? _normalBgColor : [_normalBgColor darkenedColorWithBrightnessFloat:0.8];
    [self setNeedsDisplay];
}

#pragma mark - Setter

- (void)setTitle:(NSString*)title
{
}

- (void)setDatas:(NSArray*)datas
{
    if (datas && datas.count > 0) {
        _datas = datas;
        [_tableView reloadData];
    }
}

- (void)setArrowImage:(UIImage*)arrowImage
{
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
}

- (void)setNormalBgColor:(UIColor*)normalBgColor
{
    _normalFgColor = normalBgColor;
    [self updateView];
}

- (void)setNormalFgColor:(UIColor*)normalFgColor
{
    _normalBgColor = normalFgColor;
    [self updateView];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex < -1 || currentIndex >= _datas.count) {
        return;
    }
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        if (_currentIndex == -1) {
            [self setTitle:@"分类" forState:UIControlStateNormal];
        }
        else {
            NSLog(@"新的标题是：%@", [_datas objectAtIndex:_currentIndex]);
            //        [self setBtnTitle:((NSString*)[_datas objectAtIndex:_currentIndex])];
            [self setTitle:[_datas objectAtIndex:_currentIndex] forState:UIControlStateNormal];
        }
        [_tableView reloadData];
    }
}

#pragma mark - 自定义方法

- (void)setBtnTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)configView
{
    _isOpening = NO;

    if (!_arrowImage) {
        _arrowImage = [CMDropdownButtonArrowView getArrowImageWithFrame:CGRectMake(0, 0, 15, 13) andWithBgcolor:kAppThemePrimaryColor];
    }

    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:_arrowImage];
        [self addSubview:_arrowImageView];
    }

    self.titleLabel.font = [UIFont systemFontOfSize:14];

    _cornerRadius = sDefaultCornerRadius;
    _normalBgColor = kDefautlBgColor;
    _normalFgColor = kDefaultFgColor;
    _currentIndex = -1;

    if (![[self allTargets] containsObject:self]) {
        [super addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)updateView
{
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = YES;

    self.backgroundColor = _normalBgColor;

    self.tintColor = _normalFgColor;
    self.titleLabel.textColor = _normalFgColor;
    [self setTitleColor:_normalFgColor forState:UIControlStateNormal];
}

#pragma mark - 事件

- (void)btnTaped:(id)sender
{
    NSLog(@"下来菜单呗点击了！！！");

    if (!_tableView || ![_tableView isMemberOfClass:[UITableView class]]) {

        CGFloat tableHeight = MIN(_datas.count, sDefaultMaxCellcount) * sDefaultCell_Height;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight - tableHeight, kScreenWidth, tableHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"0xffffff" andAlpha:0.0];
        [_tableView registerClass:[CMDropdownButtonTableViewCell class] forCellReuseIdentifier:kDefaultDropdownCellIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView reloadData];
    }

    if (!_tapBgView || ![_tapBgView isMemberOfClass:[UIView class]]) {
        _tapBgView = [[UIView alloc] initWithFrame:kScreenBounds];
        _tapBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTaped:)];
        [_tapBgView addGestureRecognizer:tap];
    }

    NSLog(@"当前的打开状态是：%d", _isOpening);

    __weak typeof(self) weakSelf = self;
    if (_isOpening) {
        self.enabled = NO;
        [UIView animateWithDuration:sDefaultAnimationDismissDuration
            delay:0
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{
                weakSelf.tapBgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
                weakSelf.tableView.alpha = 0;
                weakSelf.tableView.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(weakSelf.tableView.frame), CGRectGetHeight(weakSelf.tableView.frame));
                weakSelf.arrowImageView.transform = CGAffineTransformRotate(weakSelf.arrowImageView.transform, DEGREES_TO_RADIANS(180));
            }
            completion:^(BOOL finished) {
                [weakSelf.tapBgView removeFromSuperview];
                [weakSelf.tableView removeFromSuperview];
                self.enabled = YES;
                self.isOpening = !self.isOpening;
            }];
    }
    else {
        [kKeyWindow addSubview:_tapBgView];
        [kKeyWindow addSubview:_tableView];
        [_tableView reloadData];
        self.enabled = NO;
        CGRect oriFrame = CGRectMake(0, kScreenHeight - CGRectGetHeight(_tableView.frame), CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame));
        _tableView.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.frame));
        [UIView animateWithDuration:sDefaultAnimationShowDuration
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                weakSelf.tapBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                weakSelf.tableView.alpha = 1.0;
                weakSelf.tableView.frame = oriFrame;
                weakSelf.arrowImageView.transform = CGAffineTransformRotate(weakSelf.arrowImageView.transform, DEGREES_TO_RADIANS(180));
            }
            completion:^(BOOL finished) {
                self.enabled = YES;
                self.isOpening = !self.isOpening;
            }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CMDropdownButtonTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kDefaultDropdownCellIdentifier];
    cell.textLabel.text = [_datas objectAtIndex:indexPath.row];
    [cell setCellSelected:(indexPath.row == _currentIndex)];
    [self.tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return sDefaultCell_Height;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self btnTaped:nil];
    if (_currentIndex == indexPath.row) {
        return;
    }
    self.currentIndex = indexPath.row;
    if ([_delegate respondsToSelector:@selector(cmDropdownButton:andSelectedIndex:)]) {
        [_delegate cmDropdownButton:self andSelectedIndex:_currentIndex];
    }

    if (_dropdownBtnSelectedChangeBlock) {
        _dropdownBtnSelectedChangeBlock(self, _currentIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
