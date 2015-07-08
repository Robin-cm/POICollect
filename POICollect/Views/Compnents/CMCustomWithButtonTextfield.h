//
//  CMCustomWithButtonTextfield.h
//  POICollect
//  带有按钮的输入框
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

@class CMCustomWithButtonTextfield;

@protocol CMCustomWithButtonTextfieldProtocol <NSObject>

- (void)textfieldDidRightBtnTaped:(CMCustomWithButtonTextfield*)tf;

@end

@interface CMCustomWithButtonTextfield : UITextField

#pragma mark - 属性

@property (nonatomic, weak) id<CMCustomWithButtonTextfieldProtocol> rightBtnDelegate;

@property (nonatomic, strong) UIColor* normalBackgroundColor;
@property (nonatomic, strong) UIColor* highlightBackgroundColor;
@property (nonatomic, strong) UIColor* disableBackgroundColor;

@property (nonatomic, strong) UIColor* normalForegroundColor;
@property (nonatomic, strong) UIColor* highlightForegroundColor;
@property (nonatomic, strong) UIColor* disableForegroundColor;

@property (nonatomic, strong) UIColor* borderColor;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIFont* textFont;

@property (nonatomic, strong) UIImage* rightBtnImage;
@property (nonatomic, strong) UIImage* rightBtnSelectedImage;

#pragma mark - 初始化方法

- (id)initButtonTextfieldWithPlaceholder:(NSString*)palceHolder;

- (id)initButtonTextfieldWithPlaceholder:(NSString*)palceHolder andWithButtonImage:(UIImage*)btnImg andWithSelectedButtonImage:(UIImage*)selectedBtnImg;

@end
