//
//  HistoryPOIListViewController.m
//  POICollect
//
//  Created by 常敏 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "HistoryPOIListViewController.h"
#import "MainListTableViewCell.h"
#import "POIDataManager.h"
#import "CMActionSheetView.h"

#define kMainListCellIdentifine @"MainListCellIdentifine"

@interface HistoryPOIListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UILabel* emptyLabel;

@property (nonatomic, strong) NSMutableArray* datas;

@end

@implementation HistoryPOIListViewController

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

#pragma mark - Getter

- (NSMutableArray*)datas
{
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (UILabel*)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.font = [UIFont systemFontOfSize:20 weight:10];
        _emptyLabel.textColor = kAppThemeSecondaryColor;
        _emptyLabel.text = @"还没有上传记录！";
        [self.view addSubview:_emptyLabel];
        _emptyLabel.center = self.view.center;
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}

#pragma mark - 自定义方法

- (void)configData
{
    [self refreshData];
}

- (void)configView
{
    [self configTitle];
    [self configBody];
}

- (void)configTitle
{
    self.title = @"上传历史";
}

- (void)configBody
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg"]]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MainListTableViewCell class] forCellReuseIdentifier:kMainListCellIdentifine];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor clearColor];
    }

    [self layoutViews];
}

- (void)layoutViews
{
    if (_tableView) {
        [_tableView makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)refreshData
{
    self.datas = [[POIDataManager sharedManager] queryAllPOIIsUploaded:YES];
    [_tableView reloadData];
    [self.tableView reloadData];
    if (self.datas.count < 1) {
        self.emptyLabel.hidden = NO;
    }
    else {
        self.emptyLabel.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MainListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMainListCellIdentifine];
    POIPoint* point = [self.datas objectAtIndex:indexPath.row];
    NSLog(@"点的名称是：%@   点的地址是：%@", point.poiName, point.poiAddress);
    cell.poiPoint = point;
    cell.mSeledted = point.poiSelected;
    cell.moreTapBlock = ^(id obj) {
        CMActionSheetView* actionSheetView = [[CMActionSheetView alloc] initWithCancelBtn:@"取消" andOtherButtonTitles:@[ @"删除" ]];
        actionSheetView.selectRowBlock = ^(CMActionSheetView* cmActionView, NSInteger selectIndex) {

            NSLog(@"我点击了%ld", (long)selectIndex);

            switch (selectIndex) {
            case 0: {
                NSLog(@"删除操作%lu", (long)[indexPath row]);
                [self.tableView beginUpdates];
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
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [MainListTableViewCell getCellHeightWithTitle:@"名称" andSubTitle:@"华苑产业技术园兰苑路5号"];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
}

@end
