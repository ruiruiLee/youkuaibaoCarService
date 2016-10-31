//
//  CarNurseOrderViewController.m
//  优快保
//
//  Created by cts on 15/4/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNurseOrderViewController.h"
#import "UIView+Toast.h"
#import "OrderTimerPickerView.h"
#import "MoreRequestViewController.h"
#import "AddressSelectViewController.h"
#import "LocationModel.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "MyOrdersController.h"
#import "PayHelper.h"
#import "AddNewCarController.h"
#import "MyTicketViewController.h"
#import "OrderSuccessViewController.h"
#import "UnionPayResopne.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"

@interface CarNurseOrderViewController ()<OrderTimerPickerViewDelegate,MoreRequestDelegate,AddressSelectDelegate,AddNewCarDelegate,MyTicketDelegate,UPPayPluginDelegate>
{
    OrderTimerPickerView *_orderTimerPickerView;
    
    NSInteger       _currentPayType;
    
    LocationModel       *_serviceLocation;
    
    NSString        *_out_trade_no;

    int             _errorTime;

}

@end

@implementation CarNurseOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _carNurseNameLabel.text = [NSString stringWithFormat:@"%@",self.carNurse.name];
    _currentPayType = 3;

    _remainderSelected = YES;
    _yuePaySelectIcon.highlighted = YES;
    
    if ([_serviceModel.service_content isEqualToString:@""] || _serviceModel.service_content == nil)
    {
        _serviceContextLabel.text = @"暂无内容";
    }
    else
    {
        _serviceContextLabel.text = _serviceModel.service_content;
    }
    if ([_serviceModel.accessories isEqualToString:@""] || _serviceModel.accessories == nil)
    {
        _servicePartsLabel.text   = @"暂无材料";
    }
    else
    {
        _servicePartsLabel.text   = _serviceModel.accessories;
    }
    
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_serviceModel.member_price];
    
    if (self.defaultTicketModel)
    {
        self.selectTicketModel = self.defaultTicketModel;
        _ticketEnable = YES;
        _ticketSelected = YES;
        [_ticketPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
        _ticketPaySelectIcon.highlighted = YES;
        
        _ticketNameLabel.text =[self.selectTicketModel.comp_name isEqualToString:@""]?@"":self.selectTicketModel.comp_name;
        _ticketNumberLabel.text = @"";
        _ticketNumberTitle.hidden = YES;

        _ticketPriceLabel.text = [NSString stringWithFormat:@"%d元",self.selectTicketModel.price.intValue];
        _ticketTypeLabel.text = [self.selectTicketModel.code_name isEqualToString:@""]?@"":self.selectTicketModel.code_name;

    }
    

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
        if (self.serviceWay == SerivceWayDaodian)
        {
            [self setTitle:@"到店服务"];
        }
        else
        {
            [self setTitle:@"上门取送"];
        }
    }
    
    int minHour = 0 ;
    int maxHour = 0;
    
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


- (void)getUserAllTicketsFromService
{
    self.view.userInteractionEnabled = NO;
    if (!_userInfo.member_id)
    {
        
        [self setUpOrderView];
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
            _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张可用",self.serviceModel.code_count.intValue];
        }
        [self setUpOrderView];
    }
    
}

- (void)setUpOrderView
{
    self.view.userInteractionEnabled = YES;
    NSString *carTitle = [NSString stringWithFormat:@"[%@] %@·%@ %@ %@",[_serviceCar.car_type isEqualToString:@"1"]?@"轿车" : @"SUV",
                          [_serviceCar.car_no substringWithRange:NSMakeRange(0, 2)],
                          [_serviceCar.car_no substringWithRange:NSMakeRange(2, _serviceCar.car_no.length-2)],
                          _serviceCar.car_brand == nil ?@"无品牌信息":_serviceCar.car_brand,
                          _serviceCar.car_xilie == nil?@"":_serviceCar.car_xilie ];
    
    _serviceCarLabel.text = [NSString stringWithFormat:@"%@",carTitle];
    
    NSString *serviceTypeString = nil;
    if ([_serviceModel.service_type isEqualToString:@"1"])
    {
        serviceTypeString = @"保养服务";
    }
    else if ([_serviceModel.service_type isEqualToString:@"2"])
    {
        serviceTypeString = @"划痕服务";
    }
    else if ([_serviceModel.service_type isEqualToString:@"3"])
    {
        serviceTypeString = @"美容服务";
    }
    else if ([_serviceModel.service_type isEqualToString:@"5"])
    {
        serviceTypeString = @"车保姆服务";
        [self setTitle:@"车保姆"];
    }
    else
    {
        serviceTypeString = @"其他服务";
    }
    
    if (self.isForRecuse)
    {
        [self setTitle:@"救援"];
        _serviceTypeAndWayLabel.text = [NSString stringWithFormat:@"道路救援"];
    }
    else if ([_serviceModel.service_type isEqualToString:@"5"])
    {
        _serviceTypeAndWayLabel.text = [NSString stringWithFormat:@"%@",serviceTypeString];
    }
    else
    {
        _serviceTypeAndWayLabel.text = [NSString stringWithFormat:@"%@ - %@",serviceTypeString,self.serviceWay == SerivceWayDaodian?@"到店服务":@"上门取送"];
    }
    
    _backGroundView = [[UIScrollView alloc] init];
    [self.view addSubview:_backGroundView];
    _backGroundView.showsVerticalScrollIndicator = NO;
    
    [_backGroundView addSubview:_contentView];
    [_backGroundView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [_backGroundView makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(_serviceOrderView);
         make.bottom.equalTo(_contentView);
     }];
    [_contentView makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(_backGroundView);
         make.width.equalTo(SCREEN_WIDTH);
         make.bottom.equalTo(_payWayView.bottom);
         if (self.serviceWay == SerivceWayDaodian)
         {
             if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
             {
                 _serviceAddressView.hidden = YES;
                 _serviceTimeView.hidden    = YES;
                 _moreRequestView.transform = CGAffineTransformMakeTranslation(0, (-_moreRequestView.frame.size.height*2)*2);
                 _payWayView.transform      = CGAffineTransformMakeTranslation(0, (-_moreRequestView.frame.size.height*2)*2);
             }
             else
             {
                 _serviceAddressView.hidden = YES;
                 _serviceTimeView.hidden    = YES;
                 _moreRequestView.transform = CGAffineTransformMakeTranslation(0, -_moreRequestView.frame.size.height*2);
                 _payWayView.transform      = CGAffineTransformMakeTranslation(0, -_moreRequestView.frame.size.height*2);
             }
         }
     }];
    
    [self.view bringSubviewToFront:_bottomSubmitView];

    [self updateThirdPaySelectDisplay];
    
    [_ticketPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
    [_yuePayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
    
    _yuePaySelectIcon.highlighted = YES;
    if (_ticketSelected)
    {
        [_ticketPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
        _ticketPaySelectIcon.highlighted = YES;
    }
    else
    {
        _ticketPaySelectIcon.highlighted = NO;
    }
    
    
    [_yueLabel setText:[NSString stringWithFormat:@"%.2f", _userInfo.account_remainder.floatValue]];
    
    [self updateDisplayPayPrice];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addPayNotifaction];
    [_yueLabel setText:[NSString stringWithFormat:@"%.2f", _userInfo.account_remainder.floatValue]];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removePayNotifaction];
    NSLog(@"我不在了");
}


#pragma mark - 余额和券

- (IBAction)checkPayType:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        if (!_ticketEnable)
        {
            [Constants showMessage:@"您没有该服务的优惠券"];
            return;
        }
        else if (_ticketSelected || self.defaultTicketModel == nil)
        {
            [self selectTicketToPay];
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
            [_yuePayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
            _yuePaySelectIcon.highlighted = NO;
        }
        else
        {
            _remainderSelected = YES;

            [_yuePayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
            
            _yuePaySelectIcon.highlighted = YES;
        }
    }
    [self updateDisplayPayPrice];
}

#pragma mark - 选择第三方支付

- (IBAction)didThirdButtonTouch:(UIButton*)sender
{
    if (sender.tag == 2)
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
    else if (sender.tag == 3)
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
    else if (sender.tag == 4)
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
    
    [self updateThirdPaySelectDisplay];
}

- (void)updateThirdPaySelectDisplay
{
    if (_currentPayType == -1)
    {
        _aliPaySelectIcon.highlighted = NO;
        [_aliPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _weixinPaySelectIcon.highlighted = NO;
        [_weixinPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _unionPaySelectIcon.highlighted = NO;
        [_unionPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
    }
    else if (_currentPayType == 2)
    {
        _aliPaySelectIcon.highlighted = YES;
        [_aliPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
        _weixinPaySelectIcon.highlighted = NO;
        [_weixinPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _unionPaySelectIcon.highlighted = NO;
        [_unionPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
    }
    else if (_currentPayType == 3)
    {
        _aliPaySelectIcon.highlighted = NO;
        [_aliPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _weixinPaySelectIcon.highlighted = YES;
        [_weixinPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
        _unionPaySelectIcon.highlighted = NO;
        [_unionPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
    }
    else if (_currentPayType == 4)
    {
        _aliPaySelectIcon.highlighted = NO;
        [_aliPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _weixinPaySelectIcon.highlighted = NO;
        [_weixinPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _unionPaySelectIcon.highlighted = YES;
        [_unionPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
    }
}

#pragma mark - 支付金额更新

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

#pragma mark - 选择券

- (IBAction)didTicketSelectButtonTouched:(id)sender
{
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
            [self selectTicketToPay];
        }
    }
}


- (void)selectTicketToPay
{
    MyTicketViewController *viewController = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController" bundle:nil];
    
    viewController.serviceType = _serviceModel.service_type;
    viewController.delegate = self;
    viewController.targetCarWashID = self.carNurse.car_wash_id;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFinishTicketSelect:(TicketModel *)model
{
    if (model == nil)
    {
        _ticketSelected = NO;
        self.selectTicketModel = nil;
        [_ticketPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _ticketPaySelectIcon.highlighted = NO;
        _ticketNameLabel.text = @"";
        _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张可用",self.serviceModel.code_count.intValue];
        _ticketNumberTitle.hidden = NO;
        
        _ticketPriceLabel.text = @"";
        _ticketTypeLabel.text = @"";

    }
    else
    {
        _ticketSelected = YES;
        self.selectTicketModel = model;
        [_ticketPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
        _ticketPaySelectIcon.highlighted = YES;
        
        _ticketNameLabel.text =[self.selectTicketModel.comp_name isEqualToString:@""]?@"":self.selectTicketModel.comp_name;
        _ticketNumberLabel.text = @"";
        _ticketNumberTitle.hidden = YES;
        _ticketPriceLabel.text = [NSString stringWithFormat:@"%d元",self.selectTicketModel.price.intValue];
        _ticketTypeLabel.text = [self.selectTicketModel.code_name isEqualToString:@""]?@"":self.selectTicketModel.code_name;

    }
    [self updateDisplayPayPrice];
}


#pragma mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _serviceTimeField)
    {
        [_orderTimerPickerView showOrderTimerPickerView];
        return NO;
    }
    if (textField == _serviceAddressField)
    {
        AddressSelectViewController *viewController = [[AddressSelectViewController alloc] initWithNibName:@"AddressSelectViewController"
                                                                                                    bundle:nil];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    if (textField == _moreRequestField)
    {
        MoreRequestViewController *viewController = [[MoreRequestViewController alloc] initWithNibName:@"MoreRequestViewController"
                                                                                                bundle:nil];
        viewController.inputTextView.text = _moreRequestField.text;
        viewController.delegate = self;
        if (_moreRequestField.text != nil && ![_moreRequestField.text isEqualToString:@""])
        {
            viewController.requestString = _moreRequestField.text;
        }
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    return YES;
}

- (void)didFinishAddressSelect:(LocationModel *)locationModel
{
    _serviceLocation = locationModel;
    _serviceAddressField.text = _serviceLocation.addressString;
}

#pragma mark - 

- (void)didFinishOrderTimerPicker:(NSString *)resultString
{
    _serviceTimeField.text = resultString;
}

#pragma mark - MoreRequestDelegate Method

- (void)didFinishMoreRequestEditing:(NSString *)contextString
{
    _moreRequestField.text = contextString;
}

- (IBAction)didSubmitButtonTouch:(id)sender
{
    if (self.serviceWay == SerivceWayShangmen)
    {
        if ([_serviceTimeField.text isEqualToString:@""] || _serviceTimeField.text == nil)
        {
            [Constants showMessage:@"您还未选择服务时间"];
            return;
        }
    }
    if (self.serviceWay == SerivceWayDaodian)
    {
        
    }
    else
    {
        if ([_serviceAddressField.text isEqualToString:@""] || _serviceAddressField.text == nil || _serviceLocation == nil)
        {
            [Constants showMessage:@"您还未选择服务地址"];
            return;
        }
    }

    
    
    NSMutableString *alertString = [NSMutableString stringWithFormat:@"\n"];
    
    float ticketMoney = 0;
    float yueMoney = 0;
    float payMoney = self.serviceModel.member_price.floatValue;
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
        NSString *resultStr = [userInfo valueForKey:@"result"];
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSArray *arr = [resultStr componentsSeparatedByString:@"&"];
        for (NSString *tmpStr in arr)
        {
            if ([tmpStr rangeOfString:@"out_trade_no"].location != NSNotFound)
            {
                _out_trade_no = _aliPayOutTradeNo;
                _errorTime = 0;
                [MBProgressHUD showMessag:@"正在查询订单信息"
                                   toView:self.view];
                self.view.userInteractionEnabled = NO;
                [self removePayNotifaction];
                [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:_out_trade_no afterDelay:3.0];
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
    _errorTime = 0;
    [self removePayNotifaction];
    [MBProgressHUD showMessag:@"正在查询订单信息"
                       toView:self.view];
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(checkPayOrderWithOutTradeNo:) withObject:notification.object afterDelay:3.0];
}

- (void)UPPayPluginResult:(NSString *)result
{
    if ([result isEqualToString:@"success"])
    {
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
        _errorTime = 0;
        [MBProgressHUD showMessag:@"正在查询订单信息"
                           toView:self.view];
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

         if ([_appconfig.open_share_order_flag isEqualToString:@"1"])
         {
             NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
             [tmpArray removeLastObject];
             OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                                       bundle:nil];
             
             viewController.share_order_url = [data objectForKey:@"share_order_url"];
             viewController.isClubController = self.isClubController;

             [tmpArray addObject:viewController];
             [self.navigationController setViewControllers:tmpArray animated:YES];
         }
         else
         {
             [self.navigationController popViewControllerAnimated:YES];

         }
         
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

        

        if ([_moreRequestField.text isEqualToString:@""] || _moreRequestField.text == nil)
        {
        }
        else
        {
            [submitDic setObject:_moreRequestField.text forKey:@"requiry"];
        }
        
        if (self.serviceWay == SerivceWayShangmen)
        {
            [submitDic setObject:_serviceTimeField.text
                          forKey:@"service_time"];
            [submitDic setObject:@2
                          forKey:@"service_mode"];
            [submitDic setObject:_serviceAddressField.text
                          forKey:@"service_addr"];
            [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.latitude]
                          forKey:@"latitude"];
            [submitDic setObject:[NSNumber numberWithDouble:_serviceLocation.locationCoordinate.longitude]
                          forKey:@"longitude"];

        }
        else
        {
            
            [submitDic setObject:@1 forKey:@"service_mode"];

        }
        
        
        float ticketMoney = 0;
        float yueMoney = 0;
        float payMoney = self.serviceModel.member_price.floatValue;
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
                     [UPPayPlugin startPay:payRespone.trade_no
                                      mode:payRespone.mode
                            viewController:self
                                  delegate:self];
                     
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

                     if (_ticketPaySelectIcon.highlighted == YES)
                     {
                     }
                     else
                     {
                         _userInfo.account_remainder = [NSString stringWithFormat:@"%.2f", [_userInfo.account_remainder doubleValue] - yueMoney];
                     }
                     [[NSUserDefaults standardUserDefaults] setValue:_userInfo.convertToDictionary forKey:kUserInfoKey];
                     [[NSUserDefaults standardUserDefaults] synchronize];


                     if ([_appconfig.open_share_order_flag isEqualToString:@"1"])
                     {
                         NSMutableArray *tmpArray = [self.navigationController.viewControllers mutableCopy];
                         [tmpArray removeObjectsInRange:NSMakeRange(tmpArray.count-2, 2)];
                         OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                                                   bundle:nil];
                         viewController.share_order_url = [data objectForKey:@"share_order_url"];
                         viewController.isClubController = self.isClubController;
                         [tmpArray addObject:viewController];
                         [self.navigationController setViewControllers:tmpArray animated:YES];
                     }
                     else
                     {
                         [self.navigationController popViewControllerAnimated:YES];

                     }
                     
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

- (void)getShareOrderAffterPaySuccess
{
    OrderSuccessViewController *viewController = [[OrderSuccessViewController alloc] initWithNibName:@"OrderSuccessViewController"
                                                                                              bundle:nil];
    viewController.isClubController = self.isClubController;
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFinishEditCar:(CarInfos*)result
{
    return;
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
