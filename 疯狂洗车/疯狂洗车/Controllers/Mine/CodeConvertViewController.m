//
//  CodeConvertViewController.m
//  优快保
//
//  Created by cts on 15/6/18.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CodeConvertViewController.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "ShareActivityViewController.h"

@interface CodeConvertViewController ()<UIAlertViewDelegate>

@end

@implementation CodeConvertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"礼品兑换"];
    
    _inputView.layer.borderColor = [UIColor colorWithRed:104.0/255.0
                                                   green:104.0/255.0
                                                    blue:104.0/255.0
                                                   alpha:0.5].CGColor;
    _inputView.layer.borderWidth = 0.7;
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSubmitButtonTouch:(id)sender
{
    [self closeKeyBoard];
    if ([_inputField.text isEqualToString:@""] || _inputField.text == nil)
    {
        [Constants showMessage:@"请输入您的兑换码"];
        return;
    }
    else
    {
        NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                    @"code":_inputField.text};
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        [WebService requestJsonOperationWithParam:submitDic
                                           action:@"serviceCode/service/checkCode"
                                   normalResponse:^(NSString *status, id data)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (status.intValue > 0)
            {
                if ([data objectForKey:@"code_action_url"])
                {
                    NSMutableArray  *controllers = [self.navigationController.viewControllers mutableCopy];
                    
                    [controllers removeLastObject];
                    
                    ShareActivityViewController *viewController = [[ShareActivityViewController alloc] initWithNibName:@"ShareActivityViewController"
                                                                                                                bundle:nil];
                    viewController.baseUrlString = [data objectForKey:@"code_action_url"];
                    [controllers addObject:viewController];
                    [self.navigationController setViewControllers:controllers animated:YES];
                }
                else if ([data objectForKey:@"msg"])
                {
                    [Constants showMessage:[data objectForKey:@"msg"] delegate:self tag:590 buttonTitles:@"好的", nil];
                }
                else
                {
                    [Constants showMessage:@"兑换成功" delegate:self tag:590 buttonTitles:@"好的", nil];
                }

            }
            else
            {
                
            }
        }
                            exceptionResponse:^(NSError *error)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [Constants showMessage:[error domain]];
                                return ;
        }];
    }
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 590)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
