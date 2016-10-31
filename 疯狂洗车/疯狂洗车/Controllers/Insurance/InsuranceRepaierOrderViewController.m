//
//  InsuranceRepaierOrderViewController.m
//  疯狂洗车
//
//  Created by cts on 15/11/3.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceRepaierOrderViewController.h"
#import "AddCarsCell.h"
#import "MyCarDetailCell.h"
#import "CarSelectView.h"
#import "AddNewCarController.h"
#import "YearlyInspectionCell.h"
#import "UIView+Toast.h"
#import "OrderTimerPickerView.h"
#import "AddressSelectViewController.h"
#import "LocationModel.h"
#import "MoreRequestViewController.h"
#import "ServiceMoreRequestCell.h"
#import "MyOrdersController.h"
#import "InsuranceRepaierOrAVViewController.h"



@interface InsuranceRepaierOrderViewController ()
<AddCarsCellDelegate,
MyCarDetailCellDelegate,
MoreRequestDelegate,
AddNewCarDelegate,
OrderTimerPickerViewDelegate,
AddressSelectDelegate,
UIAlertViewDelegate,
YearlyInspectionCellDelegate>
{
    OrderTimerPickerView *_orderTimerPickerView;

    NSMutableArray  *_myCarsArray;

    NSInteger       _pageIndex;
    
    NSInteger       _pageSize;
    
    NSIndexPath     *_currentCarIndexPath;
    
    CarInfos        *_selectedCar;
    
    NSString        *_orderTimeString;
    
    NSString        *_addressString;
    
    NSString        *_moreRequestString;
    
    UIButton        *_submitButton;

    LocationModel       *_serviceLocation;
    

}

@end

@implementation InsuranceRepaierOrderViewController

static NSString *yearlyInspectionCellIdentifier = @"YearlyInspectionCell";

static NSString *myCarDetailCellIdentifier = @"MyCarDetailCell";

static NSString *serviceMoreRequestCellIdentifier = @"ServiceMoreRequestCell";

static NSString *submitButtonCellIdentifier = @"SubmitButtonCell";





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"免费理赔送修"];
    
    _pageIndex = 1;
    _pageSize = 20;
    
    _myCarsArray = [NSMutableArray array];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _submitButton.frame = CGRectMake(10, 30, SCREEN_WIDTH-20, 40);
    [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:[UIColor colorWithRed:235/255.0
                                                      green:84/255.0
                                                       blue:1/255.0
                                                      alpha:1.0]];
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    
    [_submitButton addTarget:self
                      action:@selector(didSubmitButtonTouch)
            forControlEvents:UIControlEventTouchUpInside];

    
    [_contextTableView registerNib:[UINib nibWithNibName:yearlyInspectionCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:yearlyInspectionCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:myCarDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:myCarDetailCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:serviceMoreRequestCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:serviceMoreRequestCellIdentifier];
    
    int minHour = 28800.0;
    int maxHour = 72000.0;
    
    _orderTimerPickerView = [[OrderTimerPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                          withTimeRange:NSMakeRange(minHour, maxHour)];
    _orderTimerPickerView.delegate = self;
    _orderTimerPickerView.showLimite = YES;
    
    [self addCommentNotification];

    
    [self getInformationFromService];
    
    if (!_userInfo.member_id)
    {
        
    }
    else
    {
        [self loadMoreCars];
    }
}


- (void)getInformationFromService
{
    NSDictionary *submitDic = @{@"city_id":[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                                @"member_id":_userInfo.member_id == nil?@"":_userInfo.member_id};
    NSString *urlString = @"carWash/service/vipRepair";

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonModelWithParam:submitDic
                                   action:urlString
                               modelClass:[CarReviewModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             self.carReviewModel = (CarReviewModel*)model;
             self.carReviewModel.service_city = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityNameKey];
             
             [_contextTableView reloadData];
         }
         
     }
                        exceptionResponse:^(NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            self.view.userInteractionEnabled = YES;
                            [MBProgressHUD showError:[error domain] toView:self.view];
                        }];
    
}


#pragma mark - 请求我自己的车辆

- (void)loadMoreCars
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _selectedCar = nil;
    [WebService requestJsonArrayOperationWithParam:@{@"member_id": _userInfo.member_id,
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:_pageSize]}
                                            action:@"car/service/list"
                                        modelClass:[CarInfos class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (_pageIndex == 1)
         {
             if (_myCarsArray.count > 0)
             {
                 [_myCarsArray removeAllObjects];
             }
             [_myCarsArray addObjectsFromArray:array];
         }
         else
         {
             [_myCarsArray addObjectsFromArray:array];
         }
         if ([_myCarsArray count] < _pageSize*_pageIndex)
         {
             
         }
         else
         {
             _pageIndex += 1;
         }
         if (_myCarsArray.count > 0)
         {
             if (_selectedCar == nil)
             {
                 _selectedCar = _myCarsArray[0];
             }
             else
             {
             }
         }
         [_contextTableView reloadData];
         
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view
                              animated:YES];
     }];
}

#pragma UITableViewDataSource
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        if (_myCarsArray.count > 1)
        {
            return 3;
        }
        else
        {
            return _myCarsArray.count + 1;
        }
    }
    else if (section == 2)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 3)
    {
        return 0;
    }
    else
    {
        return 30;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 ||section == 2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
        titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:13];
        
        if (section == 1)
        {
            titleLabel.text = @"服务车辆";
        }
        else
        {
            titleLabel.text = @"预约信息";
        }
        
        [view addSubview:titleLabel];
        
        return view;
    }
    else
    {
        return nil;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60+SCREEN_WIDTH/3.0;
    }
    else if (indexPath.section == 3)
    {
        return 100;
    }
    else
    {
        return 40;
    }
}

#pragma mark - 各种cell的cellForRowAtIndexPath

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self tableView:tableView YearlyInspectionCellIdentifierForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 1)
    {
        return [self tableView:tableView myCarCellForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 2)
    {
        return [self tableView:tableView serviceInfoCellForRowAtIndexPath:indexPath];
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:submitButtonCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:submitButtonCellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:_submitButton];
        
        return cell;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView YearlyInspectionCellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YearlyInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:yearlyInspectionCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[YearlyInspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yearlyInspectionCellIdentifier];
    }
    
    if (self.carReviewModel)
    {
        [cell setDisplayInfo:self.carReviewModel];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView myCarCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_myCarsArray.count > 1)
    {
        if (indexPath.row == 2)
        {
            AddCarsCell *cell = [[NSBundle mainBundle] loadNibNamed:self.isClubController?@"AddCarsCell_Club":@"AddCarsCell"
                                                              owner:nil
                                                            options:nil][0];
            cell.delegate = self;
            if (!_userInfo.member_id)
            {
                cell.opreationTitle.text = @"未登录";
            }
            else if (_myCarsArray.count > 2)
            {
                cell.opreationTitle.text = @"更多车辆";
            }
            else
            {
                cell.opreationTitle.text = @"添加车辆";
            }
            return cell;
            
        }
        else
        {
            MyCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCarDetailCellIdentifier];
            if (nil == cell)
            {
                cell = [[MyCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:myCarDetailCellIdentifier];
            }
            CarInfos *info = _myCarsArray[indexPath.row];

            [cell setDisplayInfo:info];
            if (_selectedCar != nil)
            {
                if (info == _selectedCar)
                {
                    cell.selectIcon.highlighted = YES;
                }
                else
                {
                    cell.selectIcon.highlighted = NO;
                }
            }
            else
            {
                cell.selectIcon.highlighted = NO;
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        if (indexPath.row == _myCarsArray.count)
        {
            AddCarsCell *cell = [[NSBundle mainBundle] loadNibNamed:self.isClubController?@"AddCarsCell_Club":@"AddCarsCell"
                                                              owner:nil
                                                            options:nil][0];
            cell.delegate = self;
            if (!_userInfo.member_id)
            {
                cell.opreationTitle.text = @"未登录";
            }
            else if (_myCarsArray.count > 2)
            {
                cell.opreationTitle.text = @"更多车辆";
            }
            else
            {
                cell.opreationTitle.text = @"添加车辆";
            }
            return cell;
        }
        else
        {
            MyCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCarDetailCellIdentifier];
            if (nil == cell)
            {
                cell = [[MyCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:myCarDetailCellIdentifier];
            }
            CarInfos *info = _myCarsArray[indexPath.row];
            
            if (_selectedCar != nil)
            {
                if (info == _selectedCar)
                {
                    cell.selectIcon.highlighted = YES;
                }
                else
                {
                    cell.selectIcon.highlighted = NO;
                }
            }
            else
            {
                cell.selectIcon.highlighted = NO;
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell setDisplayInfo:info];
            
            return cell;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView serviceInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceMoreRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceMoreRequestCellIdentifier];
    if (cell == nil)
    {
        cell = [[ServiceMoreRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceMoreRequestCellIdentifier];
    }
    
    if (indexPath.row == 0)
    {
        [cell setDisplayMoreInfo:_orderTimeString
                    withCellType:1
              andPlaceHolderText:@"请预约服务的时间"];
    }
    else if (indexPath.row == 1)
    {
        [cell setDisplayMoreInfo:_addressString
                    withCellType:0
              andPlaceHolderText:@"请预约服务的地点"];
    }
    else
    {
        [cell setDisplayMoreInfo:_moreRequestString
                    withCellType:2
              andPlaceHolderText:@"填写更多个性需求"];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [_orderTimerPickerView showOrderTimerPickerView];
        }
        else if (indexPath.row == 1)
        {
            AddressSelectViewController *viewController = [[AddressSelectViewController alloc] initWithNibName:@"AddressSelectViewController"
                                                                                                        bundle:nil];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];

        }
        else
        {
            MoreRequestViewController *viewController = [[MoreRequestViewController alloc] initWithNibName:@"MoreRequestViewController"
                                                                                                    bundle:nil];
            viewController.delegate = self;
            if (_moreRequestString != nil && ![_moreRequestString isEqualToString:@""])
            {
                viewController.requestString = _moreRequestString;
            }
            [self.navigationController pushViewController:viewController animated:YES];

        }
    }
}


#pragma UITableViewDelegate


- (void)didAddCarButtonTouched
{
    if (!_userInfo.member_id)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        
        return;
    }
    if (_myCarsArray.count > 2)
    {
        NSArray *recentCars = [_myCarsArray subarrayWithRange:NSMakeRange(2, _myCarsArray.count-2)];
        [CarSelectView showCarSelectViewWithCars:recentCars ForTarget:self];
    }
    else
    {
        AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
        controller.delegate = self;
        controller.shouldComplete = self.isClubController;
        [self.navigationController pushViewController:controller animated:YES];
    }
}




- (void)didMyCarButtonSelectButtonTouched:(NSIndexPath *)indexPath
{
    _selectedCar = _myCarsArray[indexPath.row];
    
    [_contextTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                     withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - CarSelectViewDelegate

- (void)didAddButtonTouched
{
    AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
    controller.delegate = self;
    controller.shouldComplete = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didSelectACar:(CarInfos*)carInfo
{
    if (_selectedCar != nil)
    {
        _selectedCar = carInfo;
        NSInteger index = 0;
        for (int x = 0; x<_myCarsArray.count; x++)
        {
            CarInfos *car = _myCarsArray[x];
            if ([car.car_id isEqualToString:_selectedCar.car_id])
            {
                index = x;
            }
        }
        [_myCarsArray exchangeObjectAtIndex:1 withObjectAtIndex:index];
    }
    _selectedCar = carInfo;
    NSInteger index = 0;
    for (int x = 0; x<_myCarsArray.count; x++)
    {
        CarInfos *car = _myCarsArray[x];
        if ([car.car_id isEqualToString:_selectedCar.car_id])
        {
            index = x;
        }
    }

    [_myCarsArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
    [_contextTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                     withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFinishAddNewCar
{
    _pageIndex = 1;
    [self loadMoreCars];
}

- (void)didFinishEditCar:(CarInfos *)result
{
    [self didFinishAddNewCar];
}

#pragma mark -  AddressSelectDelegate

- (void)didFinishAddressSelect:(LocationModel*)locationModel
{
    _serviceLocation = locationModel;
    _addressString   = _serviceLocation.addressString;
    
    [_contextTableView reloadData];
}

#pragma mark -

- (void)didFinishOrderTimerPicker:(NSString *)resultString
{
    _orderTimeString = resultString;
    [_contextTableView reloadData];
}

#pragma mark - MoreRequestDelegate

- (void)didFinishMoreRequestEditing:(NSString*)contextString
{
    _moreRequestString = contextString;
    [_contextTableView reloadData];
}


#pragma mark - YearlyInspectionCellDelegate Method

- (void)didIntroductionButtonTouched
{
    InsuranceRepaierOrAVViewController *viewController = [[InsuranceRepaierOrAVViewController alloc] initWithNibName:@"InsuranceRepaierOrAVViewController"
                                                                                                              bundle:nil];
    viewController.carReviewModel = self.carReviewModel;
    viewController.isAVService = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didPhoneButtonTouched
{
    if ([Constants canMakePhoneCall])
    {
        NSString *messageString = [NSString stringWithFormat:@"致电客服%@",self.carReviewModel.contact_phone];
        [Constants showMessage:messageString
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"确认", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }
}
#pragma mark - 提交逻辑

- (void)didSubmitButtonTouch
{
    if (!_userInfo.member_id)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        
        return;
    }
    if ([_orderTimeString isEqualToString:@""] || _orderTimeString == nil)
    {
        [Constants showMessage:@"您还未选择指定预约的时间"];
        return;
    }
    if ([_addressString isEqualToString:@""] || _addressString == nil)
    {
        [Constants showMessage:@"您还未选择指定预约的地点"];
        return;
    }
    if (!_selectedCar)
    {
        [Constants showMessage:@"你还没有车辆，新增车辆？"
                      delegate:self
                           tag:10086
                  buttonTitles:@"取消", @"新增", nil];
        return;
    }
    else if (_selectedCar.car_xilie == nil||
             [_selectedCar.car_xilie isEqualToString:@""] ||
             [_selectedCar.car_type isEqualToString:@""] ||
             _selectedCar.car_type == nil)
    {
        [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                      delegate:self
                           tag:534
                  buttonTitles:@"取消",@"马上补充", nil];
        return;
    }
    else
    {
        [Constants showMessage:@"确定下单"
                      delegate:self
                           tag:530
                  buttonTitles:@"取消",@"确定", nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 534 && buttonIndex == 1)
    {
        AddNewCarController *viewController = [[AddNewCarController alloc] initWithNibName:@"AddNewCarController" bundle:nil];
        viewController.delegate  = self;
        viewController.carInfo = _selectedCar;
        viewController.shouldComplete = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (alertView.tag == 10086)
    {
        if (buttonIndex == 1)
        {
            AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
            controller.delegate = self;
            controller.shouldComplete = self.isClubController;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    if (alertView.tag == 10087)
    {
        if (buttonIndex == 1)
        {
            AddNewCarController *viewController = [[AddNewCarController alloc] initWithNibName:@"AddNewCarController" bundle:nil];
            viewController.delegate  = self;
            viewController.carInfo = _selectedCar;
            viewController.shouldComplete = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    if (alertView.tag == 530)
    {
        if (buttonIndex == 1)
        {
            [self startSubmitRepaierOrder];
        }
    }

}

- (void)startSubmitRepaierOrder
{
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970]*1000;
    double i = time;
    NSString *tradeNo = [NSString stringWithFormat:@"%.0f%@",i ,_userInfo.member_id];
    NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
    [submitDic setObject:@"new"
                  forKey:@"op_type"];
    [submitDic setObject:tradeNo
                  forKey:@"out_trade_no"];
    [submitDic setObject:_selectedCar.car_id
                  forKey:@"car_id"];
    [submitDic setObject:self.carReviewModel.car_wash_id
                  forKey:@"car_wash_id"];
    [submitDic setObject:self.carReviewModel.service_type
                  forKey:@"service_type"];
    [submitDic setObject:_userInfo.member_id
                  forKey:@"member_id"];
    [submitDic setObject:[NSString stringWithFormat:@"%.2f",self.carReviewModel.member_price.floatValue]
                  forKey:@"pay_money"];
    
    [submitDic setObject:self.carReviewModel.service_id
                  forKey:@"service_id"];
    
    [submitDic setObject:@"0"
                  forKey:@"is_super"];
    
    if ([_moreRequestString isEqualToString:@""] || _moreRequestString == nil)
    {
    }
    else
    {
        [submitDic setObject:_moreRequestString
                      forKey:@"requiry"];
    }
    
    [submitDic setObject:@2
                  forKey:@"service_mode"];
    
    [submitDic setObject:_orderTimeString
                  forKey:@"service_time"];
    
    [submitDic setObject:_addressString
                  forKey:@"service_addr"];
    
    [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.latitude]
                  forKey:@"latitude"];
    [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.longitude]
                  forKey:@"longitude"];
    
    
    [submitDic setValue:@4
                 forKey:@"pay_type"];

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"order/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             
             if (bIsiOS7)
             {
                 if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
                 {
                     [_appDelegate showAlertMessageForRegisterNotifacation:@"\n订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
                 }
                 else
                 {
                     [Constants showMessage:@"\n订单支付成功！\n"];
                 }
             }
             else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
             {
                 [Constants showMessage:@"\n订单支付成功！\n"];
             }
             else
             {
                 [_appDelegate showAlertMessageForRegisterNotifacation:@"\n订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
             }
             NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
             [tmpArray removeLastObject];
             MyOrdersController *viewController = [[MyOrdersController alloc] initWithNibName:@"MyOrdersController" bundle:nil];
             [tmpArray addObject:viewController];
             [self.navigationController setViewControllers:tmpArray animated:YES];

             
         }
         else
         {
             [MBProgressHUD hideHUDForView:self.view
                                  animated:NO];
             [MBProgressHUD showError:@"订单支付失败"
                               toView:self.navigationController.view];
             
         }
     }
                            exceptionResponse:^(NSError *error)
     {
         self.view.userInteractionEnabled = YES;
         [MBProgressHUD hideHUDForView:self.view
                              animated:NO];
         [Constants showMessage:[error domain]];
     }];
}

- (void)didLoginByCheckCodeSuccess
{
    [self getInformationFromService];
    [self loadMoreCars];
}

#pragma mark - 支付相关

- (void)addCommentNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoginByCheckCodeSuccess)
                                                 name:kLoginByCheckCodeSuccessNotifaction
                                               object:nil];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginByCheckCodeSuccessNotifaction
                                                  object:nil];
    
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
