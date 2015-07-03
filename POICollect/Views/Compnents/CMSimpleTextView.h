//
//  CMSimpleTextView.h
//  POICollect
//
//  Created by 敏梵 on 15/6/21.
//  Copyright (c) 2015年 cm. All rights reserved.
//

typedef enum {
    CMSimpleTextFieldTypeEmail = 100,
    CMSimpleTextFieldTypePassword = 101,
    CMSimpleTextFieldTypeNumber = 102,
    CMSimpleTextFieldTypeEnglishOnly = 103,
    CMSimpleTextFieldTypeUserName = 104
} CMSimpleTextFieldType;

@interface CMSimpleTextView : UITextField

#pragma mark - 公共属性

@property (nonatomic, strong) UIColor* borderColor;

@property (nonatomic, strong) UIColor* foucsBorderColor;

@property (nonatomic, strong) UIColor* errorBorderColor;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) CGFloat foucsBorderWidth;

@property (nonatomic, strong) UIFont* normalFont;

@property (nonatomic, strong) UIFont* foucsFont;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) NSString* placeHolder;

@property (nonatomic, assign) CMSimpleTextFieldType cType;

@property (nonatomic, assign) UIImage* icon;

@property (nonatomic, copy, readonly) NSString* error;

#pragma mark - 初始化方法

- (id)initWithPlaceholder:(NSString*)placeholder;

- (id)initWithInputType:(CMSimpleTextFieldType)inputType;

- (id)initWithPlaceholder:(NSString*)placeholder andWithInputType:(CMSimpleTextFieldType)inputType;

- (id)initWithIcon:(UIImage*)icon andWithPlaceholder:(NSString*)placeholder andWithInputType:(CMSimpleTextFieldType)inputType;

- (NSString*)validate;

@end
