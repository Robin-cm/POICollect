//
//  CMActionSheetView.h
//  POICollect
//
//  Created by 敏梵 on 15/7/5.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class CMActionSheetView;

typedef void (^CMActionSheetDidSelectViewBlock)(CMActionSheetView* cmActionView, NSInteger selectIndex);

@interface CMActionSheetView : UIView <UITableViewDataSource, UITableViewDelegate> {
@private
    UITableView* _tableView;

    UIView* _backView;
    UIView* _showView;
    BOOL _isShow;
}

#pragma mark - 方法

- (instancetype)initWithCancelBtn:(NSString*)cancelTitle andOtherButtonTitles:(NSArray*)otherTitles;

- (void)show;
- (void)hide;
/**
 *  数据源
 */
@property (nonatomic, strong) NSArray* dataSource;

/**
 *  actionSheet 点击回调
 */
@property (nonatomic, copy) CMActionSheetDidSelectViewBlock selectRowBlock;

@property (nonatomic, copy) CMActionSheetDidSelectViewBlock cancelTapBlock;

@end
