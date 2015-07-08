//
//  MainListTableViewCell.h
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "POIPoint.h"

typedef void (^SelectBlock)(id obj, BOOL selected);

typedef void (^MoreBlock)(id obj);

@interface MainListTableViewCell : UITableViewCell

#pragma mark - 属性

@property (nonatomic, assign) BOOL mEdit;

@property (nonatomic, assign) BOOL mSeledted;

@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic, copy) MoreBlock moreTapBlock;

@property (nonatomic, strong) POIPoint* poiPoint;

#pragma 实例方法

- (void)setTitle:(NSString*)title andSubTitle:(NSString*)subTitle;

- (void)setProgressPersent:(CGFloat)persent;

#pragma mark - 类方法

+ (CGFloat)getSubtitleHeightWithTitle:(NSString*)subTitle;

+ (CGFloat)getCellHeightWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle;

@end
