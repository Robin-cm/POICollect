//
//  TdtWebViewController.m
//  ThtCompanyOC
//  天地图的相关信息的页面
//  Created by 常敏 on 15-1-26.
//  Copyright (c) 2015年 cm. All rights reserved.
//

#import "TdtWebViewController.h"

#import <NJKWebViewProgressView.h>

@interface TdtWebViewController () {
    UIWebView* _webView;
    NJKWebViewProgressView* _progressView;
    NJKWebViewProgress* _progressProxy;
}

@end

@implementation TdtWebViewController

#pragma mark - lifecircle
- (void)viewDidLoad
{
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_progressView removeFromSuperview];
}

#pragma mark - custom functions

- (void)initView
{
    [self setNavigationBarTranslucent:NO];

    UIBarButtonItem* refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBtnClick:)];
    self.navigationItem.rightBarButtonItem = refreshBtn;

    CGRect frame = kScreenBounds;
    frame.size.height -= (kStateBarHeight + kNavBarHeight);
    frame.origin.y += kStateBarHeight + kNavBarHeight;
    _webView = [[UIWebView alloc] initWithFrame:kScreenBounds];
    [self.view addSubview:_webView];

    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;

    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progressBarView.backgroundColor = [UIColor colorWithHexString:@"0x328446"];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    [self loadURL:tdt_about_url];
}

- (void)loadURL:(NSString*)url
{
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
//设置进度条
- (void)webViewProgress:(NJKWebViewProgress*)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - listeners

- (IBAction)closeBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)refreshBtnClick:(id)sender
{
    [_webView reload];
}

@end
