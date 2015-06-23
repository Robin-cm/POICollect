//
//  MainPOIListViewController.m
//  POICollect
//  POI点的列表页面
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "MainPOIListViewController.h"
#import "MainListTableViewCell.h"
#import "CMCustomAnimation.h"
#import "CMCustomPopAnimation.h"
#import "AddPOIViewController.h"

#define kMainListCellIdentifine @"MainListCellIdentifine"

@interface MainPOIListViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong, readwrite) CMRoundBtn* addPOIBtn;

@property (nonatomic, strong) CMCustomAnimation* mAnimation;

@property (nonatomic, strong) CMCustomPopAnimation* mPopAnimation;

@property (nonatomic, strong) AddPOIViewController* addPoiViewController;

@end

@implementation MainPOIListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeData];
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getter

- (AddPOIViewController*)addPoiViewController
{
    if (!_addPoiViewController) {
        _addPoiViewController = [[AddPOIViewController alloc] init];
        //        _addPoiViewController.transitioningDelegate = self;
    }
    return _addPoiViewController;
}

#pragma mark - 自定义实例方法

- (void)initializeData
{
    _mAnimation = [[CMCustomAnimation alloc] init];
    _mPopAnimation = [[CMCustomPopAnimation alloc] init];
    self.navigationController.delegate = self;
    self.transitioningDelegate = self;
}

- (void)initializeView
{
    [self initializeTitle];
    [self initializeBody];
}

- (void)initializeTitle
{
    self.title = @"未上传";
}

- (void)initializeBody
{

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MainListTableViewCell class] forCellReuseIdentifier:kMainListCellIdentifine];
        [self.view addSubview:_tableView];
    }

    [_tableView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];

    if (!_addPOIBtn) {
        _addPOIBtn = [[CMRoundBtn alloc] initRoundBtnWithBtnType:TYPE_ADD];
        [_addPOIBtn addTarget:self action:@selector(addPOIBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addPOIBtn];
    }
    if (_addPOIBtn) {
        [_addPOIBtn makeConstraints:^(MASConstraintMaker* make) {
            make.size.equalTo(CGSizeMake(50, 50));
            make.bottom.equalTo(self.view.bottom).offset(-20);
            make.centerX.equalTo(self.view.centerX);
        }];
    }
}

#pragma mark - 自定义公共方法

- (void)hideAddPoiBtnWithAnimate:(BOOL)animate
{
    __weak typeof(self) weakSelf = self;
    if (animate) {
        [UIView animateWithDuration:0.3
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{

                weakSelf.addPOIBtn.transform = CGAffineTransformMakeRotation(-180 * M_PI / 180.0);
                //                weakSelf.addPOIBtn.transform = CGAffineTransformRotate(weakSelf.addPOIBtn.transform, M_PI_2);
                weakSelf.addPOIBtn.transform = CGAffineTransformMakeScale(0.05, 0.05);
                weakSelf.addPOIBtn.alpha = 0;
            }
            completion:^(BOOL finished){

            }];
    }
    else {
        _addPOIBtn.transform = CGAffineTransformMakeScale(0.05, 0.05);
        weakSelf.addPOIBtn.alpha = 0;
    }
}

- (void)showAddPoiBtnWithAnimate:(BOOL)animate
{
    __weak typeof(self) weakSelf = self;
    if (animate) {
        [UIView animateWithDuration:0.3
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut
            animations:^{
                weakSelf.addPOIBtn.transform = CGAffineTransformMakeRotation(180 * M_PI / 180.0);
                //                weakSelf.addPOIBtn.transform = CGAffineTransformRotate(weakSelf.addPOIBtn.transform, 0);
                weakSelf.addPOIBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                weakSelf.addPOIBtn.alpha = 1;
            }
            completion:^(BOOL finished){

            }];
    }
    else {
        _addPOIBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        weakSelf.addPOIBtn.alpha = 1;
    }
}

#pragma mark - 事件

- (void)addPOIBtnTaped:(id)sender
{
    NSLog(@"添加按钮点击");
    [self.navigationController pushViewController:self.addPoiViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MainListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMainListCellIdentifine];
    [cell setTitle:@"主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题" andSubTitle:@"副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [MainListTableViewCell getCellHeightWithTitle:@"主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题主标题" andSubTitle:@"副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题副标题"];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        return _mAnimation;
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
