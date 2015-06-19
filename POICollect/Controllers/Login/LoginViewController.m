//
//  LoginViewController.m
//  POICollect
//  登录页面
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginViewController.h"
#import "CMRoundSegmentControl.h"

@interface LoginViewController () <CMRoundSegmentControlDelegate>

@property (nonatomic, strong) CMRoundSegmentControl* mSegmentControl;

@property (nonatomic, strong) NSArray* titles;

@property (nonatomic, strong) NSMutableArray* views;

@property (nonatomic, strong) UIScrollView* mScrollView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 公共实例方法

- (id)initWithTitles:(NSArray*)pTitles andViewClasses:(NSArray*)pViewClass
{
    self = [super init];
    if (self) {
        _titles = pTitles;
        _views = [NSMutableArray arrayWithCapacity:pViewClass.count];
        for (Class viewClass in pViewClass) {
            [_views addObject:[viewClass new]];
        }
    }
    return self;
}

#pragma mark - 自定义私有方法

- (void)initializeView
{
    [self initializeTitle];
    [self initializeBody];
}

- (void)initializeTitle
{
    _mSegmentControl = [[CMRoundSegmentControl alloc] initWithSectionTitles:_titles];
    _mSegmentControl.delegate = self;
    self.navigationItem.titleView = _mSegmentControl;
}

- (void)initializeBody
{
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_mScrollView];
    _mScrollView.pagingEnabled = YES;
    _mScrollView.bounces = NO;
    NSLog(@"标题的个数是:%lu", (unsigned long)_titles.count);
    _mScrollView.contentSize = CGSizeMake(kScreenWidth * _titles.count, kScreenHeight - kStateBarHeight - kNavBarHeight);
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    [_mScrollView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];

    for (UIView* view in _views) {
        [_mScrollView addSubview:view];
    }

    for (int i = 0; i < _views.count; i++) {
        UIView* view = [_views objectAtIndex:i];
        __weak typeof(_mScrollView) weakScrollView = _mScrollView;
        [view makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakScrollView.top).offset(0);
            make.bottom.equalTo(weakScrollView.bottom).offset(0);
            make.width.equalTo(kScreenWidth);
            make.height.equalTo(kScreenHeight - kStateBarHeight - kNavBarHeight);
            make.left.equalTo(i == 0 ? weakScrollView.left : ((UIView*)[_views objectAtIndex:(i - 1)]).right).offset(0);
            make.right.equalTo(i == (_views.count) - 1 ? weakScrollView.right : ((UIView*)[_views objectAtIndex:(i + 1)]).left).offset(0);
        }];
    }
}

#pragma mark - CMRoundSegmentControlDelegate

/**
 *  选中时调用的回调
 *
 *  @param pSegmentControl 当前的segmentControl
 *  @param pIndex          选中的序号
 */
- (void)segmentControl:(CMRoundSegmentControl*)pSegmentControl didSelectIndex:(NSUInteger)pIndex
{
    NSLog(@"当前选中的序号是%lu", pIndex);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
