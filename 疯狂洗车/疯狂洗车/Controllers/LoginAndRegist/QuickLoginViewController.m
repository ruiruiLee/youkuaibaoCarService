//
//  QuickLoginViewController.m
//  优快保
//
//  Created by cts on 15/6/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "QuickLoginViewController.h"
#import "AgreementViewController.h"
#import "WebServiceHelper.h"
#import "UIView+Toast.h"
#import "MBProgressHUD+Add.h"
#import "QuickLoginCheckViewController.h"



@interface QuickLoginViewController ()
{
    UIButton *_backButton;
    
}

@property (strong, nonatomic) QuickLoginCheckViewController *viewController;

@end

@implementation QuickLoginViewController

+ (id)sharedLoginByCheckCodeViewControllerWithProtocolEnable:(id)target
{
    static UINavigationController *navi = nil;
    static QuickLoginViewController *viewController = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        viewController = [[QuickLoginViewController alloc] initWithNibName:@"QuickLoginViewController"
                                                                    bundle:nil];

        navi = [[UINavigationController alloc] initWithRootViewController:viewController];
        
    });

    
    return navi;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"快捷登录"];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_login_close"]
                           forState:UIControlStateNormal];
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_backButton setFrame:CGRectMake(20, 35, 18, 18)];
    [_backButton addTarget:self action:@selector(backBtnPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    
    _inputView.layer.masksToBounds = YES;
    _inputView.layer.cornerRadius = 5;
    _inputView.layer.borderWidth = 0.7;
    _inputView.layer.borderColor = [UIColor colorWithRed:204.0/255.0
                                                   green:204.0/255.0
                                                    blue:204.0/255.0
                                                   alpha:0.5].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoginSuccessed)
                                                 name:kLoginByCheckCodeSuccessNotifaction
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanUpSubController)
                                                 name:@"CleanUpSubController"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self closeKeyBoard];

}

/****************************************
 ****************************************
 **                                    **
 ** 上线打包使用，发送真实验证码            **
 **                                    **
 ****************************************
 ****************************************/

- (IBAction)didSubmitButtonTouch:(id)sender
{
    [self closeKeyBoard];
    
    if (!_mobileField.text || [_mobileField.text length] == 0)
    {
        [self.view makeToast:@"请输入您的手机号"];
        return;
    }
    if (_mobileField.text.length < 11)
    {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    else if (self.viewController == nil || ![_mobileField.text isEqualToString:self.viewController.mobile])
    {
        self.view.userInteractionEnabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *submitDic = @{@"phone":_mobileField.text,
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
                 [MBProgressHUD showSuccess:@"验证码获取成功!" toView:[[[UIApplication sharedApplication] delegate] window]];
                 
                 self.viewController = [[QuickLoginCheckViewController alloc] initWithNibName:@"QuickLoginCheckViewController"
                                                                                       bundle:nil];
                 self.viewController.mobile = _mobileField.text;
                 [self.navigationController pushViewController:self.viewController animated:YES];
             }
             else
             {
                 [MBProgressHUD hideAllHUDsForView:self.view
                                          animated:YES];
                 [MBProgressHUD showError:@"获取验证码失败"
                                   toView:self.view];
             }
             self.view.userInteractionEnabled = YES;
         }
                                exceptionResponse:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view
                                      animated:YES];

             [MBProgressHUD showError:[error domain]
                               toView:[[[UIApplication sharedApplication] delegate] window]];

             self.view.userInteractionEnabled = YES;
             if (self.viewController == nil)
             {
                 self.viewController = [[QuickLoginCheckViewController alloc] initWithNibName:@"QuickLoginCheckViewController"
                                                                                       bundle:nil];
             }
             self.viewController.mobile = _mobileField.text;
             [self.navigationController pushViewController:self.viewController animated:YES];
         }];
    }
    else
    {
        self.viewController.mobile = _mobileField.text;
        [self.navigationController pushViewController:self.viewController animated:YES];
    }
}


/****************************************
 ****************************************
 **                                    **
 ** 测试登陆使用不发送真实验证码            **
 **                                    **
 ****************************************
 ****************************************/

//- (IBAction)didSubmitButtonTouch:(id)sender
//{
//    [self closeKeyBoard];
//    
//    if (!_mobileField.text || [_mobileField.text length] == 0)
//    {
//        [self.view makeToast:@"请输入您的手机号"];
//        return;
//    }
//    if (_mobileField.text.length < 11)
//    {
//        [self.view makeToast:@"请输入正确的手机号"];
//        return;
//    }
//    else if (self.viewController == nil || ![_mobileField.text isEqualToString:self.viewController.mobile])
//    {
//
//    }
//    else
//    {
//    }
//    if (self.viewController == nil)
//    {
//        self.viewController = [[QuickLoginCheckViewController alloc] initWithNibName:@"QuickLoginCheckViewController"
//                                                                              bundle:nil];
//    }
//    self.viewController.mobile = _mobileField.text;
//    [self.navigationController pushViewController:self.viewController animated:YES];
//}




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

- (IBAction)didAgreementButtonTouch:(id)sender
{
    AgreementViewController *viewController = [[AgreementViewController alloc] initWithNibName:@"AgreementViewController"
                                                                                        bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didLoginSuccessed
{
    _mobileField.text = @"";
}

- (void)cleanUpSubController
{
    self.viewController = nil;
}

#pragma mark - UITextFieldDelegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _mobileField)
    {
        if ([textField.text length] >= 11)
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
        else if (textField.text.length + string.length == 11)
        {
            textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            [self closeKeyBoard];
            return NO;
        }
        else
        {
            return YES;
        }

    }
    return YES;
}



- (void)backBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginByCheckCodeSuccessNotifaction
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CleanUpSubController"
                                                  object:nil];
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
