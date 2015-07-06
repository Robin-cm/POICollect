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

static const CGFloat sDefaultPadding = 10;

@interface AddPOIViewController ()

@property (nonatomic, strong) UIView* mainBgView;

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, strong) UIView* formBgView;

@property (nonatomic, strong) UIView* imagePickerBgView;

@property (nonatomic, strong) CMCustomWithButtonTextfield* poiNameTF;

@property (nonatomic, strong) CMCustomWithButtonTextfield* poiAddressTF;

@property (nonatomic, strong) CMDropdownButton* dropDownBtn;

@property (nonatomic, strong) CMPhotoPickButton* pickBtn1;

@property (nonatomic, strong) CMPhotoPickButton* pickBtn2;

@property (nonatomic, strong) CMPhotoPickButton* pickBtn3;

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

#pragma mark - 继承

- (void)viewWillLayoutSubviews
{
    [self relayoutSubviews];
}

#pragma mark - 自定义方法

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

    UIBarButtonItem* addBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(addBtnTaped:)];
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
        _scrollView = [[UIScrollView alloc] init];
        //        _scrollView.backgroundColor = [UIColor blueColor];
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
        //        _poiAddressTF.borderStyle = UITextBorderStyleLine;
        //        _poiAddressTF.placeholder = @"asdasds";
        //        _poiAddressTF.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass_ico"]];
        //        _poiAddressTF.rightViewMode = UITextFieldViewModeAlways;
        [_formBgView addSubview:_poiAddressTF];
    }

    if (!_dropDownBtn) {
        _dropDownBtn = [[CMDropdownButton alloc] initDropdownButtonWithTitle:@"分类"];
        //        [_dropDownBtn setTitle:@"分类啊啊啊啊" forState:UIControlStateNormal];
        _dropDownBtn.datas = @[
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

    //    [self relayoutSubviews];
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
    [self popViewControllerAnimated:YES];
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
