//
//  SelectLocationViewController.m
//  POICollect
//  选点的页面
//  Created by 常敏 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "SelectLocationViewController.h"
#import "LocationManager.h"
#import "UIView+Toast.h"

@interface SelectLocationViewController ()

@property (nonatomic, strong) TMapView* mapView;

@property (nonatomic, strong) UIImageView* locationIco;

@property (nonatomic, strong) NSString* currentCenterAddress;

@property (nonatomic, strong, readwrite) CLLocation* currentCenterLocation;

@end

@implementation SelectLocationViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configView];
    [self configData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_mapView) {
        [_mapView StartGetPosition];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_mapView) {
        [_mapView StopGetPosition];
    }
}

#pragma mark - Getter

#pragma amrk - Setter

#pragma mark -自定义方法

- (void)configData
{
    self.view.userInteractionEnabled = YES;
    [self configNotifications];
}

- (void)configNotifications
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAddressInfoSuccessed:) name:locationManagerDidSuccessFetchAddressInfoNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAddressInfoFailed:) name:LocationManagerDidFailedLocateNotification object:nil];
    });
}

- (void)configView
{
    [self configTitle];
    [self configBody];
}

- (void)configTitle
{
    self.title = @"选点";

    [self setNavigationBarTranslucent:NO];
    [self showBackgroundImage:NO];

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnTaped:)];

    UIBarButtonItem* okBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okBtnTaped:)];

    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = okBtn;
}

- (void)configBody
{
    if (!_mapView) {
        _mapView = [[TMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStateBarHeight - kNavBarHeight)];
        _mapView.delegate = self;
        _mapView.UserTrackMode = TUserTrackingModeFollow;
        [self.view addSubview:_mapView];
    }

    if (!_locationIco) {
        _locationIco = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_btn"]];
        //        _locationIco.frame = CGRectMake(100, 100, 50, 50);
        [self.view addSubview:_locationIco];
        _locationIco.center = self.view.center;
    }
}

- (void)layoutViews
{
    if (_mapView) {
        [_mapView makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)loading
{
    self.title = @"正在加载地址信息...";
}

#pragma mark - TMapViewDelegate

/**
 * 视图区域即将改变，在改变区域之前调用
 * @param mapView   [in] : 地图视图
 * @param animated  [in] : 是否以动画的方式改变
 */
- (void)mapView:(TMapView*)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图开始移动了");
}

/**
 * 视图区域已经改变，在改变区域之后调用
 * @param mapView   [in] : 地图视图
 * @param animated  [in] : 是否以动画的方式改变
 */
- (void)mapView:(TMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图结束移动了");
    [self loading];
    _currentCenterLocation = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];

    [[LocationManager sharedManager] fetchAddressInfoWithLocation:_currentCenterLocation];
}

#pragma mark - 事件

- (void)okBtnTaped:(id)sender
{
    NSLog(@"确定点击");
    CLLocationCoordinate2D location = self.mapView.centerCoordinate;
    CLLocation* centerLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    if (centerLocation && _currentCenterAddress) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDefaultSelectedNotifacitionidentifier
                                                                object:nil
                                                              userInfo:@{ selectedLocation : centerLocation,
                                                                  selectedLocationAddress : _currentCenterAddress }];
        });
    }
}

- (void)cancelBtnTaped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  成功返回地址
 *
 *  @param notification <#notification description#>
 */
- (void)fetchAddressInfoSuccessed:(NSNotification*)notification
{
    NSString* address = notification.userInfo[locationManagerAddressInfoKey];
    if (address) {
        _currentCenterAddress = address;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.title = address;
        });
    }
}

/**
 *  请求地址信息失败 
 *
 *  @param notification <#notification description#>
 */
- (void)fetchAddressInfoFailed:(NSNotification*)notification
{
    [self.view makeToast:@"请求地址信息出错"];
}

@end
