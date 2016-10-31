//
//  MyCarsController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyCarsController.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"
#import "MyCarsCell.h"
#import "AddNewCarController.h"

@interface MyCarsController () <MyCarsCellDelegate,AddNewCarDelegate>
{
    NSMutableArray  *_dataArray;
    NSInteger       _pageIndex;
    NSInteger       _pageSize;
    
    UIButton        *_rightButton;
}

@end

@implementation MyCarsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"我的车辆"];
    _pageIndex = 1;
    _pageSize = 20;
    
    _dataArray = [NSMutableArray array];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 44, 32)];
    [_rightButton setTitle:@"删除" forState:UIControlStateNormal];
    [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
    [_rightButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                                green:84.0/255.0
                                                 blue:1.0/255.0
                                                alpha:1.0] forState:UIControlStateNormal];
    
    [_rightButton addTarget:self
                     action:@selector(rightButtonTouch)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [_myCarsTable addHeaderActionWithTarget:self
                                     action:@selector(obtainMyCarsInfo)];
    
    
    [_myCarsTable addFooterActionWithTarget:self
                                     action:@selector(loadMoreCars)];
    
    
    [[_addNewCarBtn layer] setCornerRadius:3.0];
    [[_addNewCarBtn layer] setMasksToBounds:YES];
    // Do any additional setup after loading the view from its nib.
    
    [_myCarsTable tableViewHeaderBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadMoreCars
{
    [WebService requestJsonArrayOperationWithParam:@{@"member_id": _userInfo.member_id,
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:_pageSize]}
                                            action:@"car/service/list"
                                        modelClass:[CarInfos class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (_pageIndex == 1)
         {
             if (_dataArray.count > 0)
             {
                 [_dataArray removeAllObjects];
             }
             [_dataArray addObjectsFromArray:array];
         }
         else
         {
             [_dataArray addObjectsFromArray:array];
         }
         [_myCarsTable reloadData];
         
         
         
         _pageIndex += 1;
         if ( [_dataArray count] < _pageIndex * _pageSize)
         {
         }
         else
         {
             _pageIndex += 1;
         }
         [_myCarsTable tableViewfooterEndRefreshing];

         if (_dataArray.count > 0)
         {
             [self showOrHideNoCarView:NO];
         }
         else
         {
             [self showOrHideNoCarView:YES];
         }
     }
                                 exceptionResponse:^(NSError *error)
     {
         [_myCarsTable tableViewfooterEndRefreshing];
     }];

}

- (void)obtainMyCarsInfo
{
    [WebService requestJsonArrayOperationWithParam:@{@"member_id": _userInfo.member_id,
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:_pageSize]}
                                            action:@"car/service/list"
                                        modelClass:[CarInfos class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (_pageIndex == 1)
         {
             if (_dataArray.count > 0)
             {
                 [_dataArray removeAllObjects];
             }
             [_dataArray addObjectsFromArray:array];
         }
         else
         {
             [_dataArray addObjectsFromArray:array];
         }
         [_myCarsTable reloadData];
         [_myCarsTable tableViewHeaderEndRefreshing];
         if ([_dataArray count] < _pageIndex * _pageSize )
         {
             [_myCarsTable letTableViewFooterHidden:YES];
         }
         else
         {
            _pageIndex += 1;
         }
         if (_dataArray.count > 0)
         {
             [self showOrHideNoCarView:NO];
         }
         else
         {
             [self showOrHideNoCarView:YES];
         }
     }
                                 exceptionResponse:^(NSError *error)
     {
         [_myCarsTable tableViewHeaderEndRefreshing];
         [MBProgressHUD showError:@"暂无数据" toView:self.view];
         [_myCarsTable letTableViewFooterHidden:YES];
     }];

}

#pragma  mark - table

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_myCarsTable.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIndentifier = @"MyCarsCell";
    MyCarsCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIndentifier];
    if (nil == cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyCarsCell"
                                             owner:nil
                                           options:nil][0];
    }
    CarInfos *carInfo = _dataArray[indexPath.row];
    cell.carInfo = carInfo;
    
    [cell.titleLabel setText:[NSString stringWithFormat:@"[%@]  %@·%@",[carInfo.car_type isEqualToString:@"1"]?@"轿车" : @"SUV",[carInfo.car_no substringWithRange:NSMakeRange(0, 2)],[carInfo.car_no substringWithRange:NSMakeRange(2, carInfo.car_no.length-2)]]];
    if ([carInfo.car_type isEqualToString:@"1"])
    {
        cell.iconView.highlighted = NO;
    }
    else
    {
        cell.iconView.highlighted = YES;
    }
    [cell.typeLabel setText:[NSString stringWithFormat:@"%@ %@ %@",carInfo.car_brand == nil?@"":carInfo.car_brand,
                             carInfo.car_xilie == nil?@"":carInfo.car_xilie,
                             carInfo.car_kuanshi == nil? @"":carInfo.car_kuanshi]];
    
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarInfos *carInfo = _dataArray[indexPath.row];
    [self editCarWithCarInfo:carInfo];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CarInfos *carInfo = _dataArray[indexPath.row];
        [self deleteCarWithCarInfo:carInfo];
    }
}

- (void)editCarWithCarInfo:(CarInfos *)carInfo
{
    AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
    controller.carInfo = carInfo;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didFinishAddNewCar
{
    [_myCarsTable tableViewHeaderBeginRefreshing];
}

- (void)didFinishEditCar:(CarInfos *)result
{
    [_myCarsTable tableViewHeaderBeginRefreshing];
    
}

#pragma mark 删除车辆

- (void)deleteCarWithCarInfo:(CarInfos *)carInfo
{
    /*
     三、车辆
     1.1车辆管理（测试通过）
     地址：http://118.123.249.87/service/car_manage.aspx
     
     新增时不用输入car_id，修改或删除时必须输入car_id
     参数:
     op_type：操作方式(“insert”、“update”、“delete”)
     car_id:车辆id号
     member_id:会员编号
     car_no:牌照
     car_type(1:轿车,2:SUV)
     car_brand:品牌 如用户没输入，请传入””(空)
     */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonOperationWithParam:@{@"op_type":@"delete",
                                                @"car_id": carInfo.car_id,
                                                @"member_id": _userInfo.member_id}
                                       action:@"car/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
         [_dataArray removeObject:carInfo];
         [_myCarsTable reloadData];
         if (_dataArray.count > 0)
         {
             [self showOrHideNoCarView:NO];
         }
         else
         {
             [self showOrHideNoCarView:YES];
         }
         [self rightButtonTouch];
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view
                              animated:YES];
         [MBProgressHUD showError:@"删除成功"
                           toView:self.view];

     }];
}

- (void)rightButtonTouch
{
    if (_rightButton.selected)
    {
        _rightButton.selected = NO;
        [_myCarsTable setEditing:NO
                        animated:YES];
    }
    else
    {
        _rightButton.selected = YES;
        [_myCarsTable setEditing:YES
                        animated:YES];
    }
}

- (void)showOrHideNoCarView:(BOOL)shouldShow
{
    if (shouldShow)
    {
        _myCarsTable.hidden = YES;
        _noCarLabel.hidden = NO;
        
        float target = 220 - _addNewCarBtn.frame.origin.y;
        _addNewCarBtn.transform = CGAffineTransformMakeTranslation(0, target);
        _rightButton.hidden = YES;
    }
    else
    {
        _myCarsTable.hidden = NO;
        _noCarLabel.hidden = YES;
        _addNewCarBtn.transform = CGAffineTransformIdentity;
        _rightButton.hidden = NO;
    }
}

#pragma mark 新增车辆

- (IBAction)addNewCar:(id)sender
{
    if (_rightButton.selected)
    {
        _rightButton.selected = NO;
        [_myCarsTable setEditing:NO
                        animated:YES];
    }
    AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
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
