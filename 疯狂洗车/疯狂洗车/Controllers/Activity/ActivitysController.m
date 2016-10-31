//
//  ActivitysContrller.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ActivitysController.h"
#import "WebServiceHelper.h"
#import "UIView+Toast.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "ShareMenuView.h"
#import "CarWashOrderViewController.h"
#import "CarServiceDetailViewController.h"
#import "CallMethodModel.h"
#import "PayHelper.h"
#import "UnionPayResopne.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "OrderSuccessViewController.h"
#import "MyOrdersController.h"


@interface ActivitysController ()<NJKWebViewProgressDelegate,UPPayPluginDelegate>
{
    NJKWebViewProgressView    *_progressView;
    
    NJKWebViewProgress        *_progressProxy;
    
    
    BOOL                       _startLoad;
    
    UIButton                  *_closeButton;

#pragma mark - 原生支付用
    NSString                  *out_trade_no;
    
    int                        _errorTime;
}


@end

@implementation ActivitysController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    _webView.forbidAddMark = self.forbidAddMark;
    if (self.advModel)
    {
    }
    else
    {
        _webView.hidden = YES;
        _noActivityImageView.hidden = NO;
        _noActivityLabel.hidden = NO;
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

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    [self addPayNotifaction];
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
    if (self.titleString)
    {
        [self setTitle:self.titleString];
    }
    if (!_startLoad && self.advModel)
    {
        
        _startLoad = YES;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.advModel.url]]];
        _webView.hidden = NO;
        _noActivityImageView.hidden = YES;
        _noActivityLabel.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    [self removePayNotifaction];
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
    return [self analyseRequestUrlAndOpreation:request.URL.relativeString];
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - 登录成功和登出
#pragma mark

- (void)didReceiveLoginSuccessNotification:(NSNotification*)notification
{
    if (self.advModel)
    {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.advModel.url]]];
        _webView.hidden = NO;
        _noActivityImageView.hidden = YES;
        _noActivityLabel.hidden = YES;
    }
    else
    {
        _webView.hidden = YES;
        _noActivityImageView.hidden = NO;
        _noActivityLabel.hidden = NO;
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
    else if ([[[self navigationController] viewControllers] count] > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didCloseButtonTouch
{
    if ([[[self navigationController] viewControllers] count] > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (BOOL)analyseRequestUrlAndOpreation:(NSString*)urlString
{
    BOOL boolResult = YES;
    if ([urlString rangeOfString:@"PLEASE_LOGIN"].location != NSNotFound)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        boolResult = NO;
    }
    else if ([urlString rangeOfString:@"shareReceive"].location != NSNotFound)
    {
        [self loadShareContentWithTargetUrlString:urlString];
        boolResult = NO;
    }
    else if ([urlString rangeOfString:@"CALL_METHOD"].location != NSNotFound)
    {
        NSString *encodedString = [urlString stringByRemovingPercentEncoding];
        [self loadMethodCallStringWithUrlString:encodedString];
        boolResult = NO;
    }
    return boolResult;
}

- (void)loadMethodCallStringWithUrlString:(NSString*)targetUrlString
{
    if (targetUrlString == nil)
    {
        [Constants showMessage:@"数据错误，无法操作"];
        return;
    }
    NSRange CALL_METHODRange = [targetUrlString rangeOfString:@"CALL_METHOD="];
    NSString *respoeString = [targetUrlString substringWithRange:NSMakeRange(CALL_METHODRange.location+CALL_METHODRange.length, targetUrlString.length-(CALL_METHODRange.location+CALL_METHODRange.length))];
    NSData *respineData = [respoeString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:respineData options:NSJSONReadingMutableLeaves error:nil];
    CallMethodModel *model = [[CallMethodModel alloc] initWithDictionary:jsonDict];
    model.params = [jsonDict objectForKey:@"params"];
    if (model.callMethodType == CallMethodTypeCarWash)
    {
        if (model.callMethodControllerType == CallMethodControllerTypeDetail)
        {
            NSDictionary *submitDic =  @{@"car_wash_id":[model.params objectForKey:@"car_wash_id"],
                                         @"service_type":[model.params objectForKey:@"service_type"],
                                         @"super_service":@"0"};
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.view.userInteractionEnabled = NO;
            [WebService requestJsonOperationWithParam:submitDic
                                               action:@"carWash/service/detail"
                                       normalResponse:^(NSString *status, id data)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 self.view.userInteractionEnabled = YES;
                 if (status.intValue > 0 && ![data isKindOfClass:[NSNull class]])
                 {
                     CarWashModel *model = [[CarWashModel alloc] initWithDictionary:data];
                     CarWashOrderViewController *controller = ALLOC_WITH_CLASSNAME(@"CarWashOrderViewController");
                     controller.carWashInfo = model;
                     [self.navigationController pushViewController:controller animated:YES];
                 }
                 else
                 {
                     [Constants showMessage:@"获取车场信息失败"];
                 }
             }
                                    exceptionResponse:^(NSError *error)
             {
                 [MBProgressHUD hideAllHUDsForView:self.view
                                          animated:YES];
                 self.view.userInteractionEnabled = YES;
                 [MBProgressHUD showError:[error domain]
                                   toView:self.view];
             }];
        }
    }
    else if (model.callMethodType == CallMethodTypeThirdPay)
    {
        if (model.callMethodControllerType == CallMethodControllerTypeWeChatPay)
        {
            
            [PayHelper submitPayRequestToWeChat:model.params];
        }
        else if (model.callMethodControllerType == CallMethodControllerTypeAliPay)
        {
            [PayHelper submitPayRequestToAliPay:model.params];
        }
        else if (model.callMethodControllerType == CallMethodControllerTypeUnionPay)
        {
            UnionPayResopne *payRespone = [[UnionPayResopne alloc] initWithDictionary:model.params];
            [PayHelper setUnionPayOutTradeNo:payRespone.out_trade_no];
            [UPPayPlugin startPay:payRespone.trade_no
                             mode:payRespone.mode
                   viewController:self
                         delegate:self];
        }

    }
}

#pragma mark - 支付相关

- (void)addPayNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paySuccess:)
                                                 name:kPaySuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxPaySuccess:)
                                                 name:kWXPaySuccessNotification
                                               object:nil];
}

- (void)removePayNotifaction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kPaySuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kWXPaySuccessNotification
                                                  object:nil];
}

- (void)paySuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.object;
    
    if (![[userInfo valueForKey:@"resultStatus"] isEqualToString:@"9000"])
    {
        [Constants showMessage:[userInfo valueForKey:@"memo"]];
        if ([[userInfo valueForKey:@"resultStatus"] isEqualToString:@"6001"])
        {
            [_appDelegate submitUserCancelPayOpreationWithOutTradeNo:_aliPayOutTradeNo];
        }
    }
    else
    {
        if (bIsiOS7)
        {
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
            {
                [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
            }
            else
            {
                [Constants showMessage:@"订单支付成功！"];
            }
        }
        else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
        {
            [Constants showMessage:@"订单支付成功！"];
        }
        else
        {
            [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
        }
        NSString *resultStr = [userInfo valueForKey:@"result"];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSArray *arr = [resultStr componentsSeparatedByString:@"&"];
        for (NSString *tmpStr in arr)
        {
            if ([tmpStr rangeOfString:@"out_trade_no"].location != NSNotFound)
            {
                out_trade_no = _aliPayOutTradeNo;
                _errorTime = 0;
                [MBProgressHUD showMessag:@"正在查询订单信息" toView:self.view];
                self.view.userInteractionEnabled = NO;
                [self removePayNotifaction];
                [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:out_trade_no afterDelay:3.0];
                break;
                
            }
        }
    }
}

- (void)wxPaySuccess:(NSNotification *)notification
{
    if (bIsiOS7)
    {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
        {
            [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
        }
        else
        {
            [Constants showMessage:@"订单支付成功！"];
        }
    }
    else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
    {
        [Constants showMessage:@"订单支付成功！"];
    }
    else
    {
        [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
    }
    [self removePayNotifaction];
    _errorTime = 0;
    [MBProgressHUD showMessag:@"正在查询订单信息"
                       toView:self.view];
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(checkPayOrderWithOutTradeNo:)
               withObject:notification.object afterDelay:3.0];
}

- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"])
    {
        if (bIsiOS7)
        {
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
            {
                [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
            }
            else
            {
                [Constants showMessage:@"订单支付成功！"];
            }
        }
        else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
        {
            [Constants showMessage:@"订单支付成功！"];
        }
        else
        {
            [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
        }
        _errorTime = 0;
        [MBProgressHUD showMessag:@"正在查询订单信息" toView:self.view];
        self.view.userInteractionEnabled = NO;
        [self removePayNotifaction];
        [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:[PayHelper getUnionPayOutTradeNo] afterDelay:3.0];
    }
    else if ([result isEqualToString:@"fail"])
    {
        [Constants showMessage:@"支付失败"];
    }
    else
    {
        [Constants showMessage:@"支付取消"];
        [_appDelegate submitUserCancelPayOpreationWithOutTradeNo:[PayHelper getUnionPayOutTradeNo]];
        
    }
    
}

- (void)checkPayOrderWithOutTradeNo:(NSString*)string
{
    NSDictionary *submitDic = @{@"out_trade_no":string};
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"third/pay/checkPay"
                               normalResponse:^(NSString *status, id data)
     {
         NSLog(@"third/pay/checkPay %@",data);
         self.view.userInteractionEnabled = YES;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
         [tmpArray removeLastObject];
         if ([_appconfig.open_share_order_flag isEqualToString:@"1"])
         {
             OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                                       bundle:nil];
             
             viewController.share_order_url = [data objectForKey:@"share_order_url"];
             viewController.isClubController = self.isClubController;
             
             [tmpArray addObject:viewController];
         }
         else
         {
             MyOrdersController *viewController = [[MyOrdersController alloc] initWithNibName:@"MyOrdersController" bundle:nil];
             [tmpArray addObject:viewController];
         }
         [self.navigationController setViewControllers:tmpArray animated:YES];
         
     }
                            exceptionResponse:^(NSError *error)
     {
         if (_errorTime < 3)
         {
             _errorTime++;
             [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:string afterDelay:3.0];
         }
         else
         {
             self.view.userInteractionEnabled = YES;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
             [self addPayNotifaction];
         }
         
     }];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessNotifaction object:nil];
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
