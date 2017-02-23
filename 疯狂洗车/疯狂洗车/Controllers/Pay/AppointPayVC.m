//
//  AppointPayVC.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "AppointPayVC.h"
#import "MyTicketViewController.h"
#import "PaySuccessedVC.h"
#import "AppointSuccessVC.h"
#import "UIView+Toast.h"
#import "OwnerStoreCarWashModel.h"
#import "ThirdPayWayCell.h"
#import "WXApi.h"
#import "PayHelper.h"
#import "TicketMaxPriceModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"

#import "define.h"

#define Pay_Format  @"%.2f元"

@interface AppointPayVC () <MyTicketDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    OwnerStoreCarWashModel *_carWashModel;
    
    NSInteger       _currentPayType;
    
    NSInteger _errorTime;
    
    NSArray *_memberList;//获取免费券的member_price
}

@end

@implementation AppointPayVC

static NSString *thirdPayWayCellIdentifier = @"ThirdPayWayCell";

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"支付"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxPaySuccess:)
                                                 name:kWXPaySuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(paySuccess:)
                                                 name:kPaySuccessNotification
                                               object:nil];
    
    _currentPayType = 3;
    _errorTime = 0;
    
    _ticketPayStatus = YES;
    _balancePayStatus = YES;
    _buyouhuiStatus = NO ;
    [self.btnTicketSelect setImage:[UIImage imageNamed:@"btn_select_light_selected"] forState:UIControlStateSelected];
    [self.btnBalanceSelect setImage:[UIImage imageNamed:@"btn_select_light_selected"] forState:UIControlStateSelected];
    [self.btnShowBuYouHui setImage:[UIImage imageNamed:@"btn_select_light_selected"] forState:UIControlStateSelected];
    
    self.tfAmount.delegate = self;
    self.tfBuYouHuiAmount.delegate = self;
    
    self.btnPay.layer.cornerRadius = 4;
    self.screenWidth.constant = STATIC_SCREEN_WIDTH;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(closeKeyBoard)];
    tapGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.tableview registerNib:[UINib nibWithNibName:thirdPayWayCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:thirdPayWayCellIdentifier];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(_appointModel.pay_price != nil && ![_appointModel.pay_price isKindOfClass:[NSNull class]]){
        self.tfAmount.text = _appointModel.pay_price;
    }
    
    if(_appointModel.bcyyh_price != nil && ![_appointModel.bcyyh_price isKindOfClass:[NSNull class]] && [_appointModel.bcyyh_price doubleValue] > 0){
        self.tfBuYouHuiAmount.text = _appointModel.bcyyh_price;
        _buyouhuiStatus = YES;
        self.btnShowBuYouHui.selected = YES;
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

    [MBProgressHUD showMessag:@"正在查询订单信息"
                       toView:self.view];
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(deleteReservesWithOutTradeNo:)
               withObject:notification.object afterDelay:3.0];

}

#pragma mark - 向服务器确认订单状态 Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetData];
}

- (void) loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GPSLocationManager *manager = ((AppDelegate *)[UIApplication sharedApplication].delegate).gpsLocationManager;
    CLLocation *location = [manager getUserCurrentLocation];
    
    [WebService requestJsonWXOperationWithParam:@{ @"member_id": _appointModel.member_id,
                                                   @"longitude": [NSNumber numberWithDouble:location.coordinate.longitude],
                                                   @"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
                                                   @"ob": @"price",
                                                   @"service_type": _appointModel.service_type}
                                         action:@"carWash/service/ownstore"
                                 normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         
         _carWashModel = [[OwnerStoreCarWashModel alloc] initWithDictionary:data];
         
         [self resetData];
         
     }
                              exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
     }];
}

- (void) loadBalance
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"member/service/get"
                               modelClass:[UserInfo class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         
         if (status.intValue > 0)
         {
             UserInfo *userInfo = (UserInfo *)model;
             _userInfo.account_remainder = userInfo.account_remainder;
             [[NSUserDefaults standardUserDefaults] setObject:[_userInfo convertToDictionary]
                                                       forKey:kUserInfoKey];
             //    [[NSUserDefaults standardUserDefaults] setObject:userInfo.token forKey:kLoginToken];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [self resetData];
         }
         else
         {
             
         }
     }
                        exceptionResponse:^(NSError *error) {
                            [MBProgressHUD hideHUDForView:self.view animated:NO];
                            [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
                            
                        }];
}

- (void) setAppointModel:(AppointInfo *) model
{
    _appointModel = model;
    
    if(_appointModel.pay_price != nil && ![_appointModel.pay_price isKindOfClass:[NSNull class]]){
        self.tfAmount.text = _appointModel.pay_price;
    }
    
    [self resetData];
    [self loadData];
    [self loadBalance];
    [self requestTicketPay];
}

- (void) resetData
{
    self.lbOrderInfo.text = [NSString stringWithFormat:@"%@/%@", _appointModel.service_name, _appointModel.car_no];
    
    [self showTicketPay:(_carWashModel && _carWashModel.code_count == 0)?NO:YES];
    [self showBanancePay:([_userInfo.account_remainder doubleValue] > 0.0) ? YES:NO];
    self.lbTicketName.text = [NSString stringWithFormat:@"%@", _carWashModel.code_name];
    
    NSString *str = [NSString stringWithFormat:@"可用余额%@元", _userInfo.account_remainder];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"%@", _userInfo.account_remainder]];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSForegroundColorAttributeName
     
                value:_COLOR(0xff, 0x66, 0x19)
     
                range:range];
    
    [att addAttribute:NSFontAttributeName
     
                value:_FONT(18)
     
                range:range];
    
    self.lbBalance.attributedText = att;
    
    if(_buyouhuiStatus){
        self.bucanyuyouhuijineHeight.constant = 40;
    }
    else{
        self.bucanyuyouhuijineHeight.constant = 0;
        self.tfBuYouHuiAmount.text = @"";
    }
    
    double amount = [_tfAmount.text doubleValue];
    double no = [_tfBuYouHuiAmount.text doubleValue];
    if(no > amount)
        no = amount;
    double account = amount - no;
    
    self.btnTicketSelect.selected = _ticketPayStatus;
    self.btnBalanceSelect.selected = _balancePayStatus;
    self.btnShowBuYouHui.selected = _buyouhuiStatus;
    
    double ticket = 0;
    if(_ticketPayStatus && _carWashModel.code_count > 0){
        ticket = _carWashModel.price;
        if(ticket == 100000){
            ticket = [self getTicketValue:ticket name:_carWashModel.code_name serviceType:[_appointModel.service_type integerValue]];
        }
        else if (ticket > 10000 && ticket < 100000){
            ticket = account - (int)(account * ticket / 100000.0);
        }
    }
    
    if(account < ticket)
        ticket = account;
    
    double balance = 0;
    if([_userInfo.account_remainder doubleValue] > 0.0 && _balancePayStatus)
        balance = [_userInfo.account_remainder doubleValue];
    
    [self calculateActualPay:amount ticket:ticket balance:balance];
}

- (double) getTicketValue:(double) ticket name:(NSString*) name serviceType:(NSInteger) type
{
    if(type == 2){
        if(ticket == 100000){
            return [self getMaxCarPriceForBanPen:name];
        }
    }else{
        if(ticket == 100000){
            return [self getMaxCarPriceForBaoYang:name];
        }
    }
    
    return ticket;
}

- (void) showBanancePay:(BOOL) flag
{
    self.lbBalance.hidden = !flag;
    self.btnBalanceSelect.hidden = !flag;
    self.lbBalanceTitle.hidden = !flag;
    
    self.lbLine.hidden = !flag;
    
    if(!flag){
        _balancePayStatus = NO;
        self.yueHeight.constant = 0;
        self.yuepayHeight.constant = 0;
    }else{
        self.yueHeight.constant = 40;
        self.yuepayHeight.constant = 40;
    }
}

- (void) showTicketPay:(BOOL) flag
{
    self.lbTicketName.hidden = !flag;
    self.btnTicketSelect.hidden = !flag;
    self.lbTicketTitle.hidden = !flag;
    self.imageShut.hidden = !flag;
    self.btnTicketShow.hidden = !flag;
    
    self.lbNoTicket.hidden = flag;
    
    if(!flag){
        _ticketPayStatus = NO;
        self.youhuiquanpayHeight.constant = 0;
        self.bucanyuyouhuijineselectHeight.constant = 0;
        _buyouhuiStatus = NO;
    }else{
        self.youhuiquanpayHeight.constant = 40;
        self.bucanyuyouhuijineselectHeight.constant = 32;
    }
}

- (IBAction)btnSelectNewTickets:(id)sender
{
    MyTicketViewController *viewController = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController"
                                                                                      bundle:nil];
    
    viewController.serviceType = _carWashModel.service_type;
    viewController.delegate = self;
    viewController.targetCarWashID = _carWashModel.car_wash_id;
    viewController.isClubController = self.isClubController;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFinishTicketSelect:(TicketModel *)model
{
    if (model == nil)
    {
//        _ticketSelected = NO;
//        self.selectTicketModel = nil;
//        [_ticketPayTitle setTextColor:[UIColor blackColor]];
//        _ticketPaySelectIcon.highlighted = NO;
//        _ticketNameLabel.text = @"";
//        _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张可用",self.serviceModel.code_count.intValue];
//        _ticketNumberTitle.hidden = NO;
//        
//        _ticketPriceLabel.text = @"";
//        _ticketTypeLabel.text = @"";
    }
    else
    {
        _carWashModel.code_id = model.code_id;
        _carWashModel.code_desc = model.code_desc;
        _carWashModel.code_name = model.code_name;
        _carWashModel.code_status = model.code_status;
        _carWashModel.code_content = model.code_content;
        _carWashModel.price = [model.price doubleValue];
    }
    
    [self resetData];
}

- (IBAction)doBtnPay:(id)sender
{
    double account = [_tfAmount.text doubleValue];
    if(account <= 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"清联系工作人员确定本次消费总金额！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认支付吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

- (IBAction)doBtnTicketPaySelect:(id)sender
{
    _ticketPayStatus = !_ticketPayStatus;
    
    [self resetData];
}

- (IBAction)doBtnBalancePaySelect:(id)sender
{
    _balancePayStatus = !_balancePayStatus;
    
    [self resetData];
}

- (IBAction)doBtnBuYouHuiJinE:(id)sender
{
    _buyouhuiStatus = !_buyouhuiStatus;
    
    [self resetData];
}

- (void) requestTicketPay
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebService requestJsonArrayWXOperationWithParam:@{ @"carWashId": _appointModel.car_wash_id,
                                                        @"serviceType": _appointModel.service_type}
                                              action:@"serviceCode/service/queryFxcServices"
                                          modelClass:[TicketMaxPriceModel class]
                                      normalResponse:^(NSString *status, id data, NSMutableArray *array) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        _memberList = array;
    } exceptionResponse:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
    }];
}

- (double) calculateActualPay:(double) orderCount ticket:(double) ticket balance:(double) balance
{
    if(orderCount < ticket)
        ticket = orderCount;
    self.lbTicketPay.text = [NSString stringWithFormat:Pay_Format, ticket];
    double d = orderCount - ticket;
    if(d < 0)
        d = 0;
    else if (d > balance)
        d = balance;
    self.lbBalancePay.text = [NSString stringWithFormat:Pay_Format, d];
    double actual = orderCount - ticket - balance;
    if(actual < 0)
        actual = 0;
//    self.lbActualPay.text = [NSString stringWithFormat:@"%.2f元", actual];
    
    NSString *str = [NSString stringWithFormat:@"¥%.2f", actual];
     NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:12.0]
     
                          range:NSMakeRange(0, 1)];
    
    self.lbActualPay.attributedText = att;
    
    return actual;
}

- (double) getMaxCarPriceForBanPen:(NSString *) ticketName
{
    double price = 200;
    
    for (int i = 0; i < [_memberList count]; i++) {
        TicketMaxPriceModel *model = [_memberList objectAtIndex:i];
        
//        if([ticketName rangeOfString:model.service_name].length > 0){
        price = model.member_price;
        break;
//        }
    }
    
    return price;
}

- (double) getMaxCarPriceForBaoYang:(NSString *) ticketName
{
    double price = 120;
    
    for (int i = 0; i < [_memberList count]; i++) {
        TicketMaxPriceModel *model = [_memberList objectAtIndex:i];
        
        if([ticketName rangeOfString:model.service_name].length > 0){
            price = model.member_price;
        }
    }
    
    return price;
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

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.tfBuYouHuiAmount){
        if([_tfAmount.text doubleValue] < [_tfBuYouHuiAmount.text doubleValue]){
            _tfBuYouHuiAmount.text = _tfAmount.text;
        }
    }else{
        if([_tfAmount.text doubleValue] < [_tfBuYouHuiAmount.text doubleValue]){
            _tfBuYouHuiAmount.text = @"";
        }
    }
    
    [self resetData];
}

#pragma UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
//        [cell setDisplayInfoWithName:@"银联支付" withThirdType:4];
//        if (_currentPayType == 4)
//        {
//            cell.selectIcon.highlighted = YES;
//            [cell.payNameLabel setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
//        }
//        else
//        {
//            cell.selectIcon.highlighted = NO;
//            [cell.payNameLabel setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
//        }
        
    }
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0)
    {
        if (_currentPayType == 3)
        {
//            _currentPayType = -1;
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
//            _currentPayType = -1;
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
//            _currentPayType = -1;
        }
        else
        {
            _currentPayType = 4;
        }
    }

    [self.tableview reloadData];
}

#pragma UIGestureRecognizerDelegate
//然后根据具体的业务场景去写逻辑就可以了,比如
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        NSString *account = _tfAmount.text;
        double amount = [account doubleValue];
        double a = [_tfBuYouHuiAmount.text doubleValue];
        if(a > amount)
            a = amount;
        double ticket = 0;
        if(_ticketPayStatus && _carWashModel.code_count > 0){
            ticket = _carWashModel.price;
            if(ticket == 100000){
                ticket = [self getTicketValue:ticket name:_carWashModel.code_name serviceType:[_appointModel.service_type integerValue]];
            }
            else if (ticket > 10000 && ticket < 100000){
                ticket = amount - a - (int)((amount - a) * ticket / 100000.0);
            }
            
        }
    
        if(amount - a < ticket)
            ticket = amount - a;
        
        double balance = 0;
        if([_userInfo.account_remainder doubleValue] > 0.0 && _balancePayStatus)
            balance = [_userInfo.account_remainder doubleValue];
        
        double other = [self calculateActualPay:[account doubleValue] ticket:ticket balance:balance];
        
        if(other > 0){
            if(_currentPayType == 3){
                [self requestTenPay:ticket balance:balance other:other amount:[account doubleValue]];
            }else if (_currentPayType == 2){
                [self requestAliPay:ticket balance:balance other:other amount:[account doubleValue]];
            }
        }
        else{
            [self payTicketsAndBalance:ticket balance:balance other:other amount:[account doubleValue]];
        }
        
    }

}

//券和余额支付
- (void) payTicketsAndBalance:(double) ticket balance:(double) balance other:(double) other amount:(double) amount
{
    NSString *account = _tfAmount.text;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"new" forKey:@"op_type"];
    
    [dic setObject:_appointModel.member_id forKey:@"member_id"];
    
    if(_ticketPayStatus && _carWashModel.code_count > 0){
        [dic setObject:@"5" forKey:@"pay_type"];
    }else{
        [dic setObject:@"1" forKey:@"pay_type"];
    }
    

    [dic setObject:_appointModel.service_type forKey:@"service_type"];
    [dic setObject:_appointModel.out_trade_no forKey:@"out_trade_no"];
    [dic setObject:_appointModel.car_id forKey:@"car_id"];
    [dic setObject:_appointModel.car_wash_id forKey:@"car_wash_id"];
    [dic setObject:_appointModel.service_id forKey:@"service_id"];
    [dic setObject:[NSNumber numberWithInteger:_appointModel.reserve_type] forKey:@"service_mode"];
    [dic setObject:[NSString stringWithFormat:@"%@ %@:00", _appointModel.reserve_day, _appointModel.b_time] forKey:@"service_time"];
    if(_appointModel.addr)
        [dic setObject:_appointModel.addr forKey:@"service_addr"];
    if(_ticketPayStatus)
        [dic setObject:_carWashModel.code_id forKey:@"code_id"];
    [dic setObject:_appointModel.longitude forKey:@"longitude"];
    [dic setObject:_appointModel.latitude forKey:@"latitude"];
    
    double remainder = [account doubleValue] -  ticket;
    if(remainder > balance)
        remainder = balance;
    [dic setObject:[NSString stringWithFormat:@"%.2f", remainder] forKey:@"pay_money"];
    [dic setObject:@"0" forKey:@"is_super"];
    [dic setObject:account forKey:@"total_money"];
    if(_buyouhuiStatus){
        [dic setObject:_tfBuYouHuiAmount.text forKey:@"bcyyh_money"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebService requestJsonWXOperationWithParam:dic
                                         action:@"order/service/manage"
                                 normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             [MBProgressHUD showMessag:@"正在查询订单信息"
                                toView:self.view];
             self.view.userInteractionEnabled = NO;
             [self performSelector:@selector(deleteReservesWithOutTradeNo:) withObject:[data objectForKey:@"out_trade_no"] afterDelay:3.0];
             
         }
         else
         {
             [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                               toView:self.view];
         }
     }
      exceptionResponse:^(NSError *error) {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          self.view.userInteractionEnabled = YES;
          [MBProgressHUD showError:[error domain]
                            toView:self.view];
      }];

}

//wechat pay
- (void) requestTenPay:(double) ticket balance:(double) balance other:(double) other amount:(double) amount
{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端，请安装微信客户端后进行支付"];
        
        return ;
    }
    
    NSString *account = _tfAmount.text;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"order" forKey:@"type"];
    [dic setObject:_appointModel.member_id forKey:@"member_id"];
    
    [dic setObject:[NSString stringWithFormat:@"%.2f", other] forKey:@"money"];
    [dic setObject:_appointModel.service_type forKey:@"service_type"];
    [dic setObject:_appointModel.out_trade_no forKey:@"out_trade_no"];
    [dic setObject:_appointModel.car_id forKey:@"car_id"];
    [dic setObject:_appointModel.car_wash_id forKey:@"car_wash_id"];
    [dic setObject:_appointModel.service_id forKey:@"service_id"];
    [dic setObject:[NSNumber numberWithInteger:_appointModel.reserve_type] forKey:@"service_mode"];
    [dic setObject:[NSString stringWithFormat:@"%@ %@:00", _appointModel.reserve_day, _appointModel.b_time] forKey:@"service_time"];
    if(_appointModel.addr)
        [dic setObject:_appointModel.addr forKey:@"service_addr"];
    if(_ticketPayStatus)
        [dic setObject:_carWashModel.code_id forKey:@"code_id"];
    [dic setObject:_appointModel.longitude forKey:@"longitude"];
    [dic setObject:_appointModel.latitude forKey:@"latitude"];
    
    double remainder = [account doubleValue] -  ticket;
    if(remainder > balance)
        remainder = balance;
    [dic setObject:[NSString stringWithFormat:@"%.2f", remainder] forKey:@"remainder"];
    [dic setObject:@"0" forKey:@"is_super"];
    [dic setObject:account forKey:@"total_money"];
    
    if(_buyouhuiStatus){
        [dic setObject:_tfBuYouHuiAmount.text forKey:@"bcyyh_money"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebService requestJsonWXOperationWithParam:dic
                                         action:@"third/pay/tenPay/request"
                                 normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             [PayHelper submitPayRequestToWeChat:data];
         }
         else
         {
             [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                               toView:self.view];
         }
     }
      exceptionResponse:^(NSError *error) {
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          self.view.userInteractionEnabled = YES;
          [MBProgressHUD showError:[error domain]
                            toView:self.view];
      }];
}

//AliPay pay
- (void) requestAliPay:(double) ticket balance:(double) balance other:(double) other amount:(double) amount
{
    NSString *account = _tfAmount.text;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"order" forKey:@"op_type"];
    [dic setObject:_appointModel.member_id forKey:@"member_id"];
    
//    [dic setObject:[NSString stringWithFormat:@"%.2f", other] forKey:@"money"];
    [dic setObject:_appointModel.service_type forKey:@"service_type"];
    [dic setObject:_appointModel.out_trade_no forKey:@"out_trade_no"];
    [dic setObject:_appointModel.car_id forKey:@"car_id"];
    [dic setObject:_appointModel.car_wash_id forKey:@"car_wash_id"];
    [dic setObject:_appointModel.service_id forKey:@"service_id"];
    [dic setObject:[NSNumber numberWithInteger:_appointModel.reserve_type] forKey:@"service_mode"];
    [dic setObject:[NSString stringWithFormat:@"%@ %@:00", _appointModel.reserve_day, _appointModel.b_time] forKey:@"service_time"];
    if(_appointModel.addr)
        [dic setObject:_appointModel.addr forKey:@"service_addr"];
    if(_ticketPayStatus)
        [dic setObject:_carWashModel.code_id forKey:@"code_id"];
    [dic setObject:_appointModel.longitude forKey:@"longitude"];
    [dic setObject:_appointModel.latitude forKey:@"latitude"];
    
    if(_buyouhuiStatus){
        [dic setObject:_tfBuYouHuiAmount.text forKey:@"bcyyh_money"];
    }
    
    double remainder = [account doubleValue] -  ticket;
    if(remainder > balance)
        remainder = balance;
    [dic setObject:[NSString stringWithFormat:@"%.2f", remainder] forKey:@"remainder"];
    [dic setObject:@"0" forKey:@"is_super"];
    [dic setObject:account forKey:@"total_money"];
    [dic setObject:[NSString stringWithFormat:@"%.2f", other] forKey:@"money"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebService requestJsonWXOperationWithParam:dic
                                         action:@"third/pay/alipay/prepay"
                                 normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             [PayHelper submitPayRequestToAliPay:data];
         }
         else
         {
             [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                               toView:self.view];
         }
     }
                              exceptionResponse:^(NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  self.view.userInteractionEnabled = YES;
                                  [MBProgressHUD showError:[error domain]
                                                    toView:self.view];
                              }];
}

- (void) submitPayRequestAlipay:(NSDictionary *)submitDic
{
    _aliPayOutTradeNo = [submitDic objectForKey:@"out_trade_no"];
    
    NSString *body = [submitDic objectForKey:@"body"];
    Order *order = [[Order alloc] init];
    
    
    order.partner = [submitDic objectForKey:@"partner"];
    order.seller = [submitDic objectForKey:@"seller"];
    
    order.tradeNO = _aliPayOutTradeNo; //订单ID（由商家自行制定）
    order.productName =  [submitDic objectForKey:@"subject"];
    order.productDescription = body; //商品描述
    order.amount = [submitDic objectForKey:@"money"]; //商品价格
    order.notifyURL = [submitDic objectForKey:@"alipay_url"]; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    NSString *appScheme = @"fengkuangxiche";
    NSString *orderInfo = [order description];
    id<DataSigner> signer;
    signer = CreateRSADataSigner([submitDic objectForKey:@"rsa_private"]);
    NSString *signedStr = [signer signString:orderInfo];
    
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
    
    [[AlipaySDK  defaultService] payOrder:orderString
                               fromScheme:appScheme
                                 callback:^(NSDictionary *resultDic)
     {
         NSLog(@"reslut = %@",resultDic);
         NSLog(@"reslut memo = %@", [resultDic valueForKey:@"memo"]);
         [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:resultDic];
     }];
}

- (void)paySuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.object;
    
    if (![[userInfo valueForKey:@"resultStatus"] isEqualToString:@"9000"])
    {
        if ([[userInfo valueForKey:@"resultStatus"] isEqualToString:@"6001"])
        {
            [Constants showMessage:@"操作已经取消"];
            [_appDelegate submitUserCancelPayOpreationWithOutTradeNo:_aliPayOutTradeNo];
        }else
        {
            [Constants showMessage:[userInfo valueForKey:@"memo"]];
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
                [Constants showMessage:@"\n订单支付成功！\n"];
            }
        }
        else if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] )
        {
            [Constants showMessage:@"\n订单支付成功！\n"];
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
                NSString *_out_trade_no = [tmpStr substringWithRange:NSMakeRange(14, [tmpStr length] - 15)];
                _errorTime = 0;
//                [self removePayNotifaction];
                [MBProgressHUD showMessag:@"正在查询订单信息"
                                   toView:self.view];
                self.view.userInteractionEnabled = NO;
                [self performSelector:@selector(deleteReservesWithOutTradeNo:) withObject:_out_trade_no afterDelay:3.0];
                
                break;
                
            }
        }
    }
}

- (void) removePayNotifaction
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) deleteReservesWithOutTradeNo:(NSString*)string
{
    NSDictionary *submitDic = @{@"out_trade_no": _appointModel.out_trade_no,
                                @"member_id": _userInfo.member_id,
                                @"reserve_status": @"3",
                                @"pay_trade_no": string};
    
    [WebService requestJsonWXOperationWithParam:submitDic
                                       action:@"reserve/service/deleteReserves"
                               normalResponse:^(NSString *status, id data)
     {
         NSLog(@"reserve/service/deleteReserves %@",data);
         self.view.userInteractionEnabled = YES;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
         [tmpArray removeLastObject];
         
         PaySuccessedVC *vc = [[PaySuccessedVC alloc] initWithNibName:@"PaySuccessedVC" bundle:nil];
         [tmpArray addObject:vc];
         vc.outTradeNo = string;
         vc.giftType = @"yuyue";
         
         [self.navigationController setViewControllers:tmpArray animated:YES];
         
     }
                            exceptionResponse:^(NSError *error)
     {
         if (_errorTime < 3)
         {
             _errorTime++;
             [self performSelector:@selector(deleteReservesWithOutTradeNo:) withObject:string afterDelay:3.0];
         }
         else
         {
             self.view.userInteractionEnabled = YES;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
         }
     }];

}

@end
