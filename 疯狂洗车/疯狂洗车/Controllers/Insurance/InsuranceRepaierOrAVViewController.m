//
//  InsuranceRepaierOrAVViewController.m
//  
//
//  Created by cts on 15/10/29.
//
//

#import "InsuranceRepaierOrAVViewController.h"
#import "CarReviewModel.h"
#import "WebServiceHelper.h"
#import "InsuranceAVOrderViewController.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Toast.h"
#import "InsuranceRepaierOrderViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"


@interface InsuranceRepaierOrAVViewController ()<UIAlertViewDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView    *_progressView;
    
    NJKWebViewProgress        *_progressProxy;

}

@property (strong, nonatomic) NSString *repair_url;

@property (strong, nonatomic) NSString *repair_contact_phone;


@end

@implementation InsuranceRepaierOrAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.isAVService)
    {
        [self setTitle:@"年检代办"];

    }
    else
    {
        [self setTitle:@"免费理赔送修"];

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.carReviewModel)
    {
        [self getInformationFromService];
    }
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

- (void)getInformationFromService
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.isAVService?self.carReviewModel.car_review_url:self.carReviewModel.repair_url]]];
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
