//
//  POIListCellViewModel.m
//  POICollect
//
//  Created by 常敏 on 15/7/9.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIListCellViewModel.h"
#import "POIPoint.h"

@implementation POIListCellViewModel

#pragma mark - 方法

- (instancetype)initListCellViewModelWith:(POIPoint*)point
{
    return [self initListCellViewModelWith:point andCellView:nil];
}

- (instancetype)initListCellViewModelWith:(POIPoint*)Point andCellView:(MainListTableViewCell*)cellView
{
    self = [super init];
    if (self) {
        self.point = Point;
        self.cellView = cellView;
    }
    return self;
}

#pragma mark - 公共方法

/**
 *  是不是和point相等
 *
 *  @param point 点信息
 *
 *  @return 是否相等
 */
- (BOOL)equalsToPoipoint:(POIPoint*)point
{
    if (!self.point) {
        return NO;
    }
    if (!point) {
        return NO;
    }

    if ([self.point.poiId isEqualToString:point.poiId]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
