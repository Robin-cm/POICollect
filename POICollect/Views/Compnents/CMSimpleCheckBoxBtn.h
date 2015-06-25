//
//  CMSimpleCheckBoxBtn.h
//  POICollect
//  自定义的checkbox按钮
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

typedef enum {
    CMSimpleCheckBoxBtnSize_Large = 0,
    CMSimpleCheckBoxBtnSize_Big = 1,
    CMSimpleCheckBoxBtnSize_Mid = 2,
    CMSimpleCheckBoxBtnSize_Small = 3,
    CMSimpleCheckBoxBtnSize_Tint = 4
} CMSimpleCheckBoxBtnSize;

@interface CMSimpleCheckBoxBtn : UIButton

#pragma mark - 属性

@property (nonatomic, strong) UIImage* normalIco;

@property (nonatomic, strong) UIImage* selectedIco;

@property (nonatomic, strong) UIColor* borderColor;

@property (nonatomic, strong) UIColor* btnBackgroundColor;

@property (nonatomic, strong) UIColor* btnForegroundColor;

@property (nonatomic, assign) CGFloat borderWidth;

#pragma - mark 初始化方法

- (id)initBoxButtonWithSize:(CMSimpleCheckBoxBtnSize)size;

@end
