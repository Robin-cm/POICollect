//
//  CMDropdownButton.h
//  POICollect
//  下拉菜单
//  Created by 常敏 on 15-6-25.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMDropdownButton;

@protocol CMDropdownButtonDelegate <NSObject>

@optional
- (void)cmDropdownButton:(CMDropdownButton*)button andSelectedIndex:(NSInteger)index;

@end

@interface CMDropdownButton : UIButton

#pragma mark - 属性

@property (nonatomic, weak) id<CMDropdownButtonDelegate> delegate;

@property (nonatomic, copy) void (^dropdownBtnSelectedChangeBlock)(CMDropdownButton* btn, NSInteger index);

//@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSArray* datas;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIImage* arrowImage;

@property (nonatomic, strong) UIColor* normalBgColor;

@property (nonatomic, strong) UIColor* normalFgColor;

@property (nonatomic, assign) CGFloat cornerRadius;

#pragma mark - 方法

- (id)initDropdownButtonWithTitle:(NSString*)title;

- (id)initDropdownButtonWithTitle:(NSString*)title andWithDatas:(NSArray*)datas;

@end
