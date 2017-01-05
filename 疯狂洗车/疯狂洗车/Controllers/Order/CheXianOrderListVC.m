//
//  CheXianOrderListVC.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/26.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "CheXianOrderListVC.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"
#import "UIView+Toast.h"
#import "OrderListCell.h"
#import "AddCommentController.h"
#import "CommentsListController.h"
#import "OrderDetailViewController.h"
#import "OrderDetailModel.h"
#import "CarWashMapViewController.h"
#import "ButlerMapViewController.h"

@interface CheXianOrderListVC ()
{
    NSMutableArray  *_dataArray;
    
    NSMutableArray  *_editArray;
    
    NSInteger        _pageIndex;
    
    NSInteger        _pageSize;
    
    NSInteger        _orderType;
    
    BOOL             _canLoadMore;
}

@end

@implementation CheXianOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"车险保单"];
    
    _pageIndex = 1;
    _orderType = 0;
    _pageSize = 20;
    
    _canLoadMore = YES;
    _editArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    
    [_listTable addHeaderActionWithTarget:self
                                   action:@selector(obtainOrderList)];
    
    [_listTable addFooterActionWithTarget:self
                                   action:@selector(loadMoreInfo)];

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

- (void) endRefresh
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (array.count < 20)
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
        _noOrderView.hidden = NO;
        _listTable.hidden = YES;
    }
    else
    {
        _noOrderView.hidden = YES;
        _listTable.hidden = NO;
    }
    [_listTable reloadData];

}

#pragma mark - 获取数据 Method

- (void)obtainOrderList
{
    
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:0.3];
//    _pageIndex = 1;
//    NSDictionary *submitDic = @{@"member_id": _userInfo.member_id,
//                                @"page_index": [NSNumber numberWithInteger:_pageIndex],
//                                @"page_size": [NSNumber numberWithInteger:_pageSize],
//                                @"type":[NSNumber numberWithInteger:_orderType]};
//    [WebService requestJsonArrayOperationWithParam:submitDic
//                                            action:@"order/service/list"
//                                        modelClass:[OrderListModel class]
//                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
//     {
//         if (array.count < 20)
//         {
//             _canLoadMore = NO;
//         }
//         _dataArray = array;
//         [_listTable tableViewHeaderEndRefreshing];
//         if ([_dataArray count] < _pageSize * _pageIndex)
//         {
//             [_listTable letTableViewFooterHidden:YES];
//         }
//         else
//         {
//             _pageIndex += 1;
//         }
//         if (_dataArray.count == 0)
//         {
//             _noOrderView.hidden = NO;
//             _listTable.hidden = YES;
//         }
//         else
//         {
//             _noOrderView.hidden = YES;
//             _listTable.hidden = NO;
//         }
//         [_listTable reloadData];
//     }
//                                 exceptionResponse:^(NSError *error)
//     {
//         [_listTable tableViewHeaderEndRefreshing];
//         [self.view makeToast:@"暂无数据"];
//     }];
}

#pragma mark - 加载更多 Method

- (void)loadMoreInfo
{
    if (!_canLoadMore)
    {
        return;
    }
//    [WebService requestJsonArrayOperationWithParam:@{@"member_id": _userInfo.member_id,
//                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
//                                                     @"page_size": [NSNumber numberWithInteger:_pageSize],
//                                                     @"type":[NSNumber numberWithInteger:_orderType]}
//                                            action:@"order/service/list"
//                                        modelClass:[OrderListModel class]
//                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
//     {
//         if (array.count < 20)
//         {
//             _canLoadMore = NO;
//         }
//         [_dataArray addObjectsFromArray:array];
//         
//         if ([_dataArray count] < _pageSize * _pageIndex)
//         {
//         }
//         else
//         {
//             _pageIndex += 1;
//         }
//         [_listTable tableViewfooterEndRefreshing];
//         if (_dataArray.count == 0)
//         {
//             _noOrderView.hidden = NO;
//             _listTable.hidden = YES;
//         }
//         else
//         {
//             _noOrderView.hidden = YES;
//             _listTable.hidden = NO;
//         }
//         [_listTable reloadData];
//     }
//                                 exceptionResponse:^(NSError *error)
//     {
//         [_listTable tableViewfooterEndRefreshing];
//         [self.view makeToast:@"没有更多数据了"];
//     }];
}

#pragma mark - 切换订单类型  Method

- (IBAction)didChangeOrderType:(UISegmentedControl *)sender
{
    _pageIndex = 1;
    _orderType = sender.selectedSegmentIndex;
    [_listTable tableViewHeaderBeginRefreshing];
}


#pragma mark - UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 214.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell)
    {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"OrderListCell"
//                                             owner:nil
//                                           options:nil][0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    [cell setInfo:_dataArray[indexPath.row]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row == _dataArray.count - 1)
//    {
//        cell.bottomLine.hidden = NO;
//    }
//    else
//    {
//        cell.bottomLine.hidden = YES;
//    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (_dataArray.count <= 0)
//    {
//        return;
//    }
//    
//    OrderListModel *ordel = _dataArray[indexPath.row];
//    
//    OrderDetailViewController *viewController = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
//    
//    if ([ordel.service_type isEqualToString:@"0"] || ordel.service_type == nil ||[ordel.service_type isEqualToString:@"8"] )
//    {
//        viewController.isCarWashOrder = YES;
//    }
//    else
//    {
//        viewController.isCarWashOrder = NO;
//    }
//    viewController.orderListModel = ordel;
//    
//    [self.navigationController pushViewController:viewController animated:YES];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)//删除订单
//    {
//        OrderListModel *info = _editArray[indexPath.row];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [WebService requestJsonOperationWithParam:@{@"op_type":@"cancel",
//                                                    @"order_id": info.order_id,
//                                                    @"out_trade_no": info.out_trade_no,
//                                                    @"car_wash_id": info.car_wash_id,
//                                                    @"member_id": info.member_id,
//                                                    @"car_id": info.car_id,
//                                                    @"pay_type": info.pay_type,
//                                                    @"pay_money": info.pay_money}
//                                           action:@"order/service/manage"
//                                   normalResponse:^(NSString *status, id data)
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:NO];
//             [MBProgressHUD showSuccess:@"订单申请取消成功,敬请等待客服审核"
//                                 toView:self.view];
//             _pageIndex = 1;
//             [self obtainOrderList];
//         }
//                                exceptionResponse:^(NSError *error)
//         {
//             [MBProgressHUD hideHUDForView:self.view animated:YES];
//             [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
//         }];
//        
//    }
//}

#pragma mark - 返回首页

- (void)didLeftButtonTouch
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
