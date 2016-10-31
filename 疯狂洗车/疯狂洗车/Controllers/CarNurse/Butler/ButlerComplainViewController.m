//
//  FeedBackController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerComplainViewController.h"
#import "UIView+Toast.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "MyOrdersController.h"
#import "OrderSuccessViewController.h"
#import "MyOrdersController.h"

@interface ButlerComplainViewController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
}

@end

@implementation ButlerComplainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"投诉"];
    
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 3;
    
    [_feedBackTextView setPlaceholder:@"请输入您投诉的内容"];
    
    [[_submitBtn layer] setCornerRadius:3.0];
    [[_submitBtn layer] setMasksToBounds:YES];
    
    [[_feedBackTextViewBg layer] setCornerRadius:5.0];
    [[_feedBackTextViewBg layer] setMasksToBounds:YES];
    [[_feedBackTextViewBg layer] setBorderColor:[[UIColor colorWithRed:204/255.0
                                                                 green:204/255.0
                                                                  blue:204/255.0
                                                                 alpha:1.0] CGColor]];
    [[_feedBackTextViewBg layer] setBorderWidth:1.0];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeKeyBoard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitFeedBack:(id)sender
{
    [self closeKeyBoard];
    if ([_feedBackTextView.text isEqualToString:@""] || !_feedBackTextView.text)
    {
        [self.view makeToast:@"请输入您投诉的内容"];
        return;
    }
    if (_feedBackTextView.text.length < 5)
    {
        [self.view makeToast:@"您输入的投诉内容过短，至少5个字哦"];
        return;
    }
    if (_feedBackTextView.text.length > 200)
    {
        [self.view makeToast:@"您输入的内容过长，请控制在200字以内哦"];
        return;
    }
    [Constants showMessage:@"确认提交投诉？" delegate:self tag:537 buttonTitles:@"取消",@"确定", nil];
    }


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 537 && buttonIndex == 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        
        NSDictionary *submitDic = @{@"car_wash_id":_userButlerOrder.car_wash_id,
                                    @"order_id":_userButlerOrder.order_id,
                                    @"member_id":_userInfo.member_id,
                                    @"content":_feedBackTextView.text};
        
        [WebService requestJsonOperationWithParam:submitDic
                                           action:@"complaint/service/order/new"
                                   normalResponse:^(NSString *status, id data)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             [Constants showMessage:@"提交成功"];
             
             [self.navigationController popViewControllerAnimated:YES];
         }
                                exceptionResponse:^(NSError *error) {
                                    [MBProgressHUD hideAllHUDsForView:self.view
                                                             animated:YES];
                                    [MBProgressHUD showError:[error domain]
                                                      toView:self.view];
                                }];

    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark UIGestureRecognizer Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] ||
        [touch.view isKindOfClass:[UITextView class]])
    {
        return NO;
    }
    return YES;
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
