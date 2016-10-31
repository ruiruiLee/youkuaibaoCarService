//
//  ButlerOrderFinishViewController.m
//  优快保
//
//  Created by cts on 15/6/22.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerOrderFinishViewController.h"
#import "MBProgressHUD+Add.h"
#import "OrderSuccessViewController.h"
#import "MyOrdersController.h"
#import "ButlerComplainViewController.h"

@interface ButlerOrderFinishViewController ()

@end

@implementation ButlerOrderFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.backEnable)
    {
        UIButton *leftHideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 36, 32)];
        [leftHideButton setTitle:@"投诉" forState:UIControlStateNormal];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftHideButton];
        [self.navigationItem setLeftBarButtonItem:leftItem];
        leftHideButton.hidden = YES;

    }
    [_submitBottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_butler_finish_submitBottom"]]];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 36, 32)];
    [rightBtn setTitle:@"投诉" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor colorWithRed:235.0/255.0
                                            green:84.0/255.0
                                             blue:1.0/255.0
                                            alpha:1.0] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self setTitle:@"完成订单"];
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 3;
    
    _nannyNameLabel.text = _userButlerOrder.name;
    
    _nannyOrderTimeLabel.text = _userButlerOrder.create_time;
    
    _nannyCountLabel.text = [NSString stringWithFormat:@"服务次数：%d次",_userButlerOrder.service_count.intValue];
    
    _nannyHeaderImageView.layer.masksToBounds = YES;
    _nannyHeaderImageView.layer.cornerRadius = 65/2.0;
    _nannyHeaderImageView.layer.borderWidth = 0.7;
    _nannyHeaderImageView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0].CGColor;
    
    [_nannyHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_userButlerOrder.logo]
                       placeholderImage:[UIImage imageNamed:@"btn_butler_finish_header"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_nannyHeaderImageView setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85)
                                                                              withTarget:image]];
         }
     }];
        
    _priceLabel.text = [NSString stringWithFormat:@"¥%d",_userButlerOrder.member_price.intValue];
    _oldPriceLabel.text = [NSString stringWithFormat:@"¥%d",_userButlerOrder.original_price.intValue];
    
    [_starRatingView setScore:4.0/5.0 withAnimation:NO];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark - 拨打电话

- (IBAction)didCallCurrentNannyOrderTouch
{
    if ([Constants canMakePhoneCall])
    {
        [Constants showMessage:@"确认联系该车保姆"
                      delegate:self
                           tag:457
                  buttonTitles:@"取消",@"确定", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 457 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _userButlerOrder.admin_phone]]];
    }
    if (alertView.tag == 458 && buttonIndex == 1)
    {
        [self submitAndCompleteOrder];
    }
}

#pragma mark - 投诉

- (void)didRightButtonTouch
{
    ButlerComplainViewController *viewController = [[ButlerComplainViewController alloc] initWithNibName:@"ButlerComplainViewController"
                                                                                                  bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 提交评价

- (IBAction)didSubmitButtonTouch
{
    [Constants showMessage:@"确认提交评价？"
                  delegate:self
                       tag:458
              buttonTitles:@"取消",@"确定", nil];
}

- (void)submitAndCompleteOrder
{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    NSDictionary *submitDic = @{@"order_id":_userButlerOrder.order_id,
                                @"car_wash_id":_userButlerOrder.car_wash_id,
                                @"content":@"",
                                @"phone"      : _userInfo.member_phone,
                                @"score"      : [NSNumber numberWithDouble:_starRatingView.score * 5.0]};
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"order/service/done"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         _userButlerOrder = nil;
         [Constants showMessage:@"操作成功"];

         if ([_appconfig.open_share_order_flag isEqualToString:@"1"])
         {
             NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
             [tmpArray removeLastObject];
             OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                                       bundle:nil];
             
             viewController.share_order_url = [data objectForKey:@"share_order_url"];
             [tmpArray addObject:viewController];
             [self.navigationController setViewControllers:tmpArray animated:YES];
         }
         else
         {
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
        }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view
                                                         animated:YES];
                                [MBProgressHUD showError:[error domain]
                                                  toView:self.view];
                            }];

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
