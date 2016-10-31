//
//  InsuranceViewController.m
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceViewController.h"
#import "InsuranceSubmitViewController.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "InsuranceListViewController.h"
#import "InsuranceSelectViewController.h"
#import "ADVModel.h"
#import "ActivitysController.h"
#import "InsuranceHelper.h"

@interface InsuranceViewController ()<UIAlertViewDelegate>
{
    UIScrollView  *_contextScrollView;
}

@end

@implementation InsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"保险"];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    float insuranceImageViewHeight = SCREEN_WIDTH;
    float insuranceButtonHeight = 40;
    float insuranceCompanyImageViewHeight = 26;
    float paddingHeight = SCREEN_HEIGHT == 480?20:(SCREEN_HEIGHT - 64 - 49 - insuranceImageViewHeight - insuranceButtonHeight - insuranceCompanyImageViewHeight)/3.0;
    
    if (SCREEN_HEIGHT == 480)
    {
        _contextScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [_contextScrollView setBackgroundColor:[UIColor clearColor]];
        [_contextScrollView setContentSize:CGSizeMake(SCREEN_WIDTH,
                                                      insuranceImageViewHeight+insuranceButtonHeight+insuranceCompanyImageViewHeight+paddingHeight*3+49)];
        [self.view addSubview:_contextScrollView];
    }
    
    _insuranceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];

    
    _insuranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _insuranceButton.frame = CGRectMake(10, _insuranceImageView.frame.origin.y+_insuranceImageView.frame.size.height+paddingHeight, SCREEN_WIDTH - 20, 40);
    [_insuranceButton setTitle:@"保险算价" forState:UIControlStateNormal];
    [_insuranceButton setBackgroundColor:[UIColor colorWithRed:55/255.0
                                                         green:129/255.0
                                                          blue:241/255.0
                                                         alpha:1.0]];
    _insuranceButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_insuranceButton addTarget:self
                         action:@selector(didCheckInsuranceButtonTouch:)
               forControlEvents:UIControlEventTouchUpInside];
    _insuranceButton.layer.masksToBounds = YES;
    _insuranceButton.layer.cornerRadius = 5;
    
    _insuranceCompanyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-297/2,
                                                                               _insuranceButton.frame.origin.y+_insuranceButton.frame.size.height+paddingHeight,
                                                                               297,
                                                                               26)];
    [_insuranceCompanyImageView setImage:[UIImage imageNamed:@"img_insurance_supportCompany"]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _insuranceImageView.frame.size.height, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204/255.0
                                               green:204/255.0
                                                blue:204/255.0
                                               alpha:0.5];
    
    
    UIButton *insuranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    insuranceButton.frame = _insuranceImageView.bounds;
    
    [insuranceButton addTarget:self
                        action:@selector(didTouchInsuranceImageButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [_insuranceImageView addSubview:insuranceButton];
    _insuranceImageView.userInteractionEnabled = YES;
    
    if (!_contextScrollView)
    {
        [self.view addSubview:_insuranceImageView];
        [self.view addSubview:lineView];
        [self.view addSubview:_insuranceButton];
        [self.view addSubview:_insuranceCompanyImageView];
    }
    else
    {
        [_contextScrollView addSubview:_insuranceImageView];
        [_contextScrollView addSubview:lineView];
        [_contextScrollView addSubview:_insuranceButton];
        [_contextScrollView addSubview:_insuranceCompanyImageView];
    }
    
    
    
    [self.navigationItem setLeftBarButtonItem:nil];
    




    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLoginSuccessNotification:)
                                                 name:kLoginSuccessNotifaction
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLoginSuccessNotification:)
                                                 name:kLogoutSuccessNotifaction
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_insuranceHomeModel)
    {
        self.view.userInteractionEnabled = NO;
        [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
            self.view.userInteractionEnabled = YES;
            [self setUpInsuranceView];
            
        }
                                               exceptionResponse:^{
                                                   self.view.userInteractionEnabled = YES;
                                                   [Constants showMessage:@"数据错误，无法加载"];
                                               }];
    }
    else
    {
        [self setUpInsuranceView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)setUpInsuranceView
{
    if (_insuranceHomeModel.is_used.intValue > 0)
    {
        [_insuranceButton setTitle:@"继续试算" forState:UIControlStateNormal];

    }
    else
    {
        [_insuranceButton setTitle:@"保险试算" forState:UIControlStateNormal];

    }
    if (!_insuranceHomeModel.intro_url)
    {
        [Constants showMessage:@"数据错误，无法加载"];
    }
    else
    {
        [_insuranceImageView sd_setImageWithURL:[NSURL URLWithString:_insuranceHomeModel.adv_img_url]
                               placeholderImage:[UIImage imageNamed:@"img_insurance_home_default"]];
        
        
    }
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
- (IBAction)didTouchInsuranceImageButton:(id)sender
{
    if (!_insuranceHomeModel.intro_url)
    {
        [Constants showMessage:@"数据错误，无法加载"];
    }
    else
    {
        ADVModel *headerModel = [[ADVModel alloc] init];
        headerModel.url = _insuranceHomeModel.intro_url;
        ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController" bundle:nil];
        viewController.advModel = headerModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }


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
    [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
        [self setUpInsuranceView];
    }
                                           exceptionResponse:^{
        
    }];
}

- (void)didRightButtonTouch
{
    InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController" bundle:nil];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLogoutSuccessNotifaction
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
