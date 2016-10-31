//
//  FeedBackController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderCancelMoreViewController.h"
#import "UIView+Toast.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "MyOrdersController.h"
#import "ButlerMapViewController.h"

@interface OrderCancelMoreViewController ()<UIGestureRecognizerDelegate>
{
}

@end

@implementation OrderCancelMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"其它原因"];
    
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 3;
    
    [_feedBackTextView setPlaceholder:@"请输入您取消订单的原因"];
    
    [[_submitBtn layer] setCornerRadius:3.0];
    [[_submitBtn layer] setMasksToBounds:YES];
    
    [[_feedBackTextViewBg layer] setCornerRadius:5.0];
    [[_feedBackTextViewBg layer] setMasksToBounds:YES];
    [[_feedBackTextViewBg layer] setBorderColor:[[UIColor colorWithRed:195/255.0
                                                                green:195/255.0
                                                                 blue:195/255.0
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
        [self.view makeToast:@"请输入您取消订单的原因"];
        return;
    }
    if (_feedBackTextView.text.length < 5)
    {
        [self.view makeToast:@"您输入的原因过短，至少5个字"];
        return;
    }
    if (_feedBackTextView.text.length > 200)
    {
        [self.view makeToast:@"您输入的信息过长，请控制在200字以内"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    OrderDetailModel *info = self.orderModel;
    
    NSDictionary *submitDic = @{@"op_type":@"cancel",
                                @"order_id": info.order_id,
                                @"out_trade_no": info.out_trade_no,
                                @"car_wash_id": info.car_wash_id,
                                @"member_id": info.member_id,
                                @"car_id": info.car_id,
                                @"pay_type": info.pay_type,
                                @"pay_money": info.pay_money,
                                @"reason":_feedBackTextView.text};
    
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"order/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         [Constants showMessage:@"“取消订单”申请成功"];
         id target = nil;
         
         for (id controller in self.navigationController.viewControllers)
         {
             if ([controller isKindOfClass:[ButlerMapViewController class]])
             {
                 target = controller;
                 break;
             }
         }
         if (target == nil)
         {
             for (id controller in self.navigationController.viewControllers)
             {
                 if ([controller isKindOfClass:[MyOrdersController class]])
                 {
                     target = controller;
                     
                 }
             }
             if (target == nil)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [self.navigationController popToViewController:target animated:YES];
             }
         }
         else
         {
             [self.navigationController popToViewController:target animated:YES];
         }

         
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Constants showMessage:[error domain]];
     }];

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
