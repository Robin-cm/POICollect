//
//  CMPhotoPickerAssetsViewController.m
//  POICollect
//  图片的展示容器
//  Created by 敏梵 on 15/6/28.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerAssetsViewController.h"
#import "CMPhotoPickerConllectionView.h"
#import "CMPhotoPickerDatas.h"
#import "CMPhotoPickerCollectionViewCell.h"
#import "CMPhotoPickerFooterCollectionReusableView.h"
#import "CMPhotoKit.h"

static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOOLBAR_HEIGHT = 44;

@interface CMPhotoPickerAssetsViewController () <CMPhotoPickerCollectionViewDelegate>

// View
// 相片View
@property (nonatomic, strong) CMPhotoPickerConllectionView* collectionView;
// 底部CollectionView

// 标记View
@property (nonatomic, strong) UILabel* makeView;
@property (nonatomic, strong) UIButton* doneBtn;
@property (nonatomic, strong) UIToolbar* toolBar;

// Datas
// 数据源
@property (nonatomic, strong) NSMutableArray* assets;
// 记录选中的assets
@property (nonatomic, strong) NSMutableArray* selectAssets;

@end

@implementation CMPhotoPickerAssetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    [self configData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // 赋值给上一个控制器
    self.groupVc.selectAsstes = self.selectAssets;
}

#pragma mark - Setter

- (void)setAssetsGroup:(CMPhotoPickerGroup*)assetsGroup
{
    if (!assetsGroup.groupName.length)
        return;

    _assetsGroup = assetsGroup;

    self.title = assetsGroup.groupName;

    // 获取Assets
    [self getGroupAssets];
}

- (void)setMinCount:(NSInteger)minCount
{
    _minCount = minCount;
    if (self.assets.count > minCount) {
        minCount = 0;
    }
    else {
        minCount = minCount; // minCount - self.selectAssets.count;
    }
    self.collectionView.minCount = minCount;
}

#pragma mark - Getter

- (UIButton*)doneBtn
{
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitleColor:kAppThemeSecondaryColor forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _doneBtn.enabled = NO;
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _doneBtn.frame = CGRectMake(0, 0, 45, 45);
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn addSubview:self.makeView];
    }
    return _doneBtn;
}

- (UILabel*)makeView
{
    if (!_makeView) {
        _makeView = [[UILabel alloc] init];
        _makeView.textColor = kAppThemeSecondaryColor;
        _makeView.textAlignment = NSTextAlignmentCenter;
        _makeView.font = [UIFont systemFontOfSize:13];
        _makeView.frame = CGRectMake(-20, 13, 20, 20);
        _makeView.hidden = YES;
        _makeView.layer.cornerRadius = _makeView.frame.size.height / 2.0;
        _makeView.clipsToBounds = YES;
        _makeView.backgroundColor = kAppThemeThirdColor;
        //        [self.view addSubview:_makeView];
    }
    return _makeView;
}

- (UIToolbar*)toolBar
{
    if (!_toolBar) {
        [self configToolbar];
    }
    return _toolBar;
}

- (CMPhotoPickerConllectionView*)collectionView
{
    if (!_collectionView) {
        CGFloat cellWidth = (CGRectGetWidth(self.view.frame) - CELL_MARGIN * (CELL_ROW + 1)) / CELL_ROW;
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), TOOLBAR_HEIGHT);

        _collectionView = [[CMPhotoPickerConllectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        // 时间置顶
        _collectionView.status = CMPickerCollectionViewShowOrderStatusTimeDesc;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[CMPhotoPickerCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];

        // 底部的View
        [_collectionView registerClass:[CMPhotoPickerFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerIdentifier];

        _collectionView.contentInset = UIEdgeInsetsMake(5, 0, TOOLBAR_HEIGHT, 0);
        _collectionView.collectionViewDelegate = self;
        [self.view insertSubview:_collectionView belowSubview:self.toolBar];

        NSDictionary* views = NSDictionaryOfVariableBindings(_collectionView);

        NSString* widthVfl = @"H:|-0-[_collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];

        NSString* heightVfl = @"V:|-0-[_collectionView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
    }
    return _collectionView;
}

#pragma mark - 自定义方法

- (void)configView
{
    self.view.backgroundColor = kAppThemeSecondaryColor;
    [self configTitle];
    [self configToolbar];
}

- (void)configData
{
}

- (void)configTitle
{
    self.title = @"选择图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
}

- (void)configToolbar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_toolBar];
    }

    NSDictionary* views = NSDictionaryOfVariableBindings(_toolBar);
    NSString* widthVfl = @"H:|-0-[_toolBar]-0-|";
    NSString* heightVfl = @"V:[_toolBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];

    // 左视图 中间距 右视图
    //    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarThumbCollectionView];
    UIBarButtonItem* fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];

    _toolBar.items = @[ fiexItem, rightItem ];
}

- (void)getGroupAssets
{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }

    __block NSMutableArray* assetsM = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;

    [[CMPhotoPickerDatas sharePhotoPickerData] getGroupPhotosWithGroup:self.assetsGroup
                                                              finished:^(NSArray* assets) {
                                                                  [assets enumerateObjectsUsingBlock:^(ALAsset* asset, NSUInteger idx, BOOL* stop) {
                                                                      CMPhotoAssets* zlAsset = [[CMPhotoAssets alloc] init];
                                                                      zlAsset.asset = asset;
                                                                      [assetsM addObject:zlAsset];
                                                                  }];

                                                                  weakSelf.collectionView.dataArray = assetsM;
                                                              }];
}

#pragma mark - 事件

- (void)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(id)sender
{
    if (!self.selectAssets || self.selectAssets.count < 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"没有选中的图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
        self.doneBtn.enabled = NO;
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{ @"selectAssets" : self.selectAssets }];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CMPhotoPickerCollectionViewDelegate

- (void)pickerCollectionViewDidSelected:(CMPhotoPickerConllectionView*)pickerCollectionView deleteAsset:(CMPhotoAssets*)deleteAssets
{
    if (self.selectPickerAssets.count == 0) {
        self.selectAssets = [NSMutableArray arrayWithArray:pickerCollectionView.selectAsstes];
    }
    else if (deleteAssets == nil) {
        [self.selectAssets addObject:[pickerCollectionView.selectAsstes lastObject]];
    }

    self.selectAssets = [NSMutableArray arrayWithArray:[[NSSet setWithArray:self.selectAssets] allObjects]];

    NSInteger count = self.selectAssets.count;
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld", (long)count];
    self.doneBtn.enabled = (count > 0);

    //    [self.toolBarThumbCollectionView reloadData];

    if (self.selectPickerAssets.count || deleteAssets) {
        CMPhotoAssets* asset = [pickerCollectionView.lastDataArray lastObject];
        if (deleteAssets) {
            asset = deleteAssets;
        }

        NSInteger selectAssetsCurrentPage = -1;
        for (NSInteger i = 0; i < self.selectAssets.count; i++) {
            CMPhotoAssets* photoAsset = self.selectAssets[i];
            if ([[[[asset.asset defaultRepresentation] url] absoluteString] isEqualToString:[[[photoAsset.asset defaultRepresentation] url] absoluteString]]) {
                selectAssetsCurrentPage = i;
                break;
            }
        }

        if (
            (self.selectAssets.count > selectAssetsCurrentPage)
            && (selectAssetsCurrentPage >= 0)) {
            if (deleteAssets) {
                [self.selectAssets removeObjectAtIndex:selectAssetsCurrentPage];
            }
            [self.collectionView.selectsIndexPath removeObject:@(selectAssetsCurrentPage)];
            //            [self.toolBarThumbCollectionView reloadData];
            self.makeView.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.selectAssets.count];
        }
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
