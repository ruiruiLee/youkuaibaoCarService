//
//  CarServiceOrderViewController.m
//  疯狂洗车
//
//  Created by cts on 15/11/11.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "CarServiceOrderViewController.h"
#import "MBProgressHUD+Add.h"
#import "CarServiceDetailCell.h"
#import "ServiceMoreRequestCell.h"
#import "PayWayCell.h"
#import "ThirdPayWayCell.h"
#import "TicketPayWayCell.h"
#import "ServiceModeRequestModel.h"
#import "OrderTimerPickerView.h"
#import "MoreRequestViewController.h"
#import "AddressSelectViewController.h"
#import "OrderSuccessViewController.h"
#import "MyTicketViewController.h"
//#import "UPPayPlugin.h"
//#import "UPPayPluginDelegate.h"
#import "UIView+Toast.h"
#import "PayHelper.h"
#import "MyOrdersController.h"
#import "OrderRealPayInfoCell.h"


@interface CarServiceOrderViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TicketPayWayCellDelegate,
MyTicketDelegate,
UIActionSheetDelegate,
//UPPayPluginDelegate,
MoreRequestDelegate,
OrderTimerPickerViewDelegate,
AddressSelectDelegate>
{
    
    IBOutlet UITableView *_contextTableView;//内容显示tableview
    
    OrderTimerPickerView *_orderTimerPickerView;//订单时间选择View
    
    LocationModel        *_serviceLocation;//服务地址数据模型
    
    NSMutableArray       *_moreRequestModelArray;//更多需求元素数组
    
    IBOutlet UILabel     *_priceLabel;
    
    NSInteger             _currentPayType;//当前支付方式
    
    NSIndexPath          *_currentCarIndexPath;//当前车辆选择index
    
    NSString             *out_trade_no;//订单号
    
    NSMutableArray       *_ticketArray;//用户优惠券数组
    
    NSString             *_ticketName;
    
    IBOutlet UIView      *_bottomSubmitView;
    
    int                   _errorTime;
    
    BOOL                  _ticketEnable;//是否可以使用券
    
    BOOL                  _remainderSelected;//是否支付时使用余额
    
    BOOL                  _ticketSelected;//是否支付时使用优惠券
    
    
}

@property (strong, nonatomic) TicketModel *selectTicketModel;//选中的优惠券模型

@property (assign, nonatomic) BOOL         isForRecuse;//是否是救援服务(业务调整暂废)

@end

@implementation CarServiceOrderViewController

static NSString *carServiceDetailCellIdentifier = @"CarServiceDetailCell";

static NSString *serviceMoreRequestCellIdentifier = @"ServiceMoreRequestCell";

static NSString *payWayCellIdentifier = @"PayWayCell";

static NSString *ticketPayWayCellIdentifier = @"TicketPayWayCell";

static NSString *thirdPayWayCellIdentifier = @"ThirdPayWayCell";

static NSString *orderRealPayInfoCellIdentifier = @"OrderRealPayInfoCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _remainderSelected = YES;

    _currentPayType = 3;
    
    //若果存在服务器推荐优惠券则显示并选中该优惠券
    if (self.defaultTicketModel)
    {
        _ticketEnable = YES;
        _selectTicketModel = self.defaultTicketModel;
        _ticketName = [NSString stringWithFormat:@"%@%@",
                       [_selectTicketModel.comp_name isEqualToString:@""]?@"":_selectTicketModel.comp_name,
                       [_selectTicketModel.code_name isEqualToString:@""]?@"":_selectTicketModel.code_name];
        _ticketSelected = YES;

    }
    
    //根据是否是服务方式加载更多表单cell
    _moreRequestModelArray = [self creatMoreRequestArrayDependOnService];
    
    [_contextTableView registerNib:[UINib nibWithNibName:carServiceDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:carServiceDetailCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:serviceMoreRequestCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:serviceMoreRequestCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:payWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:payWayCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:thirdPayWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:thirdPayWayCellIdentifier];
    

    

    
    [_contextTableView registerNib:[UINib nibWithNibName:ticketPayWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:ticketPayWayCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:orderRealPayInfoCellIdentifier
                                                  bundle:[NSBundle mainBundle]] forCellReuseIdentifier:orderRealPayInfoCellIdentifier];
    
    _contextTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (SCREEN_WIDTH < 375)
    {
        
        for (int x = 0; x<_bottomSubmitView.constraints.count; x++)
        {
            NSLayoutConstraint *layoutConstraint = _bottomSubmitView.constraints[x];
            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
            {
                [_bottomSubmitView removeConstraint:layoutConstraint];
                break;
            }
            
        }
        
        NSDictionary* views = NSDictionaryOfVariableBindings(_bottomSubmitView);
        NSString *constrainString = [NSString stringWithFormat:@"V:[_bottomSubmitView(50)]"];
        
        [_bottomSubmitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:views]];
    }

    if (self.isForRecuse)
    {
        [self setTitle:@"救援"];
    }
    else
    {
        if (self.isShangMen)
        {
            [self setTitle:@"上门取送"];
            _serviceModel.isShangmen = YES;
        }
        else
        {
            [self setTitle:@"到店服务"];
        }
    }
    
    int minHour = 0 ;
    int maxHour = 0;
    
    //设置时间选择弃的时间最小小时
    if ([_carNurse.business_hours_from isEqualToString:@""] || _carNurse.business_hours_from == nil)
    {
        minHour = 34200.0;
    }
    else
    {
        NSArray *timeArray = [_carNurse.business_hours_from componentsSeparatedByString:@":"];
        
        NSString *hourString = timeArray[0];
        NSString *minuteString = timeArray[1];
        
        minHour = (hourString.intValue*60 + minuteString.intValue)*60;
        
        
    }
    
    //设置时间选择器的最大小时
    if ([_carNurse.business_hours_to isEqualToString:@""] || _carNurse.business_hours_to == nil)
    {
        maxHour = 63000.0;
    }
    else
    {
        NSArray *timeArray = [_carNurse.business_hours_to componentsSeparatedByString:@":"];
        
        NSString *hourString = timeArray[0];
        NSString *minuteString = timeArray[1];
        
        maxHour = (hourString.intValue*60 + minuteString.intValue)*60;
        
        NSLog(@"目标营业时间 %@ %@",_carNurse.business_hours_from,_carNurse.business_hours_to);
        
    }

    
    _orderTimerPickerView = [[OrderTimerPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                          withTimeRange:NSMakeRange(minHour, maxHour)];
    _orderTimerPickerView.delegate = self;
    _orderTimerPickerView.showLimite = YES;
    
    self.view.userInteractionEnabled = NO;
    [self getUserAllTicketsFromService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addPayNotifaction];//添加支付成功消息坚挺
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removePayNotifaction];//移除支付成功消息坚挺
}

- (void)getUserAllTicketsFromService
{
    self.view.userInteractionEnabled = YES;
    if (!_userInfo.member_id)//根据是否登录更新显示
    {
        
        [self updateDisplayPayPrice];
    }
    else
    {
        if (self.selectTicketModel)
        {
            
        }
        else if (self.serviceModel.code_count.intValue > 0)
        {
            _ticketEnable = YES;
            _ticketSelected = NO;
        }
        
        [self updateDisplayPayPrice];
    }
    
}

#pragma mark - 若果存在服务器推荐优惠券则显示并选中该优惠券 Method

- (NSMutableArray*)creatMoreRequestArrayDependOnService
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (self.isShangMen)
    {
        ServiceModeRequestModel *timeModel = [[ServiceModeRequestModel alloc] init];
        timeModel.modelType = ServiceModeRequestTypeTime;
        timeModel.placeHolderText = @"请选择服务时间";
        
        ServiceModeRequestModel *addrModel = [[ServiceModeRequestModel alloc] init];
        addrModel.modelType = ServiceModeRequestTypeAddress;
        addrModel.placeHolderText = @"请选择服务地址";
        
        [resultArray addObjectsFromArray:@[timeModel,addrModel]];
    }
    
    ServiceModeRequestModel *model = [[ServiceModeRequestModel alloc] init];
    model.modelType = ServiceModeRequestTypeMore;
    model.placeHolderText = @"更多需求";
    [resultArray addObject:model];
    
    
    return resultArray;
}


#pragma mark UITableViewDataSource Method

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
        return _moreRequestModelArray.count;
    }
    else if (section == 2)
    {
        return 2;
    }
    else if (section == 3)
    {
        return 1;
    }
    else
    {
        return 2;//支付
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if (section == 3)
    {
        return 10;
    }
    else
    {
        return 30;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 ||section == 2 || section == 4 )
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
        titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:13];
        
        if (section == 1)
        {
            titleLabel.text = @"服务信息";
        }
        else if (section == 2)
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
    else if (section == 3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
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
    {
        return 0;
    }
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
        CGSize messageSize = CGSizeMake(SCREEN_WIDTH-62, MAXFLOAT);
        
        
        CGSize contentSize =[_serviceModel.service_content boundingRectWithSize:messageSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                context:nil].size;
        CGSize accessoriesSize =[_serviceModel.accessories boundingRectWithSize:messageSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                context:nil].size;
        
        float contentHight = 0;
        if (contentSize.height >= 17)
        {
            contentHight = contentSize.height - 17;
        }
        
        float accessoriesHeight = 0;
        if (accessoriesSize.height >= 17)
        {
            accessoriesHeight = accessoriesSize.height - 17;
        }
        return 173+contentHight+accessoriesHeight;
    }
    else if (indexPath.section == 3)
    {
        return 160;
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
        return [self tableView:tableView carServiceDetailCellForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 1)
    {
        return [self tableView:tableView serviceMoreRequestCellForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 3)
    {
        return [self tableView:tableView orderRealPayCellForRowAtIndexPath:indexPath];
    }
    else
    {
        return [self tableView:tableView payWayCellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - 各种cell的cellForRowAtIndexPath Method
#pragma mark - 车服务详情cell
- (UITableViewCell*)tableView:(UITableView *)tableView carServiceDetailCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarServiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:carServiceDetailCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CarServiceDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:carServiceDetailCellIdentifier];
    }
    
    [cell setDisplayCarServiceDetailInfoWithCarNurse:self.carNurse
                                          andCarInfo:self.serviceCar
                                  andCarNurseService:self.serviceModel];
    
    return cell;
}
#pragma mark - 更多需求cell

- (UITableViewCell*)tableView:(UITableView *)tableView serviceMoreRequestCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceMoreRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceMoreRequestCellIdentifier];
    if (cell == nil)
    {
        cell = [[ServiceMoreRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceMoreRequestCellIdentifier];
    }
    
    [cell setDisplayMoreInfoWithServiceModeRequest:_moreRequestModelArray[indexPath.row]];
    return cell;
}

#pragma mark - 用户支付详情cell

- (UITableViewCell*)tableView:(UITableView *)tableView orderRealPayCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderRealPayInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:orderRealPayInfoCellIdentifier];
    if (cell == nil)
    {
        cell = [[OrderRealPayInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:orderRealPayInfoCellIdentifier];
    }
    
    if (!_userInfo.member_id)
    {
        [cell setUpDisplayPayInfoPrice:0
                        andTicketPrice:0
                     andRemainderPrice:0
                           andPayPrice:0];
        
    }
    else
    {
        float totalMoney = _serviceModel.member_price.floatValue;
        float payMoney = 0;
        float ticketMoeny = 0;
        float remainderMoney = 0;
        
        
        
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
        [cell setUpDisplayPayInfoPrice:totalMoney
                        andTicketPrice:ticketMoeny
                     andRemainderPrice:remainderMoney
                           andPayPrice:payMoney];
    }
    
    return cell;
}

#pragma mark - 支付方式cell

- (UITableViewCell*)tableView:(UITableView *)tableView payWayCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
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

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        ServiceModeRequestModel *targetModel = _moreRequestModelArray[indexPath.row];
        if (targetModel.modelType == ServiceModeRequestTypeTime)
        {
            [_orderTimerPickerView showOrderTimerPickerView];
        }
        else if (targetModel.modelType == ServiceModeRequestTypeAddress ||targetModel.modelType == ServiceModeRequestTypeAddress)
        {
            AddressSelectViewController *viewController = [[AddressSelectViewController alloc] initWithNibName:@"AddressSelectViewController"
                                                                                                        bundle:nil];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
        else if (targetModel.modelType == ServiceModeRequestTypeMore)
        {
            MoreRequestViewController *viewController = [[MoreRequestViewController alloc] initWithNibName:@"MoreRequestViewController"
                                                                                                    bundle:nil];
            viewController.delegate = self;
            if (targetModel.valueString != nil && ![targetModel.valueString isEqualToString:@""])
            {
                viewController.requestString = targetModel.valueString;
            }
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
    }
    else if (indexPath.section == 2)
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
                
                viewController.serviceType = _serviceModel.service_type;
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
    else if (indexPath.section == 4)
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

#pragma mark - TicketPayWayDelegate Method

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
            viewController.serviceType = @"8";
            viewController.delegate = self;
            viewController.targetCarWashID = self.carNurse.car_wash_id;
            viewController.isClubController = self.isClubController;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - MyTicketDelegate Method

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


#pragma mark -  AddressSelectDelegate Method

- (void)didFinishAddressSelect:(LocationModel*)locationModel
{
    _serviceLocation = locationModel;
    for (int x = 0; x<_moreRequestModelArray.count; x++)
    {
        ServiceModeRequestModel *targetModel = _moreRequestModelArray[x];
        if (targetModel.modelType == ServiceModeRequestTypeAddress)
        {
            targetModel.valueString =  _serviceLocation.addressString;
            break;
        }
    }
    [_contextTableView reloadData];
}

#pragma mark - 用户完成服务时间选择 Method

- (void)didFinishOrderTimerPicker:(NSString *)resultString
{
    for (int x = 0; x<_moreRequestModelArray.count; x++)
    {
        ServiceModeRequestModel *targetModel = _moreRequestModelArray[x];
        if (targetModel.modelType == ServiceModeRequestTypeTime)
        {
            targetModel.valueString =  resultString;
            break;
        }
    }
    [_contextTableView reloadData];
}

#pragma mark - MoreRequestDelegate  Method

- (void)didFinishMoreRequestEditing:(NSString*)contextString
{
    for (int x = 0; x<_moreRequestModelArray.count; x++)
    {
        ServiceModeRequestModel *targetModel = _moreRequestModelArray[x];
        if (targetModel.modelType == ServiceModeRequestTypeMore)
        {
            targetModel.valueString =  contextString;
            break;
        }
    }
    [_contextTableView reloadData];
}


#pragma mark - 支付金额更新  Method

- (void)updateDisplayPayPrice
{
    float totalMoney = _serviceModel.member_price.floatValue;
    float payMoney = 0;
    float ticketMoeny = 0;
    float remainderMoney = 0;
    
    
    
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

#pragma mark - 支付下单 Method

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
    BOOL otherInfoOk = YES;
    for (int x = 0; x<_moreRequestModelArray.count; x++)
    {
        ServiceModeRequestModel *targetModel = _moreRequestModelArray[x];
        if ([targetModel.valueString isEqualToString:@""] || targetModel.valueString == nil)
        {
            if (targetModel.modelType == ServiceModeRequestTypeTime)
            {
                [Constants showMessage:@"您还未选择预约的时间"];
                otherInfoOk = NO;
                break;
            }
            else if (targetModel.modelType == ServiceModeRequestTypeAddress)
            {
                [Constants showMessage:@"您还未选择预约的地点"];
                otherInfoOk = NO;
                break;
            }

        }
    }
    if (!otherInfoOk)
    {
        return;
    }
    
    [self showAlertViewBeforePay];
    
}

#pragma mark - 显示支付钱的确认alert Method

- (void)showAlertViewBeforePay
{
    NSMutableString *alertString = [NSMutableString stringWithFormat:@"\n"];
    
    float ticketMoney = 0;
    float yueMoney = 0;
    float payMoney = 0;
    
    payMoney = _carNurse.member_price.floatValue;
    
    
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
    }
    [alertString appendFormat:@"\n确认支付？"];

    [Constants showMessage:alertString
                  delegate:self
                       tag:530
              buttonTitles:@"取消", @"确定", nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
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
        [submitDic setObject:_serviceCar.car_id
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
        
        BOOL serviceAddrSet = NO;

        for (int x = 0; x<_moreRequestModelArray.count; x++)
        {
            ServiceModeRequestModel *targetModel = _moreRequestModelArray[x];
            if (![targetModel.valueString isEqualToString:@""] && targetModel.valueString != nil)
            {
                if (targetModel.modelType == ServiceModeRequestTypeTime)
                {
                    [submitDic setObject:[NSString stringWithFormat:@"%@",targetModel.valueString]
                                  forKey:@"service_time"];
                    continue;
                }
                else if (targetModel.modelType == ServiceModeRequestTypeAddress)
                {
                    [submitDic setObject:@2 forKey:@"service_mode"];
                    [submitDic setObject:[NSString stringWithFormat:@"%@",targetModel.valueString]
                                  forKey:@"service_addr"];
                    [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.latitude]
                                  forKey:@"latitude"];
                    [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.longitude]
                                  forKey:@"longitude"];
                    serviceAddrSet = YES;
                    continue;
                }
                else if (targetModel.modelType == ServiceModeRequestTypeMore)
                {
                    [submitDic setObject:[NSString stringWithFormat:@"%@",targetModel.valueString]
                                  forKey:@"requiry"];
                    continue;
                }
                
            }
        }

        if (!serviceAddrSet)
        {
            [submitDic setObject:@1 forKey:@"service_mode"];
        }

        
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
                     [tmpArray removeObjectsInRange:NSMakeRange(tmpArray.count-2, 2)];
                    // [tmpArray removeLastObject];
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


#pragma mark - 支付相关 Method

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

//支付宝支付回调通知
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

//微信支付回调通知
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

//银联支付回调通知
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

#pragma mark - 向服务器确认订单状态 Method

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
