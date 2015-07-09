//
//  AddPOIViewController.m
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "AddPOIViewController.h"
#import "UIView+CMExpened.h"
#import "CMCustomWithButtonTextfield.h"
#import "CMDropdownButton.h"
#import "CMPhotoPickButton.h"
#import "CMPhotoKit.h"
#import "UIView+Toast.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "NSString+AXNetworkingMethods.h"
#import "POIDataManager.h"
#import "SelectLocationModelViewController.h"
#import "CMTouchScrollView.h"

static const CGFloat sDefaultPadding = 10;

typedef NS_ENUM(NSInteger, AddPOIViewCommitType) {
    AddPOIViewCommitTypeInsert,
    AddPOIViewCommitTypeUpdate
};

@interface AddPOIViewController () <CMCustomWithButtonTextfieldProtocol, SelectLocationModelViewControllerProtocol>

@property (nonatomic, strong) CLLocation* currentLocation;

@property (nonatomic, strong) UIView* mainBgView;

@property (nonatomic, strong) CMTouchScrollView* scrollView;

@property (nonatomic, strong) UIView* formBgView;

@property (nonatomic, strong) UIView* imagePickerBgView;

@property (nonatomic, strong) CMCustomWithButtonTextfield* poiNameTF;

@property (nonatomic, strong) CMCustomWithButtonTextfield* poiAddressTF;

@property (nonatomic, strong) CMDropdownButton* dropDownBtn;

@property (nonatomic, strong) CMPhotoPickButton* pickBtn1;

@property (nonatomic, strong) CMPhotoPickButton* pickBtn2;

@property (nonatomic, strong) CMPhotoPickButton* pickBtn3;

@property (nonatomic, strong) NSArray* pickBtnsArray;

@property (nonatomic, strong) SelectLocationModelViewController* selectVC;

@property (nonatomic, strong) NSArray* categoryArray;

@property (nonatomic, assign) AddPOIViewCommitType commitType;

@end

@implementation AddPOIViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Setter

- (void)setCurrentPoipoint:(POIPoint*)currentPoipoint
{
    if (_currentPoipoint == currentPoipoint) {
        return;
    }
    _currentPoipoint = currentPoipoint;

    [self updateView];
}

- (SelectLocationModelViewController*)selectVC
{
    if (!_selectVC) {
        _selectVC = [[SelectLocationModelViewController alloc] init];
        _selectVC.delegate = self;
    }
    return _selectVC;
}

#pragma mark - Getter

- (NSArray*)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = @[
            @"餐饮美食",
            @"汽车及非四轮车服务",
            @"运动休闲",
            @"地产小区",
            @"购物",
            @"生活服务",
            @"医疗卫生",
            @"宾馆酒店",
            @"旅游景点",
            @"政府机构",
            @"文化教育",
            @"交通设施",
            @"金融行业",
            @"地名地址",
            @"公司企业",
            @"公共设施"

        ];
    }
    return _categoryArray;
}

#pragma mark - 继承

- (void)viewWillLayoutSubviews
{
    [self relayoutSubviews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"点击页面>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    CloseKeyBoard;
}

#pragma mark - 自定义方法

- (void)updateView
{
    if (!_pickBtn3) {
        return;
    }

    if (!_currentPoipoint) {
        _poiNameTF.text = @"";
        _dropDownBtn.currentIndex = -1;
        _pickBtn1.currentPhoto = nil;
        _pickBtn2.currentPhoto = nil;
        _pickBtn3.currentPhoto = nil;
        if ([[LocationManager sharedManager] checkLocationAndShowingAlert:YES]) {
            [[LocationManager sharedManager] startLocation];
        }
        else {
            _poiAddressTF.text = @"定位失败，请手动输入";
        }
    }
    else {
        _poiNameTF.text = _currentPoipoint.poiName;
        _poiAddressTF.text = _currentPoipoint.poiAddress;
        _dropDownBtn.currentIndex = _currentPoipoint.poiCategory.integerValue;

        _pickBtn1.currentPhoto = nil;
        _pickBtn2.currentPhoto = nil;
        _pickBtn3.currentPhoto = nil;

        for (int i = 0; i < _currentPoipoint.images.count; i++) {
            ((CMPhotoPickButton*)[_pickBtnsArray objectAtIndex:i]).currentPhoto = (CMPhoto*)[_currentPoipoint.images objectAtIndex:i];
        }
    }
}

- (void)initializeData
{
    [self initializeNotifications];
}

- (void)initializeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidFailedLocated) name:LocationManagerDidFailedLocateNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationManagerDidSuccessedLocated) name:LocationManagerDidSuccessedLocateNotification object:nil];
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

    UIBarButtonItem* addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_ok"] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnTaped:)];
    self.navigationItem.rightBarButtonItem = addBtn;
}

- (void)initializeBody
{
    if (!_mainBgView) {
        _mainBgView = [[UIView alloc] init];
        _mainBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mainBgView];
    }

    if (!_scrollView) {
        _scrollView = [[CMTouchScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 4);
        [self.view addSubview:_scrollView];
    }

    if (!_formBgView) {
        _formBgView = [[UIView alloc] init];
        _formBgView.backgroundColor = [UIColor colorWithHexString:@"0xCFDFE9"];
        [_formBgView circleCornerWithRadius:4.f];
        [_scrollView addSubview:_formBgView];
    }

    if (!_poiNameTF) {
        _poiNameTF = [[CMCustomWithButtonTextfield alloc] initButtonTextfieldWithPlaceholder:@"名称"];
        _poiNameTF.placeholder = @"名称";
        [_formBgView addSubview:_poiNameTF];
    }

    if (!_poiAddressTF) {
        _poiAddressTF = [[CMCustomWithButtonTextfield alloc] initButtonTextfieldWithPlaceholder:@"地址" andWithButtonImage:[UIImage imageNamed:@"location_btn"] andWithSelectedButtonImage:[UIImage imageNamed:@"name_ico"]];
        _poiAddressTF.rightBtnDelegate = self;
        //        _poiAddressTF.borderStyle = UITextBorderStyleLine;
        //        _poiAddressTF.placeholder = @"asdasds";
        //        _poiAddressTF.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass_ico"]];
        //        _poiAddressTF.rightViewMode = UITextFieldViewModeAlways;
        [_formBgView addSubview:_poiAddressTF];
    }

    if (!_dropDownBtn) {
        _dropDownBtn = [[CMDropdownButton alloc] initDropdownButtonWithTitle:@"分类"];
        //        [_dropDownBtn setTitle:@"分类啊啊啊啊" forState:UIControlStateNormal];
        _dropDownBtn.datas = self.categoryArray;
        [_formBgView addSubview:_dropDownBtn];
    }

    if (!_imagePickerBgView) {
        _imagePickerBgView = [[UIView alloc] init];
        _imagePickerBgView.backgroundColor = [UIColor colorWithHexString:@"0xCFDFE9"];
        [_imagePickerBgView circleCornerWithRadius:4.f];
        [_scrollView addSubview:_imagePickerBgView];
    }

    if (!_pickBtn1) {
        _pickBtn1 = [[CMPhotoPickButton alloc] init];
        [_imagePickerBgView addSubview:_pickBtn1];
    }

    if (!_pickBtn2) {
        _pickBtn2 = [[CMPhotoPickButton alloc] init];
        [_imagePickerBgView addSubview:_pickBtn2];
    }

    if (!_pickBtn3) {
        _pickBtn3 = [[CMPhotoPickButton alloc] init];
        [_imagePickerBgView addSubview:_pickBtn3];
    }

    _pickBtnsArray = @[ _pickBtn1, _pickBtn2, _pickBtn3 ];

    [self updateView];
}

- (void)relayoutSubviews
{
    __weak typeof(self) weakSelf = self;
    if (_mainBgView) {
        [_mainBgView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(((UIView*)weakSelf.topLayoutGuide).bottom);
            make.left.and.right.and.bottom.equalTo(weakSelf.view);
        }];
    }

    if (_scrollView) {
        [_scrollView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(((UIView*)weakSelf.topLayoutGuide).bottom);
            make.left.and.right.and.bottom.equalTo(weakSelf.view);
        }];
    }

    if (_formBgView) {
        [_formBgView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.scrollView.top).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.scrollView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.scrollView.right).offset(-sDefaultPadding);
            make.width.equalTo(kScreenWidth - sDefaultPadding * 2);
            //            make.width.equalTo(@100);
            //            make.height.equalTo(@35);
            make.bottom.equalTo(weakSelf.dropDownBtn.bottom).offset(sDefaultPadding);
        }];
    }

    if (_poiNameTF) {
        [_poiNameTF makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.formBgView.top).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.formBgView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.formBgView.right).offset(-sDefaultPadding);
            make.height.equalTo(@35);
            make.bottom.equalTo(weakSelf.poiAddressTF.top).offset(-sDefaultPadding);
        }];
    }

    if (_poiAddressTF) {
        [_poiAddressTF makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.poiNameTF.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.formBgView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.formBgView.right).offset(-sDefaultPadding);
            make.height.equalTo(@35);
            make.bottom.equalTo(weakSelf.dropDownBtn.top).offset(-sDefaultPadding);
        }];
    }

    if (_dropDownBtn) {
        [_dropDownBtn makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.poiAddressTF.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.formBgView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.formBgView.right).offset(-sDefaultPadding);
            make.height.equalTo(@35);
            make.bottom.equalTo(weakSelf.formBgView.bottom).offset(-sDefaultPadding);
        }];
    }

    if (_imagePickerBgView) {
        [_imagePickerBgView makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.formBgView.bottom).offset(sDefaultPadding);
            make.left.equalTo(weakSelf.scrollView.left).offset(sDefaultPadding);
            make.right.equalTo(weakSelf.scrollView.right).offset(-sDefaultPadding);
        }];
    }

    if (_pickBtn1) {
        [_pickBtn1 makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.imagePickerBgView.top).offset(sDefaultPadding * 1.5);
            make.left.equalTo(weakSelf.imagePickerBgView.left).offset(sDefaultPadding * 1.5);
            make.right.equalTo(weakSelf.pickBtn2.left).offset(-sDefaultPadding * 1.5);
            make.bottom.equalTo(weakSelf.imagePickerBgView.bottom).offset(-sDefaultPadding * 1.5);
            make.width.and.height.equalTo(weakSelf.pickBtn2.width);
        }];
    }

    if (_pickBtn2) {
        [_pickBtn2 makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.imagePickerBgView.top).offset(sDefaultPadding * 1.5);
            make.left.equalTo(weakSelf.pickBtn1.right).offset(sDefaultPadding * 1.5);
            make.right.equalTo(weakSelf.pickBtn3.left).offset(-sDefaultPadding * 1.5);
            make.bottom.equalTo(weakSelf.imagePickerBgView.bottom).offset(-sDefaultPadding * 1.5);
            make.width.and.height.equalTo(weakSelf.pickBtn3.width);
        }];
    }

    if (_pickBtn3) {
        [_pickBtn3 makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(weakSelf.imagePickerBgView.top).offset(sDefaultPadding * 1.5);
            make.left.equalTo(weakSelf.pickBtn2.right).offset(sDefaultPadding * 1.5);
            make.right.equalTo(weakSelf.imagePickerBgView.right).offset(-sDefaultPadding * 1.5);
            //            make.width.equalTo(@[ weakSelf.pickBtn1.width, weakSelf.pickBtn2.width ]);
            make.bottom.equalTo(weakSelf.imagePickerBgView.bottom).offset(-sDefaultPadding * 1.5);
            make.width.and.height.equalTo(weakSelf.pickBtn2.width);
        }];
    }
}

#pragma mark - 事件

- (void)addBtnTaped:(id)sender
{
    if ([self.poiNameTF.text isEqualToString:@""]) {
        [self.view makeToast:@"名称不能为空"];
        return;
    }
    if ([self.poiAddressTF.text isEqualToString:@""]) {
        [self.view makeToast:@"地址不能为空"];
        return;
    }
    if (self.dropDownBtn.currentIndex == -1) {
        [self.view makeToast:@"请选择分类"];
        return;
    }
    if (!_currentLocation) {
        [self.view makeToast:@"没有位置信息"];
    }

    [self generateCurrentPoipoint];

    switch (_commitType) {
    case AddPOIViewCommitTypeInsert:
        [[POIDataManager sharedManager] insertNewPOI:_currentPoipoint];
        break;
    case AddPOIViewCommitTypeUpdate:
        [[POIDataManager sharedManager] updateByNewPOI:_currentPoipoint];
        break;
    }

    [self popViewControllerAnimated:YES];

    if (self.delegate && [self.delegate respondsToSelector:@selector(addPoiViewControllerDidSavedPOI:)]) {
        [self.delegate addPoiViewControllerDidSavedPOI:self];
    }
}

#pragma mark - Notifications

- (void)locationManagerDidSuccessedLocated
{
    NSString* addressName = [LocationManager sharedManager].currentLocationAddress;
    _currentLocation = [LocationManager sharedManager].currentLocation;
    _poiAddressTF.text = addressName;
    [[LocationManager sharedManager] stopLocation];
}

- (void)locationManagerDidFailedLocated
{
    _currentLocation = nil;
    _poiAddressTF.text = @"定位失败，请手动输入";
}

#pragma mark - 工具方法

- (void)generateCurrentPoipoint
{
    _commitType = AddPOIViewCommitTypeUpdate;
    if (!_currentPoipoint) {
        _currentPoipoint = [[POIPoint alloc] init];
        _commitType = AddPOIViewCommitTypeInsert;
    }
    _currentPoipoint.poiName = _poiNameTF.text;
    _currentPoipoint.poiAddress = _poiAddressTF.text;
    _currentPoipoint.poiCategory = [NSNumber numberWithInteger:_dropDownBtn.currentIndex];
    _currentPoipoint.poiLon = [NSNumber numberWithDouble:_currentLocation.coordinate.longitude];
    _currentPoipoint.poiLat = [NSNumber numberWithDouble:_currentLocation.coordinate.latitude];
    _currentPoipoint.isUploaded = NO;
    if (_commitType == AddPOIViewCommitTypeInsert) {
        _currentPoipoint.poiId = [NSString currentDateStr];
    }

    NSLog(@"保存的ID是-------------------------》\n %@ \n----------------------->", _currentPoipoint.poiId);

    NSMutableArray* imageArray = [[NSMutableArray alloc] init];

    if (_pickBtn1.currentPhoto) {
        [imageArray addObject:_pickBtn1.currentPhoto];
    }
    if (_pickBtn2.currentPhoto) {
        [imageArray addObject:_pickBtn2.currentPhoto];
    }
    if (_pickBtn3.currentPhoto) {
        [imageArray addObject:_pickBtn3.currentPhoto];
    }

    _currentPoipoint.images = imageArray;
}

#pragma mark - CMCustomWithButtonTextfieldProtocol

- (void)textfieldDidRightBtnTaped:(CMCustomWithButtonTextfield*)tf
{
    if (self.currentLocation) {
        self.selectVC.currentLocation = self.currentLocation;
    }
    [self.navigationController presentViewController:self.selectVC animated:YES completion:nil];
}

#pragma mark - SelectLocationModelViewControllerProtocol

- (void)selectVC:(SelectLocationModelViewController*)selectVC didSelectLocation:(NSDictionary*)locationIf
{
    NSLog(@"得到了选点的信息了");
    if (locationIf) {
        NSString* addressName = [locationIf objectForKey:@"selectedLocationAddress"];
        CLLocation* locatoin = [locationIf objectForKey:@"selectedLocation"];
        _currentLocation = locatoin;
        _poiAddressTF.text = addressName;
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
