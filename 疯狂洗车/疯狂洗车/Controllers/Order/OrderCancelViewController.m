//
//  OrderCancelViewController.m
//  优快保
//
//  Created by cts on 15/5/16.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderCancelViewController.h"
#import "OrderCancelMoreViewController.h"
#import "MyOrdersController.h"
#import "OrderDetailViewController.h"

@interface OrderCancelViewController ()
{
    NSInteger _selectIndex;
}

@end

@implementation OrderCancelViewController

static NSString *cancelReasonCellIdentifier = @"CancelReasonCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"取消订单"];
    //_reasonArray = [NSMutableArray array];
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 3;
    
    _reasonArray = [NSMutableArray arrayWithArray:@[@"暂时不想服务",@"误操作下单",@"赶时间来不及了",@"路上出状况了"]];
    _selectIndex = 0;

    [_contextTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _reasonArray.count)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _reasonArray.count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cancelReasonCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cancelReasonCellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = _reasonArray[indexPath.row];
        if (indexPath.row == _selectIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.row != _reasonArray.count - 1)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:0.5];
            [cell.contentView addSubview:lineView];
        }
    }
    else
    {
        cell.textLabel.text = @"其它原因";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        OrderCancelMoreViewController *viewController = [[OrderCancelMoreViewController alloc] initWithNibName:@"OrderCancelMoreViewController"
                                                                                                        bundle:nil];
        viewController.orderModel = self.orderModel;
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:NO];
        _selectIndex = indexPath.row;
        [_contextTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)didSubmitButtonTouch:(id)sender
{
    NSString *cancelReasonString = [NSString stringWithFormat:@"%@",_reasonArray[_selectIndex]];
    
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
                                @"reason":cancelReasonString};
    
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"order/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Constants showMessage:@"“取消订单”申请成功"];
         
         id target = nil;
         
         for (id controller in self.navigationController.viewControllers)
         {
             if ([controller isKindOfClass:[OrderDetailViewController class]])
             {
                 target = controller;
                 [[NSNotificationCenter defaultCenter] postNotificationName:kOrderDetailShouldUpdateNotification
                                                                     object:nil];
                 break;
             }
         }
         
         if (target == nil)
         {
             for (id controller in self.navigationController.viewControllers)
             {
                 if ([controller isKindOfClass:[ButlerMapViewController class]])
                 {
                     target = controller;
                     break;
                 }
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
