//
//  MainPOIListViewController.h
//  POICollect
//  POI点的列表页面
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "BaseViewController.h"
#import "CMRoundBtn.h"

@interface MainPOIListViewController : BaseViewController

@property (nonatomic, strong, readonly) CMRoundBtn* addPOIBtn;

- (void)hideAddPoiBtnWithAnimate:(BOOL)animate;

- (void)showAddPoiBtnWithAnimate:(BOOL)animate;

@end
