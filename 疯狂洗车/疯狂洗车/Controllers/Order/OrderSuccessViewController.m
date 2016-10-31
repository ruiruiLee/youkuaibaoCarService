//
//  OrderSuccessViewController.m
//  优快保
//
//  Created by cts on 15/6/19.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "MyOrdersController.h"
#import "ShareMenuView.h"
#import "CarWashMapViewController.h"
#import "ButlerMapViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"


@interface OrderSuccessViewController ()<NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView    *_progressView;
    
    NJKWebViewProgress        *_progressProxy;
}

@end

@implementation OrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@""];
    
    _webView.delegate = self;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:self.isClubController?[UIImage imageNamed:@"back_club_btn"]:[UIImage imageNamed:@"back_btn"]
             forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 7, 26, 30)];
    [backBtn addTarget:self
                action:@selector(didLeftButtonTouch)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];

    
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
    
    
   //[self getShareOrderAffterPaySuccess];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.share_order_url]]];
    _webView.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress
        updateProgress:(float)progress
{
    [_progressView setProgress:progress
                      animated:YES];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setTitle:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"]];

}

#pragma mark - webview

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest %@",request.URL.relativeString);
    if ([request.URL.relativeString rangeOfString:@"shareReceive"].location != NSNotFound)
    {
        [self loadShareContentWithTargetUrlString:request.URL.relativeString];
        return NO;
    }
    return YES;
}

#pragma mark - 获取活动
#pragma mark

- (void)getShareOrderAffterPaySuccess
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&source = 11",_appconfig.share_code_url]]]];
    _webView.hidden = NO;

}

- (void)loadShareContentWithTargetUrlString:(NSString*)targetUrlString
{
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


#pragma mark - 返回首页

- (void)didLeftButtonTouch
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)URLEncodedString:(NSString*)targetString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)targetString,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
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
