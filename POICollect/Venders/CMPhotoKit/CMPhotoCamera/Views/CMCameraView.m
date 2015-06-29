//
//  CMCameraView.m
//  POICollect
//  相机视图
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "CMCameraView.h"

static NSInteger BQCameraView_Width = 60;

@interface CMCameraView ()

@property (strong, nonatomic) CADisplayLink* link;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) CGPoint point;

@property (nonatomic, assign) BOOL isPlayerEnd;

@end

@implementation CMCameraView

#pragma mark - Getter

- (CADisplayLink*)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshView:)];
    }
    return _link;
}

#pragma mark - 事件相应

- (void)refreshView:(CADisplayLink*)link
{
    [self setNeedsDisplay];
    self.time++;
}

#pragma mark - 系统事件

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (self.isPlayerEnd) {
        return;
    }
    self.isPlayerEnd = YES;
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    self.point = point;
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    if ([self.delegate respondsToSelector:@selector(cameraDidSelected:)]) {
        [self.delegate cameraDidSelected:self];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

#pragma mark - 绘画

- (void)drawRect:(CGRect)rect
{
    // Drawing code

    [super drawRect:rect];

    if (self.isPlayerEnd) {
        CGFloat rectValue = BQCameraView_Width - (self.time % BQCameraView_Width);
        CGRect rectangle = CGRectMake(self.point.x - rectValue / 2.f, self.point.y - rectValue / 2.f, rectValue, rectValue);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (rectValue <= 30) {
            self.isPlayerEnd = NO;
            [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.link = nil;
            self.time = 0;
            CGContextClearRect(ctx, rectangle);
        }
        else {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, rectangle);
            CGContextAddPath(ctx, path);
            [[UIColor colorWithRed:0.2f green:0.6f blue:0.8f alpha:0] setFill];
            [[UIColor yellowColor] setStroke];
            CGContextSetLineWidth(ctx, 1.f);
            CGContextDrawPath(ctx, kCGPathFillStroke);
            CGPathRelease(path);
        }
    }
}

@end
