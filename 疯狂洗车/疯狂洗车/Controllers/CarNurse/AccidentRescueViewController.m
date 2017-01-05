//
//  AccidentRescueViewController.m
//  疯狂洗车
//
//  Created by cts on 15/11/23.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "AccidentRescueViewController.h"
#import "YearlyInspectionCell.h"
#import "ServiceMoreRequestCell.h"
#import "PayWayCell.h"
#import "ThirdPayWayCell.h"
#import "TicketPayWayCell.h"
#import "ServiceModeRequestModel.h"
#import "AddressSelectViewController.h"
#import "OrderSuccessViewController.h"
#import "MyTicketViewController.h"
//#import "UPPayPlugin.h"
//#import "UPPayPluginDelegate.h"
#import "UIView+Toast.h"
#import "PayHelper.h"
#import "CarInfos.h"
#import "CarSelectView.h"
#import "AddCarsCell.h"
#import "MyCarDetailCell.h"
#import "AddNewCarController.h"
#import "MyOrdersController.h"
#import "ADVModel.h"
#import "ActivitysController.h"


@interface AccidentRescueViewController ()
<
CarSelectViewDelegate,
AddCarsCellDelegate,
TicketPayWayCellDelegate,
MyCarDetailCellDelegate,
MyTicketDelegate,
AddNewCarDelegate,
UIActionSheetDelegate,
//UPPayPluginDelegate,
AddressSelectDelegate,
YearlyInspectionCellDelegate>
{
    LocationModel       *_serviceLocation;
    
    NSMutableArray  *_myCarsArray;
    
    NSInteger       _pageIndex;
    
    NSInteger       _pageSize;
    
    CLLocationCoordinate2D  coordinate;
    
    NSInteger       _currentPayType;
    
    NSIndexPath     *_currentCarIndexPath;
    
    NSString        *out_trade_no;
    
    NSString        *_ticketName;
    
    CarInfos        *_selectedCar;
    
    int              _errorTime;
    
    BOOL             _ticketEnable;
    
    BOOL             _remainderSelected;
    
    BOOL             _ticketSelected;

}

@end

@implementation AccidentRescueViewController

static NSString *yearlyInspectionCellIdentifier = @"YearlyInspectionCell";

static NSString *myCarDetailCellIdentifier = @"MyCarDetailCell";

static NSString *serviceMoreRequestCellIdentifier = @"ServiceMoreRequestCell";

static NSString *payWayCellIdentifier = @"PayWayCell";

static NSString *thirdPayWayCellIdentifier = @"ThirdPayWayCell";


static NSString *ticketPayWayCellIdentifier = @"TicketPayWayCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _pageIndex = 1;
    _pageSize = 20;
    
    _remainderSelected = YES;
    
    _currentPayType = 3;
    
    [self setTitle:@"事故救援"];
    
    _myCarsArray = [NSMutableArray array];
    
    if ([_userCurrentLoactionStreet isEqualToString:@""] || _userCurrentLoactionStreet != nil)
    {
        LocationModel *userCurrentModel = [[LocationModel alloc] init];
        userCurrentModel.addressString = [NSString stringWithFormat:@"%@",_userCurrentLoactionStreet];
        userCurrentModel.locationCoordinate = CLLocationCoordinate2DMake(_publicUserCoordinate.latitude, _publicUserCoordinate.longitude);
        _serviceLocation = userCurrentModel;
    }

    
    [_contextTableView registerNib:[UINib nibWithNibName:yearlyInspectionCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:yearlyInspectionCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:thirdPayWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:thirdPayWayCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:myCarDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:myCarDetailCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:payWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:payWayCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:ticketPayWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ticketPayWayCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:serviceMoreRequestCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:serviceMoreRequestCellIdentifier];
    
    _contextTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    coordinate.latitude = [[[[NSUserDefaults standardUserDefaults] valueForKey:kLocationKey] valueForKey:@"latitude"] doubleValue];
    coordinate.longitude = [[[[NSUserDefaults standardUserDefaults] valueForKey:kLocationKey] valueForKey:@"longitude"] doubleValue];
    
    _myCarsArray = [NSMutableArray array];
    
    if (!_userInfo.member_id)
    {
        
        _remainderSelected = NO;
        //    [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",self.carWashInfo.car_member_price.floatValue ]];
        [self addCommentNotification];
    }
    else
    {
        [self loadMoreCars];
    }
    [self loadCarServicesByCarNurseModel:_carNurse];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addPayNotifaction];
    //_userInfo = [[UserInfo alloc] initWithCacheKey:kUserInfoKey];
    
    [_contextTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removePayNotifaction];
}

#pragma mark - 注册监听

- (void)addCommentNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoginByCheckCodeSuccess)
                                                 name:kLoginByCheckCodeSuccessNotifaction
                                               object:nil];
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
                 if ([_selectedCar.car_type isEqualToString:@"1"])
                 {
                     [self updateDisplayPayPrice];
                     
                 }
                 else
                 {
                     [self updateDisplayPayPrice];
                 }
             }
             else
             {
                 [self updateDisplayPayPrice];
             }
         }
         else
         {
             [self updateDisplayPayPrice];
         }
         [_contextTableView reloadData];
         
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)loadCarServicesByCarNurseModel:(CarNurseModel*)model
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *submitDic = nil;
    
    
    if (_userInfo.member_id)
    {
        submitDic = @{@"car_wash_id":model.car_wash_id,
                      @"service_type":self.service_type,
                      @"member_id":_userInfo.member_id,
                      @"super_service":@"0"};
        
    }
    else
    {
        submitDic = @{@"car_wash_id":model.car_wash_id,
                      @"service_type":self.service_type,
                      @"super_service":@"0"};
        
    }
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"carWash/service/detail"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0 && ![data isKindOfClass:[NSNull class]])
         {
             CarNurseModel *model = [[CarNurseModel alloc] initWithDictionary:data];
             NSArray *networkImages= nil;
             if ([model.photo_addrs isEqualToString:@""] || model.photo_addrs == nil)
             {
                 networkImages = @[model.logo];
             }
             else
             {
                 networkImages= [model.photo_addrs componentsSeparatedByString:@","];
                 if (networkImages.count <= 0 )
                 {
                     networkImages = @[model.logo];
                 }
             }
             self.carNurse.accident_rescue_img_url = networkImages[0];
             [_contextTableView reloadData];
         }
         else
         {
             
         }
     }
                            exceptionResponse:^(NSError *error)
     {
     }];
    
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/getService"
                                        modelClass:[CarNurseServiceModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (status.intValue > 0 && array.count > 0)
         {
             for (int x= 0; x<array.count; x++)
             {
                 CarNurseServiceModel *model = array[x];
                 if ([model.service_type isEqualToString:@"4"])
                 {
                     _serviceModel = array[x];
                     [self getUserAllTicketsFromService];
                     break;
                 }
             }
             _contextTableView.hidden = NO;
             [self updateDisplayPayPrice];
             [_contextTableView reloadData];
         }
         else
         {
             [MBProgressHUD showError:@"该车场暂无车服务" toView:self.view];
         }
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showError:@"获取数据失败" toView:self.view];
         
     }];
}


#pragma mark - 获取券

- (void)getUserAllTicketsFromService
{
    if (self.serviceModel.code_count.intValue > 0)
    {
        CarNurseServiceModel *model = self.serviceModel;
        _ticketEnable = YES;
        if ([model.code_id isEqualToString:@""] || model.code_id == nil)
        {
            
        }
        else
        {
            TicketModel *ticket = [[TicketModel alloc] init];
            ticket.code_id = model.code_id;
            ticket.code_content = model.code_content;
            ticket.price = model.price;
            ticket.consume_type = model.consume_type;
            ticket.create_time = model.create_time;
            ticket.code_name = model.code_name;
            ticket.begin_time = model.begin_time;
            ticket.end_time = model.end_time;
            ticket.remain_times = model.remain_times;
            ticket.code_desc = model.code_desc;
            ticket.comp_id = model.comp_id;
            ticket.comp_name = model.comp_name;
            ticket.pay_flag = model.pay_flag;
            ticket.times_limit = model.times_limit;
            self.defaultTicketModel = ticket;
            self.selectTicketModel = self.defaultTicketModel;
            _ticketName = [NSString stringWithFormat:@"%@%@",[self.selectTicketModel.comp_name isEqualToString:@""]?@"":self.selectTicketModel.comp_name,[self.selectTicketModel.code_name isEqualToString:@""]?@"":self.selectTicketModel.code_name];
            _ticketSelected = YES;
            
            [self updateDisplayPayPrice];
        }
        
    }
    [_contextTableView reloadData];
    
}


#pragma mark - 完成登录后刷新

-(void)didLoginByCheckCodeSuccess
{
    _pageIndex = 1;
    _pageSize = 20;
    _remainderSelected = YES;
    [self loadMoreCars];
    [self loadCarServicesByCarNurseModel:_carNurse];
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
        return 1;
    }
    else if (section == 3)
    {
        return 2;
    }
    else
    {
        return 2 ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
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
    if (section == 1 ||section == 2 || section == 3 || section == 4)
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
        else if (section == 2)
        {
            titleLabel.text = @"服务地址";
        }
        else if (section == 3)
        {
            titleLabel.text = @"余额和优惠券";
        }
        else
        {
            titleLabel.text = @"选择支付方式";
        }
        
        [view addSubview:titleLabel];
        
        return view;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 90;
    }
    else
        return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60+SCREEN_WIDTH/3.0;
    }
    else
    {
        return 40;
    }
}

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
        return [self tableView:tableView payWayCellForRowAtIndexPath:indexPath];
    }
}


#pragma mark - 各种cell的cellForRowAtIndexPath

#pragma mark - 各种cell的cellForRowAtIndexPath

- (UITableViewCell*)tableView:(UITableView *)tableView YearlyInspectionCellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YearlyInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:yearlyInspectionCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[YearlyInspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yearlyInspectionCellIdentifier];
    }
//    
    if (self.carNurse)
    {
        [cell setDisplayCarNurseInfo:self.carNurse];
    }
//
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
            
            if (_myCarsArray.count > 2)
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
    
    [cell setDisplayMoreInfo:_serviceLocation.addressString
                withCellType:0
          andPlaceHolderText:@"请指定取车的地点"];
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView payWayCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            TicketPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:ticketPayWayCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[TicketPayWayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ticketPayWayCellIdentifier];
            }
            
            if ([_ticketName isEqualToString:@""] || _ticketName == nil || self.selectTicketModel == nil)
            {
                cell.ticketNameLabel.text = @"";
                cell.ticketPriceLabel.text = @"";
                cell.ticketTypeLabel.text = @"";
                cell.ticketNumberLabel.text = [NSString stringWithFormat:@"%d张可用",_serviceModel.code_count.intValue];
                cell.ticketNumberTitle.hidden = NO;
            }
            else
            {
                cell.ticketNameLabel.text = self.selectTicketModel.comp_name;
                cell.ticketPriceLabel.text = [NSString stringWithFormat:@"%@元",self.selectTicketModel.price];
                cell.ticketTypeLabel.text = self.selectTicketModel.code_name;
                cell.ticketNumberLabel.text = @"";
                cell.ticketNumberTitle.hidden = YES;
            }
            cell.delegate = self;
            if (!_userInfo.member_id)
            {
                cell.ticketNumberTitle.hidden = YES;
                cell.ticketNumberLabel.hidden = YES;
            }
            else
            {
                cell.ticketNumberTitle.hidden = NO;
                cell.ticketNumberLabel.hidden = NO;
            }
            if (_ticketSelected)
            {
                cell.selectIcon.highlighted = YES;
                cell.ticketNumberTitle.hidden = YES;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
            }
            else
            {
                cell.selectIcon.highlighted = NO;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
            }
            return cell;
        }
        else
        {
            PayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:payWayCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[PayWayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payWayCellIdentifier];
            }
            
            [cell setDisplayInfoWithName:@"使用余额" withExtraInfo:_userInfo.account_remainder];
            cell.bottomSepView.hidden = NO;
            
            if (_remainderSelected)
            {
                cell.selectIcon.highlighted = YES;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
            }
            else
            {
                cell.selectIcon.highlighted = NO;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
            }
            return cell;
            
        }
        
    }
    else
    {
        ThirdPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdPayWayCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[ThirdPayWayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:thirdPayWayCellIdentifier];
        }
        
        cell.bottomSepView.hidden = YES;
        
        if (indexPath.row == 0)
        {
            [cell setDisplayInfoWithName:@"微信支付" withThirdType:3];
            if (_currentPayType == 3)
            {
                cell.selectIcon.highlighted = YES;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
            }
            else
            {
                cell.selectIcon.highlighted = NO;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
            }
            
        }
        else if (indexPath.row == 1)
        {
            [cell setDisplayInfoWithName:@"支付宝支付" withThirdType:2];
            if (_currentPayType == 2)
            {
                cell.selectIcon.highlighted = YES;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
            }
            else
            {
                cell.selectIcon.highlighted = NO;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
            }
        }
        else
        {
            [cell setDisplayInfoWithName:@"银联支付" withThirdType:4];
            if (_currentPayType == 4)
            {
                cell.selectIcon.highlighted = YES;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
            }
            else
            {
                cell.selectIcon.highlighted = NO;
                [cell.payNameLabel setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
            }
            
        }
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        AddressSelectViewController *viewController = [[AddressSelectViewController alloc] initWithNibName:@"AddressSelectViewController"
                                                                                                    bundle:nil];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    if (indexPath.section == 3)
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
        if (indexPath.row == 0)
        {
            if (!_ticketEnable)
            {
                [Constants showMessage:@"您没有该服务的优惠券"];
                return;
            }
            else if (_ticketSelected || self.defaultTicketModel == nil)
            {
                MyTicketViewController *viewController = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController"
                                                                                                  bundle:nil];
                
                viewController.serviceType = @"4";
                viewController.delegate = self;
                viewController.targetCarWashID = self.carNurse.car_wash_id;
                viewController.isClubController = self.isClubController;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                [self didFinishTicketSelect:self.defaultTicketModel];
            }
            
        }
        else
        {
            if (_remainderSelected)
            {
                _remainderSelected = NO;
            }
            else
            {
                _remainderSelected = YES;
            }
            [_contextTableView reloadData];
        }
        [self updateDisplayPayPrice];
    }
    if (indexPath.section == 4)
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
        if (indexPath.row == 0)
        {
            if (_currentPayType == 3)
            {
                _currentPayType = -1;
            }
            else
            {
                _currentPayType = 3;
            }
        }
        else if (indexPath.row == 1)
        {
            if (_currentPayType == 2)
            {
                _currentPayType = -1;
            }
            else
            {
                _currentPayType = 2;
            }
        }
        else
        {
            if (_currentPayType == 4)
            {
                _currentPayType = -1;
            }
            else
            {
                _currentPayType = 4;
            }
        }
        [self updateDisplayPayPrice];
        [_contextTableView reloadData];
    }
}

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
        controller.shouldComplete = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didMyCarButtonSelectButtonTouched:(NSIndexPath *)indexPath
{
    _selectedCar = _myCarsArray[indexPath.row];
    
    if ([_selectedCar.car_type isEqualToString:@"1"])
    {
        [self updateDisplayPayPrice];
        
        
    }
    else
    {
        [self updateDisplayPayPrice];
        
        
    }
    [_contextTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                     withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didIntroductionButtonTouched
{
    if (self.carNurse.service_intro_url == nil || [self.carNurse.service_intro_url isEqualToString:@""])
    {
        [Constants showMessage:@"暂无介绍"];
        return;
    }
    ADVModel *headerModel = [[ADVModel alloc] init];
    headerModel.url = self.carNurse.service_intro_url;
    ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController" bundle:nil];
    viewController.advModel = headerModel;
    viewController.forbidAddMark = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didPhoneButtonTouched
{
    if ([Constants canMakePhoneCall])
    {
        [Constants showMessage:@"确认拨打服务热线？"
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"好的", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }
}

#pragma mark - 打电话


- (void)callCustomService
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.carNurse.phone]]];
}

#pragma mark - TicketPayWayDelegate

- (void)didTicketSelectButtonTouched
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
    if (_ticketSelected)
    {
        [self didFinishTicketSelect:nil];
    }
    else
    {
        if (!_ticketEnable)
        {
            [Constants showMessage:@"您没有该服务的优惠券"];
            return;
        }
        else if (self.defaultTicketModel)
        {
            [self didFinishTicketSelect:self.defaultTicketModel];
        }
        else
        {
            MyTicketViewController *viewController = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController"
                                                                                              bundle:nil];
            viewController.serviceType = @"4";
            viewController.delegate = self;
            viewController.targetCarWashID = self.carNurse.car_wash_id;
            viewController.isClubController = self.isClubController;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - MyTicketDelegate

- (void)didFinishTicketSelect:(TicketModel *)model
{
    if (model == nil)
    {
        _ticketSelected = NO;
        self.selectTicketModel = nil;
        _ticketName = @"";
    }
    else
    {
        _ticketName = [NSString stringWithFormat:@"%@%@",[model.comp_name isEqualToString:@""]?@"":model.comp_name,[model.code_name isEqualToString:@""]?@"":model.code_name];
        self.selectTicketModel = model;
        _ticketSelected = YES;
    }
    
    [self updateDisplayPayPrice];
    [_contextTableView reloadData];
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
    if ([_selectedCar.car_type isEqualToString:@"1"])
    {
        [self updateDisplayPayPrice];
        
    }
    else
    {
        [self updateDisplayPayPrice];
        
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

- (void)didFinishEditCar:(CarInfos*)result
{
    [self didFinishAddNewCar];
}

#pragma mark -  AddressSelectDelegate

- (void)didFinishAddressSelect:(LocationModel*)locationModel
{
    _serviceLocation = locationModel;
    [_contextTableView reloadData];
}

#pragma mark - 支付金额更新

- (void)updateDisplayPayPrice
{
    float totalMoney = 0;
    float payMoney = 0;
    float ticketMoeny = 0;
    float remainderMoney = 0;
    
    totalMoney = _serviceModel.member_price.floatValue;
    
    if (_ticketSelected && self.selectTicketModel)
    {
        ticketMoeny = self.selectTicketModel.price.floatValue;
    }
    
    if (_remainderSelected)
    {
        float resetMoney = totalMoney - ticketMoeny;
        if (_userInfo.account_remainder.floatValue >= resetMoney)
        {
            remainderMoney = resetMoney;
        }
        else
        {
            remainderMoney = _userInfo.account_remainder.floatValue;
        }
    }
    
    payMoney = totalMoney - remainderMoney - ticketMoeny;
    if (payMoney < 0)
    {
        payMoney = 0.0;
    }
    
    [_priceLabel setText:[NSString stringWithFormat:@"￥%.2f",payMoney ]];
    
    
}

#pragma mark - 支付


- (IBAction)didOrderPayButtonTouch:(id)sender
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
    if (_serviceLocation == nil)
    {
        [Constants showMessage:@"您还未选择预约的地点"];
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

    
    [self showAlertViewBeforePay];
    
}

#pragma mark - 支付钱的确认alert

- (void)showAlertViewBeforePay
{
    NSMutableString *alertString = [NSMutableString stringWithFormat:@"\n"];
    
    float ticketMoney = 0;
    float yueMoney = 0;
    float payMoney = 0;
    float thirdPayMoney = 0;
    
    payMoney = _serviceModel.member_price.floatValue;
    
    
    if (_ticketSelected && self.selectTicketModel)
    {
        ticketMoney += self.selectTicketModel.price.floatValue;
    }
    
    if (_remainderSelected == YES)
    {
        float resetSubmitMoney = payMoney - ticketMoney;
        if (resetSubmitMoney <= 0)
        {
            yueMoney = 0;
        }
        else if (_userInfo.account_remainder.floatValue >= resetSubmitMoney)
        {
            yueMoney = resetSubmitMoney;
        }
        else
        {
            yueMoney += _userInfo.account_remainder.floatValue;
        }
    }
    if (ticketMoney+yueMoney < payMoney)
    {
        if (_currentPayType < 0)
        {
            [Constants showMessage:@"请选择支付方式"];
            return;
        }
        thirdPayMoney = payMoney - ticketMoney - yueMoney;
        
        if (yueMoney > 0)
        {
            [alertString appendFormat:@"余额支付%.2f\n",yueMoney];
        }
        if (ticketMoney > 0)
        {
            [alertString appendFormat:@"优惠券支付%.2f元\n",ticketMoney];
        }
        
    }
    else
    {
        thirdPayMoney = 0;
        if (yueMoney > 0)
        {
            [alertString appendFormat:@"余额支付%.2f,\n",yueMoney];
        }
        if (ticketMoney > 0)
        {
            [alertString appendFormat:@"优惠券支付%.2f元,\n",ticketMoney];
        }
    }
    
    if (_currentPayType == 3)
    {
        [alertString appendFormat:@"\n微信支付%.2f元，确认支付？",thirdPayMoney];
    }
    else if (_currentPayType == 2)
    {
        [alertString appendFormat:@"\n支付宝支付%.2f元，确认支付？",thirdPayMoney];
    }
    else if (_currentPayType == 4)
    {
        [alertString appendFormat:@"\n银联支付%.2f元，确认支付？",thirdPayMoney];
    }
    else
    {
        [alertString appendFormat:@"\n确认支付？"];
    }
    
    [Constants showMessage:alertString
                  delegate:self
                       tag:530
              buttonTitles:@"取消", @"确定", nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 531 && buttonIndex == 1)
    {
        [self callCustomService];
    }
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
            controller.shouldComplete = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    if (alertView.tag == 530 && buttonIndex == 1)
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
        [submitDic setObject:_carNurse.car_wash_id
                      forKey:@"car_wash_id"];
        [submitDic setObject:_serviceModel.service_type
                      forKey:@"service_type"];
        [submitDic setObject:_userInfo.member_id
                      forKey:@"member_id"];
        [submitDic setObject:@0
                      forKey:@"pay_money"];
        
        
        [submitDic setObject:_serviceModel.service_id
                      forKey:@"service_id"];
        
        [submitDic setObject:@"0"
                      forKey:@"is_super"];
        [submitDic setObject:@2 forKey:@"service_mode"];
        [submitDic setObject:_serviceLocation.addressString forKey:@"service_addr"];
        [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.latitude]
                      forKey:@"latitude"];
        [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.longitude]
                      forKey:@"longitude"];
        
        //
        
        float ticketMoney = 0;
        float yueMoney = 0;
        float payMoney = _serviceModel.member_price.floatValue;
        float thirdPayMoney = 0;
        
        if (_ticketSelected && self.selectTicketModel)
        {
            ticketMoney += self.selectTicketModel.price.floatValue;
        }
        
        if (_remainderSelected == YES)
        {
            float resetSubmitMoney = payMoney - ticketMoney;
            if (resetSubmitMoney <= 0)
            {
                yueMoney = 0;
            }
            else if (_userInfo.account_remainder.floatValue >= resetSubmitMoney)
            {
                yueMoney = resetSubmitMoney;
            }
            else
            {
                yueMoney += _userInfo.account_remainder.floatValue;
            }
            
        }
        
        if (ticketMoney+yueMoney < _serviceModel.member_price.floatValue)
        {
            thirdPayMoney = payMoney - ticketMoney - yueMoney;
            
            PayModel *model = [[PayModel alloc] initWithDictionary:submitDic];
            model.code_id = self.selectTicketModel.code_id;
            model.pay_money = [NSString stringWithFormat:@"%.2f",thirdPayMoney];
            model.remainder = [NSString stringWithFormat:@"%.2f",yueMoney];
            if (_currentPayType == 3)
            {
                [PayHelper startCarNurseWXpayWithModel:model];
            }
            else if (_currentPayType == 2)
            {
                [PayHelper startCarNurseAlipayWithModel:model];
            }
            else if (_currentPayType == 4)
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [PayHelper startUnionPayWithModel:model
                                   normalResponse:^(UnionPayResopne *payRespone)
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view
                                              animated:YES];
                     //银联
//                     [UPPayPlugin startPay:payRespone.trade_no
//                                      mode:payRespone.mode
//                            viewController:self
//                                  delegate:self];
                     
                 }
                                exceptionResponse:^(NSError *error) {
                                    [MBProgressHUD hideAllHUDsForView:self.view
                                                             animated:YES];
                                    [Constants showMessage:[error domain]];
                                }];
            }
        }
        else
        {
            
            if (_remainderSelected == YES)
            {
                [submitDic setValue:@1
                             forKey:@"pay_type"];
                [submitDic setValue:[NSString stringWithFormat:@"%.2f",yueMoney]
                             forKey:@"pay_money"];
            }
            
            if (_ticketSelected && self.selectTicketModel)
            {
                [submitDic setObject:self.selectTicketModel.code_id
                              forKey:@"code_id"];
                [submitDic setValue:@5
                             forKey:@"pay_type"];
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [WebService requestJsonOperationWithParam:submitDic
                                               action:@"order/service/manage"
                                       normalResponse:^(NSString *status, id data)
             {
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
                             [Constants showMessage:@"\n订单支付成功！\n\n为保证更好的服务体验，我们将会与您充分的沟通"];
                         }
                     }
                     else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
                     {
                         [Constants showMessage:@"\n订单支付成功！\n\n为保证更好的服务体验，我们将会与您充分的沟通"];
                     }
                     else
                     {
                         [_appDelegate showAlertMessageForRegisterNotifacation:@"\n订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
                     }
                     
                     if (_ticketSelected && self.selectTicketModel)
                     {
                         
                     }
                     else
                     {
                         _userInfo.account_remainder = [NSString stringWithFormat:@"%.2f", [_userInfo.account_remainder doubleValue] - yueMoney];
                     }
                     
                     [[NSUserDefaults standardUserDefaults] setValue:_userInfo.convertToDictionary forKey:kUserInfoKey];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
                     [tmpArray removeLastObject];
                     if ([_appconfig.open_share_order_flag isEqualToString:@"1"])
                     {
                         OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                                                   bundle:nil];
                         
                         viewController.share_order_url = [data objectForKey:@"share_order_url"];
                         viewController.isClubController = self.isClubController;
                         
                         [tmpArray addObject:viewController];
                     }
                     else
                     {
                         MyOrdersController *viewController = [[MyOrdersController alloc] initWithNibName:@"MyOrdersController" bundle:nil];
                         [tmpArray addObject:viewController];
                     }
                     [self.navigationController setViewControllers:tmpArray animated:YES];
                     
                 }
                 else
                 {
                     [MBProgressHUD hideHUDForView:self.view animated:NO];
                     [MBProgressHUD showError:@"订单支付失败" toView:self.navigationController.view];
                     
                 }
             }
                                    exceptionResponse:^(NSError *error)
             {
                 [MBProgressHUD hideHUDForView:self.view
                                      animated:NO];
                 [Constants showMessage:[error domain]];
             }];
            
        }
    }
}


#pragma mark - 支付相关

- (void)addPayNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paySuccess:)
                                                 name:kPaySuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxPaySuccess:)
                                                 name:kWXPaySuccessNotification
                                               object:nil];
}

- (void)removePayNotifaction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kPaySuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kWXPaySuccessNotification
                                                  object:nil];
}

- (void)paySuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.object;
    
    if (![[userInfo valueForKey:@"resultStatus"] isEqualToString:@"9000"])
    {
        [Constants showMessage:[userInfo valueForKey:@"memo"]];
        if ([[userInfo valueForKey:@"resultStatus"] isEqualToString:@"6001"])
        {
            [_appDelegate submitUserCancelPayOpreationWithOutTradeNo:_aliPayOutTradeNo];
        }
    }
    else
    {
        if (bIsiOS7)
        {
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
            {
                [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
            }
            else
            {
                [Constants showMessage:@"订单支付成功！"];
            }
        }
        else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
        {
            [Constants showMessage:@"订单支付成功！"];
        }
        else
        {
            [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
        }
        NSString *resultStr = [userInfo valueForKey:@"result"];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSArray *arr = [resultStr componentsSeparatedByString:@"&"];
        for (NSString *tmpStr in arr)
        {
            if ([tmpStr rangeOfString:@"out_trade_no"].location != NSNotFound)
            {
                out_trade_no = _aliPayOutTradeNo;
                _errorTime = 0;
                [MBProgressHUD showMessag:@"正在查询订单信息" toView:self.view];
                self.view.userInteractionEnabled = NO;
                [self removePayNotifaction];
                [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:out_trade_no afterDelay:3.0];
                break;
                
            }
        }
    }
}

- (void)wxPaySuccess:(NSNotification *)notification
{
    if (bIsiOS7)
    {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
        {
            [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
        }
        else
        {
            [Constants showMessage:@"订单支付成功！"];
        }
    }
    else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
    {
        [Constants showMessage:@"订单支付成功！"];
    }
    else
    {
        [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
    }
    [self removePayNotifaction];
    _errorTime = 0;
    [MBProgressHUD showMessag:@"正在查询订单信息"
                       toView:self.view];
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(checkPayOrderWithOutTradeNo:)
               withObject:notification.object afterDelay:3.0];
}

- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"])
    {
        if (bIsiOS7)
        {
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone )
            {
                [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
            }
            else
            {
                [Constants showMessage:@"订单支付成功！"];
            }
        }
        else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
        {
            [Constants showMessage:@"订单支付成功！"];
        }
        else
        {
            [_appDelegate showAlertMessageForRegisterNotifacation:@"订单支付成功！\n\n为了提供更好的服务，请允许接收推送通知"];
        }
        _errorTime = 0;
        [MBProgressHUD showMessag:@"正在查询订单信息" toView:self.view];
        self.view.userInteractionEnabled = NO;
        [self removePayNotifaction];
        [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:[PayHelper getUnionPayOutTradeNo] afterDelay:3.0];
    }
    else if ([result isEqualToString:@"fail"])
    {
        [Constants showMessage:@"支付失败"];
    }
    else
    {
        [Constants showMessage:@"支付取消"];
        [_appDelegate submitUserCancelPayOpreationWithOutTradeNo:[PayHelper getUnionPayOutTradeNo]];
        
    }
    
}

- (void)checkPayOrderWithOutTradeNo:(NSString*)string
{
    NSDictionary *submitDic = @{@"out_trade_no": string};
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"third/pay/checkPay"
                               normalResponse:^(NSString *status, id data)
     {
         NSLog(@"third/pay/checkPay %@",data);
         self.view.userInteractionEnabled = YES;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
         [tmpArray removeLastObject];
         if ([_appconfig.open_share_order_flag isEqualToString:@"1"])
         {
             OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                                       bundle:nil];
             
             viewController.share_order_url = [data objectForKey:@"share_order_url"];
             viewController.isClubController = self.isClubController;
             
             [tmpArray addObject:viewController];
         }
         else
         {
             MyOrdersController *viewController = [[MyOrdersController alloc] initWithNibName:@"MyOrdersController" bundle:nil];
             [tmpArray addObject:viewController];
         }
         [self.navigationController setViewControllers:tmpArray animated:YES];
         
         
         
     }
                            exceptionResponse:^(NSError *error)
     {
         if (_errorTime < 3)
         {
             _errorTime++;
             [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:string afterDelay:3.0];
         }
         else
         {
             self.view.userInteractionEnabled = YES;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
             [self addPayNotifaction];
         }
         
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
