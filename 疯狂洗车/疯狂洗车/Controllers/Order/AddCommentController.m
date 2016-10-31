//
//  AddCommentController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "AddCommentController.h"
#import "GCPlaceholderTextView.h"
#import "TQStarRatingView.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"

@interface AddCommentController () <StarRatingViewDelegate, UITextViewDelegate,UIAlertViewDelegate>
{
    UIButton  *_rightButton;
}

@end

@implementation AddCommentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"评价"];
    
    _iconView.layer.borderWidth = 1;
    _iconView.layer.borderColor = [UIColor colorWithRed:204/255.0
                                                  green:204/255.0
                                                   blue:204/255.0
                                                  alpha:0.5].CGColor;

    
    [self setupInterface];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupInterface
{
    [[_comentsBg layer] setCornerRadius:5.0];
    [[_comentsBg layer] setMasksToBounds:YES];
    [[_comentsBg layer] setBorderWidth:1.0];
    [[_comentsBg layer] setBorderColor:[[UIColor colorWithRed:230.0/255.0 green:230/255.0 blue:230/255.0 alpha:1.0] CGColor]];
    
    [[_submitBtn layer] setCornerRadius:3.0];
    [[_submitBtn layer] setMasksToBounds:YES];
    [_commentsTextView setPlaceholder:@"亲，您的评价对其它车友有很大帮助"];
    [_starView setDelegate:self];
    
    

    if (self.orderInfo)
    {
        [_titleLabel setText:_orderInfo.car_wash_name];
        [_addressLabel setText:_orderInfo.car_wash_address];
        [_nowPriceLabel setText:[NSString stringWithFormat:@"￥%@", _orderInfo.pay_money]];
        [_carWashStarView setScore:_orderInfo.average_score.floatValue/5.0
                     withAnimation:NO];
        

        [_iconView sd_setImageWithURL:[NSURL URLWithString:_orderInfo.pay_money]
                         placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (error == nil)
             {
                 [_iconView setImage:[Constants imageByScalingAndCroppingForSize:_iconView.frame.size withTarget:image]];
             }
         }];

    }
    if (self.carWashModel)
    {
        [_titleLabel setText:_carWashModel.name];
        [_addressLabel setText:_carWashModel.address];
        [_nowPriceLabel setText:[NSString stringWithFormat:@"￥%@", _carWashModel.car_member_price]];
        [_carWashStarView setScore:_carWashModel.average_score.floatValue/5.0
                     withAnimation:NO];
        
        [_iconView sd_setImageWithURL:[NSURL URLWithString:_carWashModel.logo]
                         placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (error == nil)
             {
                 [_iconView setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85) withTarget:image]];
             }
         }];
    }
    
    if (self.isButler)
    {
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = _iconView.frame.size.width/2.0;
    }
    else
    {
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = 5;
    }
    
    if (!self.isCarWash)
    {
        _nowPriceLabel.text = @"车服务评分：";
    }
    else
    {
        _nowPriceLabel.text = @"洗车服务评分：";
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 4.1　评价 (测试通过)
 地址：http://118.123.249.87/service/ car_wash_evaluation.aspx
 参数:
 car_wash_id:评价的车场编号
 score：分数（1-5）
 content:评价内容（100个汉字以内）
 phone：车主电话
 car_no:车牌号
 car_type：车类型(1.轿车 2.SUV)
 返回：Success：true/false 是否成功，msg:提示
 */

 
- (IBAction)submitInfo:(id)sender
{
    [_commentsTextView resignFirstResponder];
    
    if (_commentsTextView.text.length > 150)
    {
        [Constants showMessage:@"您输入的内容太多，请限制在200字以内"];
        return;
    }
    
    [Constants showMessage:@"提交评价？" delegate:self tag:530 buttonTitles:@"取消",@"确定", nil];
    
    

}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex == 1)
    {
        if (self.orderInfo)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *submitDic = @{@"car_wash_id": _orderInfo.car_wash_id,
                                        @"member_id"  :_userInfo.member_id,
                                        @"score"      : [NSNumber numberWithDouble:_starView.score * 5.0],
                                        @"content"    : [_commentsTextView.text isEqualToString:@""] ?@"":_commentsTextView.text,
                                        @"phone"      : _userInfo.member_phone,
                                        @"service_id" :_orderInfo.service_id};
            [WebService requestJsonOperationWithParam:submitDic
                                               action:@"evaluation/service/create"
                                       normalResponse:^(NSString *status, id data)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showSuccess:@"评价成功" toView:self.navigationController.view];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kAddCommentsSuccess object:nil];
                 [self.navigationController popViewControllerAnimated:YES];
             }
                                    exceptionResponse:^(NSError *error)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
             }];
        }
        else if (self.carWashModel)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *submitDic = @{@"car_wash_id": _carWashModel.car_wash_id,
                                        @"member_id"  :_userInfo.member_id,
                                        @"score"      : [NSNumber numberWithDouble:_starView.score * 5.0],
                                        @"content"    : [_commentsTextView.text isEqualToString:@""] ?@"":_commentsTextView.text,
                                        @"phone"      : _userInfo.member_phone,
                                        @"service_id" :self.service_id};
            [WebService requestJsonOperationWithParam:submitDic
                                               action:@"evaluation/service/create"
                                       normalResponse:^(NSString *status, id data)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showSuccess:@"评价成功" toView:self.navigationController.view];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:kAddCommentsSuccess object:nil];
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }
                                    exceptionResponse:^(NSError *error)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
             }];
        }
    }
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    
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

#pragma mark -
#pragma mark 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note
{
    [UIView beginAnimations:@"changeViewFrame" context:nil];
    [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    self.view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark 键盘即将打开

- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.view.bounds.size.height - _comentsBg.frame.origin.y - _comentsBg.frame.size.height < rect.size.height)
    {
        CGFloat ty = - (self.view.bounds.size.height - _commentsTextView.frame.origin.y - _commentsTextView.frame.size.height - rect.size.height);
        
        [UIView beginAnimations:@"changeViewFrame" context:nil];
        [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        [UIView commitAnimations];
    }
}


@end
