//
//  CMCameraViewController.m
//  POICollect
//  照相机的控制器
//  Created by 常敏 on 15/6/29.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "CMCameraViewController.h"
#import "CMCamera.h"
#import "CMCameraView.h"

static const CGFloat Toolbar_Bottom_Height = 60;

@interface CMCameraViewController () <CMCameraViewDelegate>

//AVFoundation
@property (nonatomic, strong) AVCaptureSession* session;
@property (nonatomic, strong) AVCaptureStillImageOutput* captureOutput;
@property (nonatomic, strong) AVCaptureDevice* device;

@property (nonatomic, strong) AVCaptureDeviceInput* input;
@property (nonatomic, strong) AVCaptureMetadataOutput* output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@property (nonatomic, strong) CMComplete complete;

@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) UIView* controlView;
@property (nonatomic, strong) CMCameraView* cameraView;

@property (nonatomic, strong) CMCamera* currentCameraImage;

@end

@implementation CMCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self configView];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

#pragma mark - 私有自定义方法

- (void)configData
{
    //创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary* outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.captureOutput setOutputSettings:outputSettings];
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.captureOutput]) {
        [self.session addOutput:self.captureOutput];
    }
}

- (void)configView
{
    [self configCameraView];
    [self configToolView];
}

- (void)configCameraView
{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.bounds;
    }

    if (!_cameraView) {
        _cameraView = [[CMCameraView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 40 - Toolbar_Bottom_Height)];
        _cameraView.backgroundColor = [UIColor clearColor];
        _cameraView.delegate = self;
        [self.view addSubview:_cameraView];
        [self.view.layer insertSublayer:_previewLayer atIndex:0];
    }
}

- (void)configToolView
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    CGFloat btnWidth = 50;
    CGFloat btnMargin = 20;

    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40);
        [self.view addSubview:_topView];
    }

    UIButton* devicebtn = [self getButtonWithImageName:@"xiang" withPositionX:self.view.frame.size.width - btnMargin - btnWidth];
    [devicebtn addTarget:self action:@selector(deviceBtnTaped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton* flashBtn = [self getButtonWithImageName:@"shanguangdeng" withPositionX:10];
    [flashBtn addTarget:self action:@selector(flashBtnTaped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton* cloaseFlashBtn = [self getButtonWithImageName:@"shanguangdeng2" withPositionX:60];
    [cloaseFlashBtn addTarget:self action:@selector(closeFlashBtnTaped:) forControlEvents:UIControlEventTouchUpInside];

    if (!_controlView) {
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - Toolbar_Bottom_Height, CGRectGetWidth(self.view.frame), Toolbar_Bottom_Height)];
        _controlView.backgroundColor = [UIColor clearColor];
        _controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    }

    UIView* contentView = [[UIView alloc] init];
    contentView.frame = _controlView.bounds;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.3f;
    [_controlView addSubview:contentView];

    CGFloat x = (CGRectGetWidth(self.view.frame) - btnWidth) / 3.f;

    UIButton* cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(btnMargin, 0, x, _controlView.frame.size.height);
    [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancalBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:cancalBtn];

    UIButton* camerabtn = [UIButton buttonWithType:UIButtonTypeCustom];
    camerabtn.frame = CGRectMake(btnMargin + x, btnMargin / 4.f, x, _controlView.frame.size.height - btnMargin / 2.f);
    camerabtn.showsTouchWhenHighlighted = YES;
    camerabtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [camerabtn setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [camerabtn addTarget:self action:@selector(cameraBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:camerabtn];

    UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 2 * btnMargin - btnWidth, 0, btnWidth, _controlView.frame.size.height);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:doneBtn];

    [self.view addSubview:_controlView];
}

- (UIButton*)getButtonWithImageName:(NSString*)imageName withPositionX:(CGFloat)positionX
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(positionX, 0, 50, self.topView.frame.size.height);
    [self.view addSubview:button];
    return button;
}

- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice* device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (UIImage*)fixOrientation:(UIImage*)srcImage
{
    if (srcImage.imageOrientation == UIImageOrientationUp) {
        return srcImage;
    }

    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, srcImage.size.width, srcImage.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, srcImage.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, srcImage.size.width, 0);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;

    case UIImageOrientationUp:
    case UIImageOrientationUpMirrored:
        transform = CGAffineTransformTranslate(transform, srcImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    }

    switch (srcImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, srcImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, srcImage.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    case UIImageOrientationUp:
    case UIImageOrientationDown:
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
        break;
    }

    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImage.size.width, srcImage.size.height, CGImageGetBitsPerComponent(srcImage.CGImage), 0, CGImageGetColorSpace(srcImage.CGImage), CGImageGetBitmapInfo(srcImage.CGImage));

    CGContextConcatCTM(ctx, transform);
    switch (srcImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        CGContextDrawImage(ctx, CGRectMake(0, 0, srcImage.size.width, srcImage.size.height), srcImage.CGImage);
        break;

    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, srcImage.size.width, srcImage.size.height), srcImage.CGImage);
        break;
    }

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage:cgImage];
    CGContextRelease(ctx);
    CGImageRelease(cgImage);
    return img;
}

- (void)captureImage
{
    AVCaptureConnection* videoConnection = nil;
    for (AVCaptureConnection* connection in self.captureOutput.connections) {
        for (AVCaptureInputPort* port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }

    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                    completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError* error) {
                                                        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);

                                                        if (exifAttachments) {
                                                        }

                                                        NSData* imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                        UIImage* t_image = [UIImage imageWithData:imageData];

                                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                            NSData* data;
                                                            if (UIImagePNGRepresentation(t_image) == nil) {
                                                                data = UIImageJPEGRepresentation(t_image, 1.0);
                                                            }
                                                            else {
                                                                data = UIImagePNGRepresentation(t_image);
                                                            }
                                                        });

                                                        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                                                        formater.dateFormat = @"yyyyMMddHHmmss";
                                                        NSString* currentTimeStr = [[formater stringFromDate:[NSDate date]] stringByAppendingFormat:@"_%d", arc4random_uniform(10000)];

                                                        t_image = [self fixOrientation:t_image];

                                                        NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:currentTimeStr];

                                                        [UIImagePNGRepresentation(t_image) writeToFile:path atomically:YES];

                                                        NSData* data = UIImageJPEGRepresentation(t_image, 0.3);
                                                        if (!_currentCameraImage) {
                                                            _currentCameraImage = [[CMCamera alloc] init];
                                                        }
                                                        _currentCameraImage.imagePath = path;
                                                        _currentCameraImage.thumbImage = [UIImage imageWithData:data];

                                                    }];
}

- (void)captureAnimation
{
    UIView* maskView = [[UIView alloc] init];
    maskView.frame = self.view.bounds;
    maskView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maskView];
    [UIView animateWithDuration:0.5f
        animations:^{
            maskView.alpha = 0;
        }
        completion:^(BOOL finished) {
            [maskView removeFromSuperview];
        }];
}

- (void)showCaptureImage
{
    //    CMPhotoPreviewViewController* previewVC = [[CMPhotoPreviewViewController alloc] init];
}

#pragma mark - 共有方法

- (void)startCameraOrPhotoFileWithComplate:(CMComplete)complete
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[[UIApplication sharedApplication].windows firstObject] rootViewController] presentViewController:self animated:YES completion:nil];
        if (complete) {
            self.complete = complete;
        }
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"设备不支持拍照" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alertView show];
    }
}

#pragma mark - 响应事件

- (void)deviceBtnTaped:(id)sender
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];

    NSArray* inputs = self.session.inputs;
    for (AVCaptureDeviceInput* input in inputs) {
        AVCaptureDevice* device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice* newCamera = nil;
            AVCaptureDeviceInput* newInput = nil;
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];

            [self.session beginConfiguration];
            [self.session removeInput:input];
            [self.session addInput:newInput];
            [self.session commitConfiguration];
            break;
        }
    }
}

- (void)flashBtnTaped:(id)sender
{
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOn];
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}

- (void)closeFlashBtnTaped:(id)sender
{
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}

- (void)cancalBtnTaped:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraBtnTaped:(id)sender
{
    [self captureImage];
    [self captureAnimation];
}

- (void)doneBtnTaped:(id)sender
{
    if (self.complete) {
        self.complete(self.currentCameraImage);
    }
    [self cancalBtnTaped:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
