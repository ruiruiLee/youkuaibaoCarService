//
//  EditPwdController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "EditPwdController.h"
#import "UIView+Toast.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"

@interface EditPwdController ()
{
}

@end

@implementation EditPwdController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"修改密码"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(editDone:)];
    [rightItem setTintColor:kNormalTintColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_oldPwdField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editDone:(id)sender
{
    [self closeKeyBoard];
    if ([_oldPwdField.text isEqualToString:@""] || !_oldPwdField.text)
    {
        [self.view makeToast:@"请输入您当前的密码"];
        return;
    }
    if ([_oldPwdField.text length] < 6)
    {
        [self.view makeToast:@"您当前密码的长度不对"];
        return;
    }
    if ([_newPwdField.text isEqualToString:@""] || !_newPwdField.text)
    {
        [self.view makeToast:@"请输入您的新密码"];
        return;
    }
    if ([_newPwdField.text length] < 6)
    {
        [self.view makeToast:@"新密码必须大于6个字符"];
        return;
    }
    /*
     6.修改密码
     地址：http://118.123.249.87/service/ member_change_password.aspx
     参数:
     op_type(change / find_back)
     member_id:change时必须输入
     old_password: change时必须输入
     phone:find_back时必须输入
     new_password:新密码
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonOperationWithParam:@{@"op_type": @"change",
                                                @"member_id": _userInfo.member_id,
                                                @"old_password": _oldPwdField.text,
                                                @"new_password": _newPwdField.text}
                                       action:@"member_change_password"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Constants showMessage:@"恭喜您，密码修改成功，请重新登录！" delegate:self];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [[NSNotificationCenter defaultCenter]postNotificationName:kLogoutSuccessNotifaction
                                                            object:nil];
         
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
     }];
}

- (IBAction)showOrHidePwd:(id)sender
{
    if ([_oldPwdField isSecureTextEntry])
    {
        [_oldPwdField setSecureTextEntry:NO];
        [_newPwdField setSecureTextEntry:NO];
        [sender setSelected:YES];
    }
    else
    {
        [_oldPwdField setSecureTextEntry:YES];
        [_newPwdField setSecureTextEntry:YES];
        [sender setSelected:NO];
    }
}

#pragma mark - closeKeyBoard

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
