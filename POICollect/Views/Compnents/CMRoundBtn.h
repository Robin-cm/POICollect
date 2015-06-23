//
//  CMRoundBtn.h
//  POICollect
//  圆形按钮
//  Created by 常敏 on 15-6-23.
//  Copyright (c) 2015年 cm. All rights reserved.
//

typedef enum {
    TYPE_ADD = 1,
    TYPE_CLOSE = 2,
    TYPE_PLAY = 3,
    TYPE_PAUSE = 4,
    TYPE_STOP = 5
} CMRoundBtnType;

@interface CMRoundBtn : UIButton

#pragma mark - 属性

@property (nonatomic, copy) UIColor* normalBackgroundColor;

@property (nonatomic, copy) UIColor* normalForegroundColor;

@property (nonatomic, assign, readonly) CMRoundBtnType currentBtnType;

#pragma mark - 初始化方法

- (id)initRoundBtnWithBtnType:(CMRoundBtnType)btnType;

- (id)initRoundBtnWithFrame:(CGRect)frame andBtnType:(CMRoundBtnType)btnType;

- (id)initRoundBtnWithBtnType:(CMRoundBtnType)btnType andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor;

- (id)initRoundBtnWithFrame:(CGRect)frame andWithBtnType:(CMRoundBtnType)btnType andBackgroundColor:(UIColor*)backgroundColor andForegroundColor:(UIColor*)foregroundColor;

@end
