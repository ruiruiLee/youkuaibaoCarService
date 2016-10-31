//
//  FeedBackController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "FeedBackController.h"
#import "UIView+Toast.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"

@interface FeedBackController ()<UIGestureRecognizerDelegate>
{
}

@end

@implementation FeedBackController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"意见反馈"];
    
    [_feedBackTextView setPlaceholder:@"有什么意见和建议，请告诉我们……"];
    
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
        [self.view makeToast:@"说点您的意见或建议吧……"];
        return;
    }
    if (_feedBackTextView.text.length < 5)
    {
        [self.view makeToast:@"您输入的信息过短，至少5个字哦"];
        return;
    }
    if (_feedBackTextView.text.length > 200)
    {
        [self.view makeToast:@"您输入的信息过长，请控制在200字以内哦"];
        return;
    }
    /*
     7.意见反馈
     地址：http://118.123.249.87/service/ feedback.aspx
     参数:
     if_admin    (0:一般会员,1:车场老板或车场管理员)
     member_id  (if_amdin=0时必须输入,会员id)
     admin_id    (if_amdin=1时必须输入,车场管理员id)
     feedback_content (反馈内容,100个汉字以内)
     */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *submitDic = @{@"if_admin": @"0",
                                @"user_id": _userInfo.member_id,
                                @"feedback_content": _feedBackTextView.text};
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"feedback/service/create"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Constants showMessage:@"感谢您的宝贵意见，我们将很快采纳您的建议！"];
         [self.navigationController popViewControllerAnimated:YES];
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
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
