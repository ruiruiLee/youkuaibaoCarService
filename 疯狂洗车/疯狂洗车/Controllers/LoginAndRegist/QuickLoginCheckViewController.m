//
//  QuickLoginCheckViewController.m
//  优快保
//
//  Created by cts on 15/6/5.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "QuickLoginCheckViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD+Add.h"

#define recordTotalTime 30

@interface QuickLoginCheckViewController ()<UITextFieldDelegate>
{
    int       _audiioTimerSeconds;
    
    int       _messageTimerSeconds;

    
    NSTimer   *_audioTimer;
    
    NSTimer   *_messageTimer;
}


@end


@implementation QuickLoginCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"输入验证码"];
    
    
    _inputView.layer.borderColor = [UIColor colorWithRed:204/255.0
                                                   green:204/255.0
                                                    blue:204/255.0
                                                   alpha:0.5].CGColor;
    _inputView.layer.borderWidth = 0.7;
    _inputView.layer.masksToBounds = YES;
    _inputView.layer.cornerRadius = 5;
    
    [self startGetMessageCheckCodeAgainTimer];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mobile == nil || [self.mobile isEqualToString:@""])
    {
        
    }
    else
    {
        _titleLabel.text = [NSString stringWithFormat:@"%@",self.mobile];
    }

}

- (IBAction)didSubmitButtonTouch:(id)sender
{
    [self closeKeyBoard];
    

    if (!_checkCodeField.text || [_checkCodeField.text length] == 0) {
        [self.view makeToast:@"请输入验证码"];
        return;
    }
    else
    {
        NSDictionary *tmpDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
        
        
        self.view.userInteractionEnabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *submitDic = @{@"login_name":self.mobile,
                                    @"app_type":@"2",
                                    @"user_type":@"1",
                                    @"app_version":[NSString stringWithFormat:@"%.2f",[[tmpDic valueForKey:@"CFBundleShortVersionString"] floatValue]],
                                    @"verify_code":_checkCodeField.text,
                                    @"client_id":_notificationDeviceToken==nil?@"":_notificationDeviceToken};
        [WebService requestJsonModelWithParam:submitDic
                                       action:@"member/service/login"
                                   modelClass:[UserInfo class]
                               normalResponse:^(NSString *status, id data, JsonBaseModel *model)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (status.intValue > 0)
             {
                 UserInfo *userInfo = (UserInfo *)model;
                 _userInfo = userInfo;
                 _agentModel = [[AgentModel alloc] initWithDictionary:data];
                 _checkCodeField.text = @"";
                 [_messageTimer invalidate];
                 [_audioTimer invalidate];
                 [self resumeGetAudioCheckCodeButton];
                 [self resumeGetMessageCheckCodeButton];
                 
                 if (_userInfo.member_id && [_userInfo.city_id isEqualToString:@""] && _userCityModel)
                 {
                     [_appDelegate.gpsLocationManager setUpUserCity:_userCityModel];
                 }
                 
                 [_appDelegate.gpsLocationManager changeAppConfigSuccessResponse:^{
                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationChange
                                                                         object:nil];
                 }
                                                                    failResponse:^{
                     
                 }];

                 [[NSUserDefaults standardUserDefaults] setObject:@{@"login_name":self.mobile}
                                                           forKey:kAutoLogin];
                 [[NSUserDefaults standardUserDefaults] setObject:[userInfo convertToDictionary]
                                                           forKey:kUserInfoKey];
                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",userInfo.token]
                                                           forKey:kLoginToken];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotifaction
                                                                     object:nil];

                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kLoginByCheckCodeSuccessNotifaction
                                                                     object:nil];
                 [_appDelegate startMSGRefrishTimer];

                 [self dismissViewControllerAnimated:YES
                                          completion:^{
                                              NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
                                              [controllers removeLastObject];
                                              [self.navigationController setViewControllers:controllers animated:NO];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"CleanUpSubController"
                                                                                                  object:nil];
                                              
                                             
                 }];
                 
             }
             else
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"登录失败" toView:self.view];
             }
             self.view.userInteractionEnabled = YES;
         }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view
                                                         animated:YES];
                                [MBProgressHUD showError:[error domain]
                                                  toView:self.view];
                                self.view.userInteractionEnabled = YES;
                                
                            }];
    }

}

- (IBAction)didMessageCodeButtonTouch:(id)sender
{
    [self closeKeyBoard];
    self.view.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *submitDic = @{@"phone":self.mobile,
                                @"verify_type":@"1",
                                @"user_type":@"1",
                                @"code_type":@"1"};
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"code/service/get"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [Constants showMessage:@"获取验证码成功"];
             [self startGetMessageCheckCodeAgainTimer];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"获取短信验证码失败" toView:self.view];
         }
         self.view.userInteractionEnabled = YES;
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view
                                  animated:YES];
         [MBProgressHUD showError:@"服务器无法连接，请稍后再试"
                           toView:self.view];
         self.view.userInteractionEnabled = YES;
     }];
}


- (IBAction)didAudioCodeButtonTouch:(id)sender
{
    [self closeKeyBoard];
    self.view.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *submitDic = @{@"phone":self.mobile,
                                @"verify_type":@"1",
                                @"user_type":@"1",
                                @"code_type":@"2"};
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"code/service/get"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [Constants showMessage:@"请注意接听来电，验证码将使用语音为您播报"];
             [self startGetAudioCheckCodeAgainTimer];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"获取语音验证码失败" toView:self.view];
         }
         self.view.userInteractionEnabled = YES;
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view
                                  animated:YES];
         [MBProgressHUD showError:@"服务器无法连接，请稍后再试"
                           toView:self.view];
         self.view.userInteractionEnabled = YES;
     }];
}

#pragma mark - UITextFieldDelegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _checkCodeField)
    {
        if ([textField.text length] >= 6)
        {
            if ([string isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 语音验证码代码
- (void)startGetAudioCheckCodeAgainTimer
{
    
    [_audioCodeButton setTitle:@"重新获取(30)" forState:UIControlStateNormal];

    _audioCodeButton.userInteractionEnabled  = NO;
    _audiioTimerSeconds = recordTotalTime;
    _audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(recordGetAudioCheckCodeAgain)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)recordGetAudioCheckCodeAgain
{
    if (_audiioTimerSeconds > 0)
    {
        _audiioTimerSeconds--;
        [_audioCodeButton setTitle:[NSString stringWithFormat:@"重新获取(%d)",_audiioTimerSeconds]
                             forState:UIControlStateNormal];
    }
    else
    {
        [_audioTimer invalidate];
        [self resumeGetAudioCheckCodeButton];
    }
    
    
}

- (void)resumeGetAudioCheckCodeButton
{
    [_audioCodeButton setTitle:@"获取语音验证码" forState:UIControlStateNormal];


    _audioCodeButton.userInteractionEnabled = YES;
}

#pragma mark - 短信验证码代码

- (void)startGetMessageCheckCodeAgainTimer
{
    
    [_messageCodeButton setTitle:@"重新获取(30)" forState:UIControlStateNormal];
    
    _messageCodeButton.userInteractionEnabled  = NO;
    _messageTimerSeconds = recordTotalTime;
    _messageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(recordGetMessageCheckCodeAgain)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)recordGetMessageCheckCodeAgain
{
    if (_messageTimerSeconds > 0)
    {
        _messageTimerSeconds--;
        [_messageCodeButton setTitle:[NSString stringWithFormat:@"重新获取(%d)",_messageTimerSeconds]
                          forState:UIControlStateNormal];
    }
    else
    {
        [_messageTimer invalidate];
        [self resumeGetMessageCheckCodeButton];
    }
    
    
}

- (void)resumeGetMessageCheckCodeButton
{
    [_messageCodeButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];


    
    _messageCodeButton.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeKeyBoard];
}

- (void)closeKeyBoard
{
    [[self findFirstResponder:self.view]resignFirstResponder];
}

- (UIView *)findFirstResponder:(UIView*)view
{
    for ( UIView *childView in view.subviews )
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
        {
            return childView;
        }
        UIView *result = [self findFirstResponder:childView];
        if (result) return result;
    }
    return nil;
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
