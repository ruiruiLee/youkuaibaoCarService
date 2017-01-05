//
//  MyAppointVC.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "MyAppointVC.h"
#import "AppointTableViewCell.h"
#import "UIView+Toast.h"
#import "AppointInfo.h"
#import "AppointPayVC.h"
#import "UIImageView+WebCache.h"

@interface MyAppointVC ()<AppointTableViewCellDelegate>
{
    NSMutableArray  *_dataArray;
    
    NSMutableArray  *_editArray;
    
    NSInteger        _pageIndex;
    
    NSInteger        _pageSize;
    
    NSInteger        _orderType;
    
    BOOL             _canLoadMore;
}

@end

@implementation MyAppointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"我的预约"];
    
    [_listTable registerNib:[UINib nibWithNibName:@"AppointTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"cell"];
    
    _pageIndex = 1;
    _orderType = 0;
    _pageSize = 20;
    
    _canLoadMore = YES;
    _editArray = [NSMutableArray array];
    
    
    [_listTable addHeaderActionWithTarget:self
                                   action:@selector(obtainOrderList)];
    
    [_listTable addFooterActionWithTarget:self
                                   action:@selector(loadMoreInfo)];
    
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_userInfo.member_id)
    {
    }
    else
    {
        _pageIndex = 1;
        
        [_listTable tableViewHeaderBeginRefreshing];
    }
    
}

- (void)obtainOrderList
{
    _pageIndex = 1;
    NSDictionary *submitDic = @{@"member_id": _userInfo.member_id,
                                @"reserve_status": @"1",
                                @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                @"page_size": [NSNumber numberWithInteger:_pageSize]};
    [WebService requestJsonArrayWXOperationWithParam:submitDic
                                            action:@"reserve/service/queryReserves"
                                        modelClass:[AppointInfo class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (array.count < _pageSize)
         {
             _canLoadMore = NO;
         }
         _dataArray = array;
         [_listTable tableViewHeaderEndRefreshing];
         if ([_dataArray count] < _pageSize * _pageIndex)
         {
             [_listTable letTableViewFooterHidden:YES];
         }
         else
         {
             _pageIndex += 1;
         }
         if (_dataArray.count == 0)
         {
             _noAppointView.hidden = NO;
             _listTable.hidden = YES;
         }
         else
         {
             _noAppointView.hidden = YES;
             _listTable.hidden = NO;
         }
         [_listTable reloadData];
     }
                                 exceptionResponse:^(NSError *error)
     {
         [_listTable tableViewHeaderEndRefreshing];
         [self.view makeToast:@"暂无数据"];
     }];
}

#pragma mark - 加载更多 Method

- (void)loadMoreInfo
{
    if (!_canLoadMore)
    {
        return;
    }
    [WebService requestJsonArrayWXOperationWithParam:@{@"member_id": _userInfo.member_id,
                                                       @"reserve_status": @"1",
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:_pageSize]}
                                            action:@"reserve/service/queryReserves"
                                        modelClass:[AppointInfo class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (array.count < _pageSize)
         {
             _canLoadMore = NO;
         }
         [_dataArray addObjectsFromArray:array];
         
         if ([_dataArray count] < _pageSize * _pageIndex)
         {
         }
         else
         {
             _pageIndex += 1;
         }
         [_listTable tableViewfooterEndRefreshing];
         if (_dataArray.count == 0)
         {
             _noAppointView.hidden = NO;
             _listTable.hidden = YES;
         }
         else
         {
             _noAppointView.hidden = YES;
             _listTable.hidden = NO;
         }
         [_listTable reloadData];
     }
                                 exceptionResponse:^(NSError *error)
     {
         [_listTable tableViewfooterEndRefreshing];
         [self.view makeToast:@"没有更多数据了"];
     }];
}


#pragma UITableViewDelegate UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *deq = @"cell";
    AppointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deq];
    if(!cell){
        cell = [[AppointTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deq];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPathRow = indexPath.row;
    
    AppointInfo *model = [_dataArray objectAtIndex:indexPath.row];
    cell.lbCarNo.text = model.car_no;
    [cell.logo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"img_default_logo"]];
    cell.lbServiceAdd.text = [NSString stringWithFormat:@"%@%@", model.city_name, model.name];
    cell.lbServiceName.text = model.service_name;
    cell.lbServiceTime.text = [NSString stringWithFormat:@"%@  %@-%@", model.reserve_day, model.b_time, model.e_time];
    if(model.pay_price && [model.pay_price doubleValue] > 0)
        cell.lbAmount.text = [NSString stringWithFormat:@"¥%.2f", [model.pay_price doubleValue]];
    else
        cell.lbAmount.text = @"";
    if(model.reserve_type == 2){
        cell.lbServiceType.text = @"自驾到店";
    }else{
        cell.lbServiceType.text = @"上门取车";
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        NSInteger row = alertView.tag - 100;
        
        AppointInfo *model = [_dataArray objectAtIndex:row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebService requestJsonWXOperationWithParam:@{ @"member_id": model.member_id,
                                                       @"out_trade_no": model.out_trade_no,
                                                       @"reserve_status": @"-1"}
                                             action:@"reserve/service/deleteReserves"
                                     normalResponse:^(NSString *status, id data)
         {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             [MBProgressHUD showSuccess:@"预约取消成功"
                                 toView:self.view];
             _pageIndex = 1;
             [self obtainOrderList];
         }
                                  exceptionResponse:^(NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
         }];
    }

}

#pragma AppointTableViewCellDelegate
- (void)didAppointCanceledButtonTouched:(NSInteger) row
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认取消预约订单吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
    alert.tag = row + 100;
    
}

- (void)didAppointPayButtonTouched:(NSInteger) row
{
    AppointPayVC *vc = [[AppointPayVC alloc] initWithNibName:@"AppointPayVC" bundle:nil];
    AppointInfo *model = [_dataArray objectAtIndex:row];
    [vc setAppointModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
