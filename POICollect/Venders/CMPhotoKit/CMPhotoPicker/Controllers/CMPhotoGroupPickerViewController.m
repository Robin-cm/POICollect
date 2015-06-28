//
//  CMPhotoGroupPickerViewController.m
//  POICollect
//
//  Created by 敏梵 on 15/6/26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoGroupPickerViewController.h"
#import "CMPhotoKit.h"
#import "CMPhotoPickerDatas.h"
#import "CMPhotoPickerGroupTableViewCell.h"
#import "CMPhotoPickerAssetsViewController.h"

@interface CMPhotoGroupPickerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) NSArray* imageGroups;

@end

@implementation CMPhotoGroupPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    [self getGroups];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义私有方法

- (void)configView
{
    [self configTitle];
    [self configButtons];
    [self configTableView];
}

- (void)configTitle
{
    self.title = @"选择相册";
}

- (void)configButtons
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)configTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        //使用VFL必须把这个属性设置为NO
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;

        NSDictionary* views = NSDictionaryOfVariableBindings(_tableView);
        NSString* heightVFL = @"V:|-0-[_tableView]-0-|";
        NSString* widthVFL = @"H:|-0-[_tableView]-0-|";

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVFL options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVFL options:0 metrics:nil views:views]];
    }
}

- (void)getGroups
{
    CMPhotoPickerDatas* photoData = [CMPhotoPickerDatas sharePhotoPickerData];

    __weak typeof(self) weakSelf = self;

    [photoData getAllGroupsWithPhotos:^(id obj) {
        self.imageGroups = obj;

        //        weakSelf.tableView.dataSource = self;
        [weakSelf.tableView reloadData];

    }];
}

#pragma mark - 事件

- (void)done
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil];

    });
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageGroups.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CMPhotoPickerGroupTableViewCell* cell = [CMPhotoPickerGroupTableViewCell instanceCell];

    cell.group = self.imageGroups[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMPhotoPickerGroup* group = self.imageGroups[indexPath.row];
    CMPhotoPickerAssetsViewController* assetsVc = [[CMPhotoPickerAssetsViewController alloc] init];
    //    assetsVc.selectPickerAssets = self.selectAsstes;
    assetsVc.groupVc = self;
    assetsVc.assetsGroup = group;
    assetsVc.minCount = 2;
    [self.navigationController pushViewController:assetsVc animated:YES];
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
