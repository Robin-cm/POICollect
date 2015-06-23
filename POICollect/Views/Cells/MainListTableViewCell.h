//
//  MainListTableViewCell.h
//  POICollect
//
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainListTableViewCell : UITableViewCell

- (void)setTitle:(NSString*)title andSubTitle:(NSString*)subTitle;

#pragma mark - 类方法

+ (CGFloat)getSubtitleHeightWithTitle:(NSString*)subTitle;

+ (CGFloat)getCellHeightWithTitle:(NSString*)title andSubTitle:(NSString*)subTitle;

@end
