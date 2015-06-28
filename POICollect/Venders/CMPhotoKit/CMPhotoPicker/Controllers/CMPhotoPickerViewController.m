//
//  CMPhotoPickerViewController.m
//  POICollect
//  图片选择容器
//  Created by 常敏 on 15-6-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMPhotoPickerViewController.h"
#import "CMPhotoKit.h"

@interface CMPhotoPickerViewController ()

@property (nonatomic, strong) CMPhotoGroupPickerViewController* groupPickerVC;

@end

@implementation CMPhotoPickerViewController

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViewController];
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self configView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    [self configNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setter

- (void)setMinCount:(NSInteger)minCount
{
    if (minCount <= 0)
        return;
    _minCount = minCount;
    self.groupPickerVC.minCount = minCount;
}

- (void)setDelegate:(id<CMPhotoPickerViewControllerDelegate>)delegate
{

    _delegate = delegate;
    self.groupPickerVC.delegate = delegate;
}

#pragma mark - 公共实例方法

- (void)show
{
    [[[[UIApplication sharedApplication].windows firstObject] rootViewController] presentViewController:self animated:YES completion:nil];
}

#pragma mark - 自定义私有方法

- (void)initViewController
{
    if (!_groupPickerVC) {
        _groupPickerVC = [[CMPhotoGroupPickerViewController alloc] init];
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:_groupPickerVC];
        NSLog(@"视图的高度是： %f", self.view.bounds.size.height);
        navVC.view.frame = self.view.bounds;
        [self addChildViewController:navVC];
        [self.view addSubview:navVC.view];
    }
}

- (void)configView
{
    self.view.backgroundColor = kAppThemeSecondaryColor;
}

- (void)configNotification
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:PICKER_TAKE_DONE object:nil];
    });
}

- (void)done:(NSNotification*)note
{
    NSLog(@"接受到了完成时间");
    //    [self dismissViewControllerAnimated:YES completion:nil];
    NSArray* selectArray = note.userInfo[@"selectAssets"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(pickerViewControllerDoneAsstes:)]) {
            [self.delegate pickerViewControllerDoneAsstes:selectArray];
        }
        else if (self.callBack) {
            self.callBack(selectArray);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
