//
//  InsuranceViewController.m
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceHomeViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "InsuranceSubmitViewController.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "InsuranceListViewController.h"
#import "InsuranceHelper.h"

@interface InsuranceHomeViewController ()<UIAlertViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView    *_progressView;
    
    NJKWebViewProgress        *_progressProxy;
    
    UIButton                  *_closeButton;

}

@end

@implementation InsuranceHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"车险"];
    
    
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

    
    if (_insuranceHomeModel)
    {
        [self setUpInsuranceView];
    }
    if (!_userInfo.member_id)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLoginSuccessNotification:)
                                                     name:kLoginSuccessNotifaction
                                                   object:nil];
    }
    
    _webView.delegate = self;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];

}

- (void)setUpInsuranceView
{
    if (_insuranceHomeModel.is_used.intValue > 0)
    {
        _insuranceButton.selected = NO;
        [_insuranceButton setTitle:_insuranceHomeModel.btn_text
                          forState:UIControlStateNormal];
        [_insuranceButton setTitle:_insuranceHomeModel.btn_text
                          forState:UIControlStateSelected];
    }
    else
    {
        _insuranceButton.selected = YES;
        [_insuranceButton setTitle:_insuranceHomeModel.btn_text
                          forState:UIControlStateNormal];
        [_insuranceButton setTitle:_insuranceHomeModel.btn_text
                          forState:UIControlStateSelected];
    }
    if (!_insuranceHomeModel.intro_url)
    {
        [Constants showMessage:@"数据错误，无法加载"];
    }
    else
    {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_insuranceHomeModel.intro_url]]];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress
        updateProgress:(float)progress
{
    [_progressView setProgress:progress
                      animated:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    if ([_webView canGoBack])
//    {
//        _closeButton.hidden = NO;
//    }
//    else
//    {
//        _closeButton.hidden = YES;
//    }
}

- (IBAction)didCallButtonTouch:(id)sender
{
    if ([Constants canMakePhoneCall])
    {
        NSString *alertString = [NSString stringWithFormat:@"致电保险客服%@",_insuranceHomeModel.service_phone];
        [Constants showMessage:alertString
                      delegate:self
                           tag:530
                  buttonTitles:@"取消",@"确认", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex == 1)
    {
        [self callCustomService];
    }
}

- (void)callCustomService
{
    NSString *phoneString = [NSString stringWithFormat:@"tel:%@",_insuranceHomeModel.service_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}


- (IBAction)didCheckInsuranceButtonTouch:(id)sender
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
    [InsuranceHelper getDesiredInsuranceControllerResultResponse:^(id targetController)
     {
         [self.navigationController pushViewController:targetController
                                              animated:YES];
     }];

}

- (void)didReceiveLoginSuccessNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginSuccessNotifaction
                                                  object:nil];
    
    [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
        [self setUpInsuranceView];
    }
                                           exceptionResponse:^{
        
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginSuccessNotifaction
                                                  object:nil];
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
