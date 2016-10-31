//
//  ShareActivityViewController.m
//  优快保
//
//  Created by cts on 15/6/20.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "ShareActivityViewController.h"
#import "ShareMenuView.h"
#import "UIView+Toast.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"



@interface ShareActivityViewController ()<UINavigationControllerDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView    *_progressView;
    
    NJKWebViewProgress        *_progressProxy;
    
    UIButton                  *_closeButton;
}

@end

@implementation ShareActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_btn"]
             forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 7, 26, 30)];
    [backBtn addTarget:self
                action:@selector(didLeftButtonTouch)
      forControlEvents:UIControlEventTouchUpInside];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_closeButton setFrame:CGRectMake(0, 7, 40, 30)];
    [_closeButton addTarget:self
                action:@selector(didCloseButtonTouch)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:_closeButton];

    _closeButton.hidden = YES;
    
    [self.navigationItem setLeftBarButtonItems:@[backItem,closeItem]];
    
    if (!self.titleString)
    {
        [self setTitle:self.titleString];
    }
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    //顶部进度条
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    if (!_userInfo.member_id)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLoginSuccessNotification:)
                                                     name:kLoginSuccessNotifaction
                                                   object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrlString]]];
    _webView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self setTitle:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    if ([_webView canGoBack])
    {
        _closeButton.hidden = NO;
    }
    else
    {
        _closeButton.hidden = YES;
    }
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress
        updateProgress:(float)progress
{
    [_progressView setProgress:progress
                      animated:YES];
}

#pragma mark - webview

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest %@",request.URL.relativeString);
    if ([request.URL.relativeString rangeOfString:@"PLEASE_LOGIN"].location != NSNotFound)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return NO;
    }
    if ([request.URL.relativeString rangeOfString:@"shareReceive"].location != NSNotFound)
    {
        [self loadShareContentWithTargetUrlString:request.URL.relativeString];
        return NO;
    }
    return YES;
}

- (void)loadShareContentWithTargetUrlString:(NSString*)targetUrlString
{
    if (!_userInfo.member_id)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return;
    }
    NSString *lJs = @"document.documentElement.innerHTML";
    NSString *lHtml1 = [_webView stringByEvaluatingJavaScriptFromString:lJs];
    NSRange beginRange = [lHtml1 rangeOfString:@"><!--share begin "];
    
    NSRange endRange = [lHtml1 rangeOfString:@" share end--><"];
    
    NSString *shareContent = [lHtml1 substringWithRange:NSMakeRange(beginRange.location+17,endRange.location- beginRange.location-17)];
    
    NSError *error = nil;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[shareContent dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    if (dic)
    {
        NSString *shareUrl = [targetUrlString stringByReplacingOccurrencesOfString:@"sourceParams" withString:@"11"];
        
        
        [ShareMenuView showShareMenuViewAtTarget:self
                                     withContent:[dic objectForKey:@"content"]
                                       withTitle:[dic objectForKey:@"title"]
                                    withImageUrl:[dic objectForKey:@"logo"]
                                         withUrl:[shareUrl stringByReplacingOccurrencesOfString:@"markParams"
                                                                                     withString:_userInfo.member_id]];
    }
}

#pragma mark - 登录成功和登出
#pragma mark

- (void)didReceiveLoginSuccessNotification:(NSNotification*)notification
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrlString]]];
}

#pragma mark - 返回首页

- (void)didLeftButtonTouch
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
        return;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didCloseButtonTouch
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessNotifaction object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
