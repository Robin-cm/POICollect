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

#define kMainListCellIdentifine @"MainListCellIdentifine"

@interface MainPOIListViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, CMCustomCircleAnimationProtocol>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong, readwrite) CMRoundBtn* addPOIBtn;

@property (nonatomic, strong) CMCustomCircleAnimation* mAnimation;

//@property (nonatomic, strong) CMCustomPopAnimation* mPopAnimation;

//@property (nonatomic, strong) AddPOIViewController* addPoiViewController;

@property (nonatomic, assign) BOOL mEdit;

@property (nonatomic, strong) NSMutableArray* datas;

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

    _datas = [[POIDataManager sharedManager] queryAllPOIIsUploaded:NO];
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
    [self.navigationController pushViewController:addPoiViewController animated:YES];
}

- (void)editBtnTaped:(id)sender
{
    NSLog(@"编辑按钮点击");
    //    [self.tableView setEditing:!self.tableView.editing animated:YES];
    _mEdit = !_mEdit;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"数据的数量是：%lu", (unsigned long)self.datas.count);
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    NSLog(@"/////////////////////////////////\n重新刷新了数据了-------->>>> %lu\n/////////////////////////////////////", indexPath.row);

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
                NSLog(@"删除操作%lu", [indexPath row]);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
