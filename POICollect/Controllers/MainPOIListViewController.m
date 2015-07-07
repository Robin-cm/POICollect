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
#import "CMCustomCircleAnimation.h"
#import "CMCustomPopAnimation.h"
#import "AddPOIViewController.h"
#import "POIPoint.h"
#import "CMActionSheetView.h"
#import "POIDataManager.h"
#import "LoginUser.h"
#import "UserLogoutManager.h"
#import "LoginUser.h"
#import "UIView+Toast.h"
#import "LocationManager.h"

#define kMainListCellIdentifine @"MainListCellIdentifine"

@interface MainPOIListViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, CMCustomCircleAnimationProtocol, RTAPIManagerApiCallBackDelegate, RTAPIManagerParamSourceDelegate, RTAPIManagerValidator, AddPOIViewControllerProtocol>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong, readwrite) CMRoundBtn* addPOIBtn;

@property (nonatomic, strong) CMCustomCircleAnimation* mAnimation;

//@property (nonatomic, strong) CMCustomPopAnimation* mPopAnimation;

//@property (nonatomic, strong) AddPOIViewController* addPoiViewController;

@property (nonatomic, assign) BOOL mEdit;

@property (nonatomic, strong) NSMutableArray* datas;

@property (nonatomic, strong) UILabel* emptyLabel;

@property (nonatomic, strong) UserLogoutManager* userLogoutManager;

@end

@implementation MainPOIListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeView];
    [self initializeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getter

//- (AddPOIViewController*)addPoiViewController
//{
//    if (!_addPoiViewController) {
//        _addPoiViewController = [[AddPOIViewController alloc] init];
//        //        _addPoiViewController.transitioningDelegate = self;
//    }
//    return _addPoiViewController;
//}

- (NSMutableArray*)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (UserLogoutManager*)userLogoutManager
{
    if (!_userLogoutManager) {
        _userLogoutManager = [[UserLogoutManager alloc] init];
        _userLogoutManager.delegate = self;
        _userLogoutManager.paramSource = self;
        _userLogoutManager.validator = self;
    }
    return _userLogoutManager;
}

- (UILabel*)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:20 weight:10];
        _emptyLabel.textColor = kAppThemeSecondaryColor;
        _emptyLabel.text = @"还没有记录，快去添加一个吧!";
        [self.view addSubview:_emptyLabel];
        _emptyLabel.center = self.view.center;
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}

#pragma mark - 自定义实例方法

- (void)initializeData
{
    _mAnimation = [[CMCustomCircleAnimation alloc] init];
    _mAnimation.delegate = self;
    _mEdit = NO;
    //    _mPopAnimation = [[CMCustomPopAnimation alloc] init];
    self.navigationController.delegate = self;
    self.transitioningDelegate = self;

    //    for (int i = 0; i < 5; i++) {
    //        POIPoint* poiPoint = [[POIPoint alloc] init];
    //        poiPoint.poiName = [NSString stringWithFormat:@"第%i个POI点", i];
    //        poiPoint.poiAddress = [NSString stringWithFormat:@"第%i个POI点的地址", i];
    //        poiPoint.images = @[];
    //        poiPoint.isUploaded = NO;
    //        poiPoint.poiLat = [NSNumber numberWithFloat:37.0000];
    //        poiPoint.poiLon = [NSNumber numberWithFloat:117.0000];
    //        poiPoint.poiCategory = [NSNumber numberWithInteger:0];
    //        poiPoint.poiId = arc4random_uniform(1000000);
    //        poiPoint.poiSelected = NO;
    //
    //        [[POIDataManager sharedManager] insertNewPOI:poiPoint];
    //        //        [self.datas addObject:poiPoint];
    //    }
    [self refreshData];
}

- (void)refreshData
{
    _datas = [[POIDataManager sharedManager] queryAllPOIIsUploaded:NO];
    [self.tableView reloadData];
    if (_datas.count < 1) {
        self.emptyLabel.hidden = NO;
    }
    else {
        self.emptyLabel.hidden = YES;
    }
}

- (void)initializeView
{
    [self initializeTitle];
    [self initializeBody];
    [self checkIslogin];
}

- (void)initializeTitle
{
    self.title = @"未上传";
    [self setNavigationBarTranslucent:YES];
    [self showBackgroundImage:YES];

    UIBarButtonItem* editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnTaped:)];

    self.navigationItem.leftBarButtonItem = editBtn;

    UIBarButtonItem* logoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutBtnTaped:)];
    UIBarButtonItem* historyBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(historyBtnTaped:)];

    self.navigationItem.rightBarButtonItems = @[ logoutBtn, historyBtn ];
}

- (void)initializeBody
{
    __weak typeof(self) weakSelf = self;
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
        make.top.equalTo(((UIView*)weakSelf.topLayoutGuide).bottom);
        make.left.and.right.and.bottom.equalTo(weakSelf.view);
        //        make.edges.equalTo(self.view);
    }];

    if (!_addPOIBtn) {
        _addPOIBtn = [[CMRoundBtn alloc] initRoundBtnWithBtnType:TYPE_ADD];
        _addPOIBtn.normalBackgroundColor = kAppThemeThirdColor;
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
    AddPOIViewController* addPoiViewController = [[AddPOIViewController alloc] init];
    addPoiViewController.currentPoipoint = nil;
    addPoiViewController.delegate = self;
    [self.navigationController pushViewController:addPoiViewController animated:YES];
}

- (void)editBtnTaped:(id)sender
{
    NSLog(@"编辑按钮点击");
    //    [self.tableView setEditing:!self.tableView.editing animated:YES];
    _mEdit = !_mEdit;
    [self.tableView reloadData];
}

- (void)logoutBtnTaped:(id)sender
{
    NSLog(@"注销用户");
    if (![self.userLogoutManager isLoading]) {
        [self.view makeToastActivity];
        [self.userLogoutManager loadData];
    }
}

- (void)historyBtnTaped:(id)sender
{
    NSLog(@"历史点击");

    [[LocationManager sharedManager] checkLocationAndShowingAlert:YES];
    [[LocationManager sharedManager] startLocation];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"数据的数量是：%lu", (unsigned long)self.datas.count);
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    NSLog(@"/////////////////////////////////\n重新刷新了数据了-------->>>> %lu\n/////////////////////////////////////", (long)indexPath.row);

    MainListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMainListCellIdentifine];
    POIPoint* point = [self.datas objectAtIndex:indexPath.row];
    NSLog(@"点的名称是：%@   点的地址是：%@", point.poiName, point.poiAddress);
    cell.poiPoint = point;
    cell.mSeledted = point.poiSelected;
    cell.selectBlock = ^(id obj, BOOL selected) {
        NSLog(@"当前的选中状态是--->:%d", selected);
        point.poiSelected = selected;
    };
    cell.moreTapBlock = ^(id obj) {
        NSLog(@"点击了更多按钮");
        CMActionSheetView* actionSheetView = [[CMActionSheetView alloc] initWithCancelBtn:@"取消" andOtherButtonTitles:@[ @"上传", @"编辑", @"删除" ]];
        actionSheetView.selectRowBlock = ^(CMActionSheetView* cmActionView, NSInteger selectIndex) {

            NSLog(@"我点击了%ld", (long)selectIndex);

            switch (selectIndex) {
            case 0:

                break;
            case 1:

                break;
            case 2:
                NSLog(@"删除操作%lu", (long)[indexPath row]);
                [self.tableView beginUpdates];
                [self.datas removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                [self.tableView reloadData];
                //                [self.datas removeObjectAtIndex:indexPath.row];
                break;

            default:
                break;
            }

        };
        [actionSheetView show];
    };
    cell.mEdit = _mEdit;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [MainListTableViewCell getCellHeightWithTitle:@"名称" andSubTitle:@"华苑产业技术园兰苑路5号"];
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
        _mAnimation.isPositiveAnimation = YES;
        return _mAnimation;
    }
    else if (operation == UINavigationControllerOperationPop) {
        _mAnimation.isPositiveAnimation = NO;
        return _mAnimation;
    }
    else {
        return nil;
    }
}

#pragma mark - CMCustomCircleAnimationProtocol

- (void)stateChange:(BOOL)isOpen
{
    if (isOpen) {
        [self hideAddPoiBtnWithAnimate:YES];
    }
    else {
        [self showAddPoiBtnWithAnimate:YES];
    }
}

#pragma mark - RTAPIManagerApiCallBackDelegate

/**
 *  请求成功回调函数
 *
 *  @param manager manager对象
 */
- (void)managerCallAPIDidSuccess:(RTAPIBaseManager*)manager
{
    NSLog(@"注销成功返回数据");
    [self.view hideToastActivity];
    if ([manager isKindOfClass:[UserLogoutManager class]]) {
        NSDictionary* result = [manager fetchDataWithReformer:nil];
        NSLog(@"成功返回了数据了: %@", result);
        if ([[result objectForKey:@"success"] boolValue]) {
            //注销成功
            [LoginUser doLogout];
            [self checkIslogin];
        }
        else {
            //注销失败
            [self.view makeToast:[result objectForKey:@"msg"]];
        }
    }
}

/**
 *  请求失败回调函数
 *
 *  @param manager manager对象
 */
- (void)managerCallAPIDidFailed:(RTAPIBaseManager*)manager
{
    [self.view hideToastActivity];
    [self.view makeToast:[NSString stringWithFormat:@"请求错误：%@", manager.errorMessage]];
    NSLog(@"请求失败 : %@", manager.errorMessage);
}

#pragma mark - RTAPIManagerParamSourceDelegate

/**
 *  获取请求的参数字典
 *
 *  @param manager manager对象
 *
 *  @return 返回的参数的字典
 */
- (NSDictionary*)paramsForAPI:(RTAPIBaseManager*)manager
{
    User* currentUser = [LoginUser currentLoginUser];
    return @{
        @"userId" : currentUser.userId,
        @"token" : currentUser.toKen
    };
}

#pragma mark - RTAPIManagerValidator

- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithCallBackData:(NSDictionary*)data
{

    return YES;
}

/**
 *  验证请求的参数的方法。当调用API的参数是来自用户输入的时候，验证时必要的。
 *  当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。
 *
 *  @param manager manager对象
 *  @param data    参数的字典数据
 *
 *  @return 是否验证通过
 */
- (BOOL)manager:(RTAPIBaseManager*)manager isCorrectWithParamsData:(NSDictionary*)data
{
    return YES;
}

#pragma mark - AddPOIViewControllerProtocol

- (void)addPoiViewControllerDidSavedPOI:(AddPOIViewController*)addPoiViewController
{
    NSLog(@"保存完成了");
    [self refreshData];
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
