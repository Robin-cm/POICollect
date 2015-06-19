//
//  CMRoundSegmentedThumb.h
//  POICollect
//
//  Created by 常敏 on 15-6-19.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMRoundSegmentedThumb : UIView

@property (nonatomic, strong) UIColor* mThumbTintColor;
@property (nonatomic, strong) UIColor* mThumbBackgroundColor;

@property (nonatomic, readonly, getter=firstLabel) UILabel* mFirstLabel;
@property (nonatomic, readonly, getter=secendLabel) UILabel* mSecendLabel;

@property (nonatomic) UIFont* mFont;

- (void)setTitle:(NSString*)title;
- (void)setSecondTitle:(NSString*)title;

- (void)activate;

- (void)deactivate;

@end
