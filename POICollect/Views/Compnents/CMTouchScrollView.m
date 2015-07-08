//
//  CMTouchScrollView.m
//  POICollect
//  滚动
//  Created by 常敏 on 15/7/8.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMTouchScrollView.h"

@implementation CMTouchScrollView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    CloseKeyBoard;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end
