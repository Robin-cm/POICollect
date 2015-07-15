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
#import "HistoryPOIListViewController.h"
#import "POIUploadManager.h"
#import "NSString+validator.h"
#import "POIListCellViewModel.h"
#import "UIView+Toast.h"
#import "SettingViewController.h"

#define kMainListCellIdentifine @"MainListCellIdentifine"

@interface MainPOIListViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, CMCustomCircleAnimationProtocol, RTAPIManagerApiCallBackDelegate, RTAPIManagerParamSourceDelegate, RTAPIManagerValidator, AddPOIViewControllerProtocol, RTAPIManagerUploadFilesSourcedelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong, readwrite) CMRoundBtn* addPOIBtn;

@property (nonatomic, strong) CMCustomCircleAnimation* mAnimation;

@property (nonatomic, assign) BOOL mEdit;

@property (nonatomic, strong) NSMutableArray* datas;

@property (nonatomic, strong) UILabel* emptyLabel;

@property (nonatomic, strong) UserLogoutManager* userLogoutManager;

@property (nonatomic, strong) POIUploadManager* poiUploadManager;

@property (nonatomic, strong) POIPoint* uploadingPOIpoint;

@property (nonatomic, assign) CGFloat currentPersent;

@property (nonatomic, strong) NSMutableArray* cellViewModelsArray;

@property (nonatomic, strong) UIBarButtonItem* editBtn;

@property (nonatomic, strong) UIBarButtonItem* uploadBtn;

@property (nonatomic, strong) UIBarButtonItem* cancelUploadBtn;

@property (nonatomic, strong) UIBarButtonItem* historyBtn;

@property (nonatomic, strong) UIBarButtonItem* settingBtn;

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

#pragma mark - Setter

- (void)setMEdit:(BOOL)mEdit
{
    _mEdit = mEdit;
    if (_mEdit) {
        self.navigationItem.leftBarButtonItem = self.cancelUploadBtn;
        self.navigationItem.rightBarButtonItems = @[];
        self.navigationItem.rightBarButtonItem = self.uploadBtn;
    }
    else {
        self.navigationItem.leftBarButtonItem = self.editBtn;
        self.navigationItem.rightBarButtonItems = @[ self.settingBtn, self.historyBtn ];
    }
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

- (UIBarButtonItem*)editBtn
{
    if (!_editBtn) {
        _editBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnTaped:)];
    }
    return _editBtn;
}

- (UIBarButtonItem*)uploadBtn
{
    if (!_uploadBtn) {
        _uploadBtn = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnTaped:)];
    }
    return _uploadBtn;
}

- (UIBarButtonItem*)cancelUploadBtn
{
    if (!_cancelUploadBtn) {
        _cancelUploadBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnTaped:)];
    }
    return _cancelUploadBtn;
}

- (UIBarButtonItem*)historyBtn
{
    if (!_historyBtn) {
        _historyBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_his"] style:UIBarButtonItemStylePlain target:self action:@selector(historyBtnTaped:)];
    }
    return _historyBtn;
}

- (UIBarButtonItem*)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutBtnTaped:)];
    }
    return _settingBtn;
}

- (NSMutableArray*)cellViewModelsArray
{
    if (!_cellViewModelsArray) {
        _cellViewModelsArray = [[NSMutableArray alloc] init];
    }
    return _cellViewModelsArray;
}

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

- (POIUploadManager*)poiUploadManager
{
    if (!_poiUploadManager) {
        _poiUploadManager = [[POIUploadManager alloc] init];
        _poiUploadManager.delegate = self;
        _poiUploadManager.paramSource = self;
        _poiUploadManager.filesSource = self;
        _poiUploadManager.validator = self;
    }
    return _poiUploadManager;
}

#pragma mark - 自定义实例方法

- (void)initializeData
{
    _mAnimation = [[CMCustomCircleAnimation alloc] init];
    _mAnimation.delegate = self;
    //    _mEdit = NO;
    [self refreshData];
}

- (void)refreshData
{
    _datas = [[POIDataManager sharedManager] queryAllPOIIsUploaded:NO];
    [self.cellViewModelsArray removeAllObjects];
    if (_datas && _datas.count > 0) {
        for (POIPoint* point in _datas) {
            POIListCellViewModel* cellViewModel = [[POIListCellViewModel alloc] initListCellViewModelWith:point];
            [self.cellViewModelsArray addObject:cellViewModel];
        }
    }

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

    self.mEdit = NO;

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

- (void)setupCellView:(MainListTableViewCell*)cell withPoipoint:(POIPoint*)point
{
    POIListCellViewModel* cellViewModel = [self findViewModelByPoipoint:point];
    if (cellViewModel) {
        cellViewModel.cellView = cell;
    }
    else {
        NSLog(@"没有找到对应的ViewModel");
    }
}

- (POIListCellViewModel*)findViewModelByPoipoint:(POIPoint*)point
{
    if (_cellViewModelsArray && _cellViewModelsArray.count > 0) {
        for (POIListCellViewModel* cellViewModel in _cellViewModelsArray) {
            if ([cellViewModel equalsToPoipoint:point]) {
                return cellViewModel;
            }
        }
    }
    return nil;
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

- (void)uploadPOIInfoWithPOIpoint:(POIPoint*)point
{
    NSLog(@"更新POI点： %ld", (long)point.poiId);
    if (_uploadingPOIpoint) {
        [self.view makeToast:@"正在上传，请稍等..."];
        return;
    }
    _uploadingPOIpoint = point;
    [self.poiUploadManager uploadData];
    //    for (int i = 0; i < 100; i++) {
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [self managerCallAPIProgress:nil andPersent:(i / 100.0)];
    //            });
    //        });
    //    }
}

- (void)gotoEditPOIWithPoipoint:(POIPoint*)point
{
    self.navigationController.delegate = nil;
    self.transitioningDelegate = nil;
    AddPOIViewController* addPoiViewController = [[AddPOIViewController alloc] init];
    addPoiViewController.currentPoipoint = point;
    addPoiViewController.delegate = self;
    [self.navigationController pushViewController:addPoiViewController animated:YES];
}

#pragma mark - 事件

- (void)addPOIBtnTaped:(id)sender
{
    NSLog(@"添加按钮点击");
    self.navigationController.delegate = self;
    self.transitioningDelegate = self;
    AddPOIViewController* addPoiViewController = [[AddPOIViewController alloc] init];
    addPoiViewController.currentPoipoint = nil;
    addPoiViewController.delegate = self;
    [self.navigationController pushViewController:addPoiViewController animated:YES];
}

- (void)editBtnTaped:(id)sender
{
    NSLog(@"编辑按钮点击");
    //    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.mEdit = !self.mEdit;
    [self.tableView reloadData];
}

- (void)logoutBtnTaped:(id)sender
{
    NSLog(@"注销用户");
    //    if (![self.userLogoutManager isLoading]) {
    //        [self.view makeToastActivity];
    //        [self.userLogoutManager loadData];
    //    }

    SettingViewController* settingVC = [[SettingViewController alloc] init];
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    //    [self pushVC:navVC andParams:nil];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

- (void)historyBtnTaped:(id)sender
{
    NSLog(@"历史点击");
    self.navigationController.delegate = nil;
    self.transitioningDelegate = nil;
    HistoryPOIListViewController* historyVC = [[HistoryPOIListViewController alloc] init];
    [self pushVC:historyVC andParams:nil];
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

    [self setupCellView:cell withPoipoint:point];

    NSLog(@"点的名称是：%@   点的地址是：%@", point.poiName, point.poiAddress);
    cell.poiPoint = point;
    NSLog(@"要更新的POIID是：%ld", (long)_uploadingPOIpoint.poiId);
    //    if (point.poiId == _uploadingPOIpoint.poiId && indexPath.row == _currentUpdateRowIndex) {
    //        //当前正在上传
    //        //更新进度条
    //        [cell setProgressPersent:_currentPersent];
    //    }

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
            case 0: {
                //上传
                [self uploadPOIInfoWithPOIpoint:point];
                break;
            }
            case 1: {
                //编辑
                [self gotoEditPOIWithPoipoint:point];
                break;
            }
            case 2: {
                NSLog(@"删除操作%lu", (long)[indexPath row]);
                [self.tableView beginUpdates];
                //                [self.datas removeObjectAtIndex:indexPath.row];
                POIPoint* point = [self.datas objectAtIndex:indexPath.row];
                [point cleanAllImages];

                [[POIDataManager sharedManager] deleteByPOI:point];
                [self.datas removeObjectAtIndex:indexPath.row];

                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                [self refreshData];

                break;
            }

            default:
                break;
            }

        };
        [actionSheetView show];
    };
    cell.mEdit = self.mEdit;
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
    POIPoint* point = [self.datas objectAtIndex:indexPath.row];
    if (self.mEdit) {
        NSLog(@"设置选中");
        point.poiSelected = !point.poiSelected;
        [[self findViewModelByPoipoint:point].cellView setMSeledted:point.poiSelected];
    }
    else {
        [self gotoEditPOIWithPoipoint:point];
    }
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
    NSLog(@"成功返回数据");
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
    else if ([manager isKindOfClass:[POIUploadManager class]]) {
        //上传文件回调
        NSLog(@"上传文件完成");
        if (_uploadingPOIpoint) {
            //上传完成后续操作，更新点的信息
            [[self findViewModelByPoipoint:_uploadingPOIpoint].cellView setProgressPersent:0.f];
            _uploadingPOIpoint.isUploaded = YES;
            [[POIDataManager sharedManager] updateByNewPOI:_uploadingPOIpoint];
            _uploadingPOIpoint = nil;
            [self refreshData];
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

- (void)managerCallAPIProgress:(RTAPIBaseManager*)manager andPersent:(CGFloat)persent
{
    NSLog(@"上传的进度：--->> %f", persent);
    _currentPersent = persent;
    if (_uploadingPOIpoint) {
        POIListCellViewModel* cellViewModel = [self findViewModelByPoipoint:_uploadingPOIpoint];
        if (cellViewModel.cellView) {
            [cellViewModel.cellView setProgressPersent:_currentPersent];
        }
    }
    //    [self.tableView reloadData];
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
    if ([manager isKindOfClass:[UserLogoutManager class]]) {
        User* currentUser = [LoginUser currentLoginUser];
        return @{
            @"userId" : currentUser.userId,
            @"token" : currentUser.toKen
        };
    }
    else if ([manager isKindOfClass:[POIUploadManager class]]) {

        NSLog(@"名称：%@", _uploadingPOIpoint.poiName);
        NSLog(@"类别：%@", _uploadingPOIpoint.poiCategory);
        NSLog(@"纬度：%@", _uploadingPOIpoint.poiLon);
        NSLog(@"经度：%@", _uploadingPOIpoint.poiLat);
        NSLog(@"编号：%@", [LoginUser currentLoginUser].userId);
        NSLog(@"token：%@", [LoginUser currentLoginUser].toKen);
        return @{
            @"poiName" : _uploadingPOIpoint.poiName,
            @"typeCode" : [NSString stringFromNumber:[NSNumber numberWithInt:(_uploadingPOIpoint.poiCategory.intValue + 1)]],
            @"lng" : _uploadingPOIpoint.poiLon,
            @"lat" : _uploadingPOIpoint.poiLat,
            @"userId" : [LoginUser currentLoginUser].userId,
            @"address" : _uploadingPOIpoint.poiAddress,
            @"token" : [LoginUser currentLoginUser].toKen
        };
    }
    else {
        return @{};
    }
}

#pragma mark - RTAPIManagerUploadFilesSourcedelegate

- (NSArray*)uploadSourceForAPI:(RTAPIBaseManager*)manager
{
    if ([manager isKindOfClass:[POIUploadManager class]]) {
        return _uploadingPOIpoint.images;
    }
    return nil;
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
