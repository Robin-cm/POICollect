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

@interface LoginViewController () <CMRoundSegmentControlDelegate, CMPageViewDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) CMRoundSegmentControl* mSegmentControl;

@property (nonatomic, strong) NSArray* titles;

@property (nonatomic, strong) NSMutableArray* views;

@property (nonatomic, strong) UIScrollView* mScrollView;

@property (nonatomic, strong) CMPageView* pageView;

@property (nonatomic, strong) UIButton* gotoNextBtn;

@property (nonatomic, strong) CMCustomAnimation* mAnimation;

@property (nonatomic, strong) CMCustomPopAnimation* mPopAnimation;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mAnimation = [[CMCustomAnimation alloc] init];
    _mPopAnimation = [[CMCustomPopAnimation alloc] init];
    self.navigationController.delegate = self;
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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    _mSegmentControl = [[CMRoundSegmentControl alloc] initWithSectionTitles:_titles];
    _mSegmentControl.delegate = self;
    self.navigationItem.titleView = _mSegmentControl;
}

- (void)initializeBody
{
    __weak typeof(self) weakSelf = self;
    UIView* mainBgView = [[UIView alloc] init];
    mainBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainBgView];
    [mainBgView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(weakSelf.view);
    }];

    if (!_pageView) {
        _pageView = [[CMPageView alloc] initPageViewWithViews:_views];
        _pageView.pageViewDelegate = self;
        [self.view addSubview:_pageView];
    }
    _pageView.frame = CGRectMake(0, kStateBarHeight + 44, kScreenWidth, kScreenHeight - kStateBarHeight - 44);
    [_pageView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(weakSelf.view);
    }];

    if (!_gotoNextBtn) {
        _gotoNextBtn = [[UIButton alloc] init];
        [_gotoNextBtn setTitle:@"实验" forState:UIControlStateNormal];
        [_gotoNextBtn addTarget:self action:@selector(gotoNextBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_gotoNextBtn];
    }
    if (_gotoNextBtn) {
        [_gotoNextBtn makeConstraints:^(MASConstraintMaker* make) {
            make.size.equalTo(CGSizeMake(100, 100));
            make.bottom.equalTo(self.view.bottom).offset(-20);
            make.centerX.equalTo(self.view.centerX);
        }];
    }
}

- (void)gotoNextBtnTaped:(id)sender
{
    NSLog(@"我被点击了，要去下个页面");
    UIViewController* toVc = [[TestAnimationViewController alloc] init];
    self.transitioningDelegate = self;
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

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController*)presenting sourceController:(UIViewController*)source
{
    return _mAnimation;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController*)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.mAnimation;
    }
    else if (operation == UINavigationControllerOperationPop) {
        return _mPopAnimation;
    }
    else {
        return nil;
    }
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
