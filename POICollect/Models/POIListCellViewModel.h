//
//  POIListCellViewModel.h
//  POICollect
//
//  Created by 常敏 on 15/7/9.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class POIPoint;
@class MainListTableViewCell;

@interface POIListCellViewModel : NSObject

@property (nonatomic, strong) POIPoint* point;

@property (nonatomic, strong) MainListTableViewCell* cellView;

#pragma mark - 方法

- (instancetype)initListCellViewModelWith:(POIPoint*)point;

- (instancetype)initListCellViewModelWith:(POIPoint*)Point andCellView:(MainListTableViewCell*)cellView;

#pragma mark - 公共方法

/**
 *  是不是和point相等
 *
 *  @param point 点信息
 *
 *  @return 是否相等
 */
- (BOOL)equalsToPoipoint:(POIPoint*)point;

@end
