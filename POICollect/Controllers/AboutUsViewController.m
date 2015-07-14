//
//  AboutUsViewController.m
//  POICollect
//  关于我们
//  Created by 常敏 on 15/7/13.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIView+CMExpened.h"
#import "UIDevice+IdentifierAddition.h"

@interface AboutUsViewController ()

/**
 *  logo标题、版本号、信息
 */
@property (strong, nonatomic) UILabel *mLogoLabel, *mVersionLabel, *mInfoLabel;

/**
 *  logo的图标
 */
@property (strong, nonatomic) UIImageView* mLogoView;

@end

@implementation AboutUsViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  初始化工作
 */
- (void)initialize
{
    [self initView];
}

/**
 *  初始化视图
 */
- (void)initView
{
    [self initNavBar];
    [self initContent];
}

/**
 *  初始化导航条
 */
- (void)initNavBar
{
    self.title = @"关于我们";
    [self setNavigationBarTranslucent:NO];
    self.view.backgroundColor = kAppThemeSecondaryColor;
}

/**
 *  初始化内容
 */
- (void)initContent
{
    CGRect frame = kScreenBounds;
    frame.size.height -= (kStateBarHeight + kNavBarHeight);

    _mLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app"]];
    [_mLogoView setCenter:CGPointMake(kScreenWidth / 2, -36 + CGRectGetMidY(frame))];
    //    [_mLogoView circleCornerWithRadius:_mLogoView.frame.size.height / 2.0f];
    [self.view addSubview:_mLogoView];

    _mLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mLogoView.frame) + 30, kScreenWidth, 30)];
    _mLogoLabel.backgroundColor = [UIColor clearColor];
    _mLogoLabel.font = [UIFont boldSystemFontOfSize:17];
    _mLogoLabel.textColor = [UIColor colorWithHexString:@"0x000000"];
    _mLogoLabel.textAlignment = NSTextAlignmentCenter;
    _mLogoLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    [self.view addSubview:_mLogoLabel];

    _mVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mLogoLabel.frame), kScreenWidth, 20)];
    _mVersionLabel.backgroundColor = [UIColor clearColor];
    _mVersionLabel.font = [UIFont systemFontOfSize:12];
    _mVersionLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    _mVersionLabel.textAlignment = NSTextAlignmentCenter;

    _mVersionLabel.text = [NSString stringWithFormat:@"版本：V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:_mVersionLabel];

    _mInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 180, kScreenWidth, 100)];
    _mInfoLabel.numberOfLines = 0;
    _mInfoLabel.backgroundColor = [UIColor clearColor];
    _mInfoLabel.font = [UIFont systemFontOfSize:12];
    _mInfoLabel.textColor = [UIColor colorWithHexString:@"0x222222"];
    _mInfoLabel.textAlignment = NSTextAlignmentCenter;
    _mInfoLabel.text = [NSString stringWithFormat:kTianditu_Website_URL];
    [self.view addSubview:_mInfoLabel];
}

@end
