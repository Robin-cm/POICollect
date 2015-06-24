//
//  LoginViewController.m
//  POICollect
//  登录页面
//  Created by 常敏 on 15-6-18.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "LoginViewController.h"
#import "CMRoundSegmentControl.h"
#import "CMPageView.h"
#import "CMCustomAnimation.h"
#import "CMCustomPopAnimation.h"
#import "TestAnimationViewController.h"
#import "CMRoundBtn.h"

@interface LoginViewController () <CMRoundSegmentControlDelegate, CMPageViewDelegate>

@property (nonatomic, strong) CMRoundSegmentControl* mSegmentControl;

@property (nonatomic, strong) NSArray* titles;

@property (nonatomic, strong) NSMutableArray* views;

@property (nonatomic, strong) UIScrollView* mScrollView;

@property (nonatomic, strong) CMPageView* pageView;

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

- (void)initializeData
{
}

- (void)initializeView
{
    [self initializeTitle];
    [self initializeBody];
}

- (void)initializeTitle
{
    [self setNavigationBarTranslucent:YES];
    [self showBackgroundImage:YES];
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    _mSegmentControl = [[CMRoundSegmentControl alloc] initWithSectionTitles:_titles];
    _mSegmentControl.mBackgroundTintColor = [UIColor clearColor];
    _mSegmentControl.delegate = self;
    self.navigationItem.titleView = _mSegmentControl;
}

- (void)initializeBody
{
    __weak typeof(self) weakSelf = self;
    UIView* mainBgView = [[UIView alloc] init];
    mainBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainBgView];
    [mainBgView makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(((UIView*)weakSelf.topLayoutGuide).bottom);
        make.left.and.right.and.bottom.equalTo(weakSelf.view);
    }];

    if (!_pageView) {
        _pageView = [[CMPageView alloc] initPageViewWithViews:_views];
        _pageView.pageViewDelegate = self;
        [self.view addSubview:_pageView];
    }
    [_pageView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(mainBgView);
    }];
}

- (void)gotoNextBtnTaped:(id)sender
{
    NSLog(@"我被点击了，要去下个页面");
    UIViewController* toVc = [[TestAnimationViewController alloc] init];
    [self.navigationController pushViewController:toVc animated:YES];
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
    [_pageView setCurrentViewIndex:pIndex withAnimation:YES];
}

#pragma mark - CMPageViewDelegate

- (void)chagedOfpageview:(CMPageView*)pageview withCurrentIndex:(NSUInteger)index
{
    NSLog(@"滑动到---> %lu", (unsigned long)index);
    [_mSegmentControl setSelectedSegmentIndex:index];
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
