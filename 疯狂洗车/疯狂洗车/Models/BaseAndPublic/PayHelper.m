//
//  PayHelper.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "PayHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WebServiceHelper.h"
#import "Order.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "WXApi.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD+Add.h"

@implementation PayHelper

+ (id)defaultHelper
{
    static PayHelper *defaultHelper = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        defaultHelper = [[PayHelper alloc] init];
    });
    
    return defaultHelper;
}

- (id)init
{
    self = [super init];
    {
    }
    return self;
}

#pragma mark - 支付宝支付

+ (void)startRechargeToAliPayWithPayInfo:(PayInfo*)payInfo
{
    [[PayHelper defaultHelper] startRechargeToAliPayWithPayInfo:payInfo];
}

- (void)startRechargeToAliPayWithPayInfo:(PayInfo*)payInfo
{
    
    NSDictionary *submitDic = @{@"out_trade_no":payInfo.out_trade_no,
                                @"total_fee":payInfo.recharge_money,
                                @"present":payInfo.present,
                                @"subject":[NSString stringWithFormat:@"优快保充值%@元", payInfo.recharge_money],
                                @"member_id":_userInfo.member_id,
                                @"op_type":@"recharge",
                                @"config_type":payInfo.config_type};
    [self submitAliPayParmaToService:submitDic];
}

+ (void)startRechargeToAliPay:(NSString*)rechargeValue andGiftValue:(NSString*)giftValue andOutTradeNo:(NSString*)outTradeNo
{
    [[PayHelper defaultHelper] startRechargeToAliPay:rechargeValue andGiftValue:giftValue andOutTradeNo:outTradeNo];
}

- (void)startRechargeToAliPay:(NSString*)rechargeValue andGiftValue:(NSString*)giftValue andOutTradeNo:(NSString*)outTradeNo
{
    NSDictionary *submitDic = @{@"out_trade_no":outTradeNo,
                                @"total_fee":rechargeValue,
                                @"present":giftValue,
                                @"subject":[NSString stringWithFormat:@"优快保充值%@元", rechargeValue],
                                @"member_id":_userInfo.member_id,
                                @"op_type":@"recharge"};
    [self submitAliPayParmaToService:submitDic];
}

+ (void)startAlipayWithPrice:(NSString*)payPrice
                andUserCarID:(NSString*)carID
                andCarWashID:(NSString*)carWashId
                   orderName:(NSString *)orderName
               andOutTradeNo:(NSString*)outTradeNo
               andTicketCode:(NSString *)ticketCode
                andRemainder:(NSString*)remainderValue
                  andIsSuper:(BOOL)isSuper

{
    [[PayHelper defaultHelper] AlipayWithPrice:payPrice
                                       andUserCarID:carID
                                       andCarWashID:carWashId
                                          orderName:orderName
                                      andOutTradeNo:outTradeNo
                                      andTicketCode:ticketCode
                                       andRemainder:remainderValue
                                         andIsSuper:isSuper];
}

- (void)AlipayWithPrice:(NSString*)payPrice
           andUserCarID:(NSString*)carID
           andCarWashID:(NSString*)carWashId
              orderName:(NSString *)orderName
          andOutTradeNo:(NSString*)outTradeNo
          andTicketCode:(NSString *)ticketCode
           andRemainder:(NSString*)remainderValue
             andIsSuper:(BOOL)isSuper



{
    NSDictionary *submitDic = @{@"out_trade_no":outTradeNo,
                                @"total_fee":payPrice,
                                @"car_id":carID,
                                @"car_wash_id":carWashId,
                                @"subject":orderName,
                                @"member_id":_userInfo.member_id,
                                @"op_type":@"order",
                                @"service_type":@"0",
                                @"code_id":ticketCode == nil?@"":ticketCode,
                                @"remainder":remainderValue == nil?@"":remainderValue,
                                @"is_super":isSuper?@"1":@"0"};
    [self submitAliPayParmaToService:submitDic];
}

+ (void)startCarNurseAlipayWithModel:(PayModel *)model
{
    [[PayHelper defaultHelper] startCarNurseAlipayWithModel:model];
}

- (void)startCarNurseAlipayWithModel:(PayModel *)model
{
    NSDictionary *submitDic = @{@"out_trade_no":model.out_trade_no,
                                @"total_fee":model.pay_money,
                                @"car_id":model.car_id,
                                @"car_wash_id":model.car_wash_id,
                                @"subject":@"优快保养车服务",
                                @"member_id":_userInfo.member_id,
                                @"op_type":@"order",
                                @"service_type":model.service_type,
                                @"service_id":model.service_id,
                                @"service_mode":model.service_mode,
                                @"service_time":model.service_time == nil?@"":model.service_time,
                                @"service_addr":model.service_addr == nil?@"":model.service_addr,
                                @"requiry":model.requiry == nil?@"":model.requiry,
                                @"code_id":model.code_id == nil?@"":model.code_id,
                                @"latitude":model.latitude == nil?@"":model.latitude,
                                @"longitude":model.longitude == nil?@"":model.longitude,
                                @"remainder":model.remainder == nil?@"":model.remainder,
                                @"is_super":model.is_super};
    [self submitAliPayParmaToService:submitDic];
}

- (void)submitAliPayParmaToService:(NSDictionary*)submitDic
{
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = NO;
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"third/pay/alipay/prepay"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
         [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             [self submitPayRequestToAliPay:data];
         }
         else
         {
             [Constants showMessage:@"发送支付请求失败"];
         }
     }
                            exceptionResponse:^(NSError *error)
     {
         
         [Constants showMessage:[error domain]];
         
     }];
    
}


+ (void)submitPayRequestToAliPay:(NSDictionary*)submitDic
{
    [[PayHelper defaultHelper] submitPayRequestToAliPay:submitDic];
}

- (void)submitPayRequestToAliPay:(NSDictionary*)submitDic
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



+ (void)startInsuranceAlipayWithModel:(InsurancePayModel*)model
{
    [[PayHelper defaultHelper] startInsuranceAlipayWithModel:model];
}

- (void)startInsuranceAlipayWithModel:(InsurancePayModel*)model
{
    NSDictionary *submitDic = @{@"suggest_id":model.suggest_id,
                                @"member_id":_userInfo.member_id,
                                @"pay_money":model.pay_money,
                                @"address":model.address == nil?@"":model.address,
                                @"requiry":model.requiry == nil?@"":model.requiry,
                                @"code_id":model.code_id == nil?@"":model.code_id,
                                @"remainder":model.remainder == nil?@"":model.remainder};
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"third/pay/alipay/insurance/prepay"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             [self submitPayRequestToAliPay:data];
         }
         else
         {
             [Constants showMessage:@"发送支付请求失败"];
         }
     }
                            exceptionResponse:^(NSError *error)
     {
         [Constants showMessage:[error domain]];
         
     }];

}


#pragma mark - 财付通

+ (void)startRechargeToWXPayWithPayInfo:(PayInfo*)payInfo
{
    [[PayHelper defaultHelper] startRechargeToWXPayWithPayInfo:payInfo];
}

- (void)startRechargeToWXPayWithPayInfo:(PayInfo*)payInfo
{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端，请安装微信客户端后进行支付"];

        return ;
    }
    
    NSDictionary *submitdDic = @{@"type":@"recharge",
                                 @"member_id":_userInfo.member_id,
                                 @"money":payInfo.recharge_money,
                                 @"present":payInfo.present,
                                 @"config_type":payInfo.config_type};
    [self submitWXpayParmaToService:submitdDic];
}


+ (void)startWXpayWithPrice:(NSString*)payPrice
               andUserCarID:(NSString*)carID
               andCarWashID:(NSString*)carWashId
              andTicketCode:(NSString *)ticketCode
               andRemainder:(NSString*)remainderValue
                 andIsSuper:(BOOL)isSuper
{
    [[PayHelper defaultHelper] startWXpayWithPrice:payPrice andUserCarID:carID andCarWashID:carWashId andTicketCode:ticketCode andRemainder:remainderValue andIsSuper:isSuper];
}

- (void)startWXpayWithPrice:(NSString*)payPrice
               andUserCarID:(NSString*)carID
               andCarWashID:(NSString*)carWashId
              andTicketCode:(NSString *)ticketCode
               andRemainder:(NSString*)remainderValue
                 andIsSuper:(BOOL)isSuper

{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端"];
        
        return ;
    }
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    [self WXpayWithPrice:payPrice andUserCarID:carID andCarWashID:carWashId andTicketCode:ticketCode andRemainder:remainderValue andIsSuper:isSuper];

}

- (void)WXpayWithPrice:(NSString*)payPrice
          andUserCarID:(NSString*)carID
          andCarWashID:(NSString*)carWashId
         andTicketCode:(NSString *)ticketCode
          andRemainder:(NSString*)remainderValue
            andIsSuper:(BOOL)isSuper
{

    NSDictionary *submitdDic = @{@"type":@"order",
                                 @"member_id":_userInfo.member_id,
                                 @"money":payPrice,
                                 @"car_id":carID,
                                 @"car_wash_id":carWashId,
                                 @"service_type":@"0",
                                 @"code_id":ticketCode == nil?@"":ticketCode,
                                 @"remainder":remainderValue == nil?@"":remainderValue,
                                 @"is_super":isSuper?@"1":@"0"};
    [self submitWXpayParmaToService:submitdDic];
}

+ (void)startCarNurseWXpayWithModel:(PayModel *)model
{
    [[PayHelper defaultHelper] startCarNurseWXpayWithModel:model];
}

- (void)startCarNurseWXpayWithModel:(PayModel *)model
{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端，请安装微信客户端后进行支付"];
        
        return ;
    }
    NSDictionary *submitdDic = @{@"type":@"order",
                                 @"member_id":_userInfo.member_id,
                                 @"money":model.pay_money,
                                 @"car_id":model.car_id,
                                 @"car_wash_id":model.car_wash_id,
                                 @"service_id":model.service_id,
                                 @"service_mode":model.service_mode,
                                 @"service_type":model.service_type,
                                 @"service_time":model.service_time == nil?@"":model.service_time,
                                 @"service_addr":model.service_addr == nil?@"":model.service_addr,
                                 @"requiry":model.requiry == nil?@"":model.requiry,
                                 @"code_id":model.code_id == nil?@"":model.code_id,
                                 @"latitude":model.latitude == nil?@"":model.latitude,
                                 @"longitude":model.longitude == nil?@"":model.longitude,
                                 @"remainder":model.remainder == nil?@"":model.remainder,
                                 @"is_super":model.is_super};
    
    
    [self submitWXpayParmaToService:submitdDic];
}

- (void)submitWXpayParmaToService:(NSDictionary*)submitDic
{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端，请安装微信客户端后进行支付"];
        
        return ;
    }
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = NO;
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"third/pay/tenPay/request"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
         [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             [self submitPayRequestToWeChat:data];
         }
         else
         {
             [MBProgressHUD showError:@"无法发送订单请求" toView:[[[UIApplication sharedApplication] delegate] window]];
         }
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
                                [MBProgressHUD showError:[error domain] toView:[[[UIApplication sharedApplication] delegate] window]];
                                [[[UIApplication sharedApplication] delegate] window].userInteractionEnabled = YES;
                                
                            }];

}

+ (void)submitPayRequestToWeChat:(NSDictionary*)submitDic
{
    [[PayHelper defaultHelper] submitPayRequestToWeChat:submitDic];
}

- (void)submitPayRequestToWeChat:(NSDictionary*)data
{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端，请安装微信客户端后进行支付"];
        
        return ;
    }
    NSString *timeStamp  = [data objectForKey:@"timestamp"];
    
    _wxPayOutTradeNo = [data objectForKey:@"out_trade_no"];
    
    PayReq *payRequest   = [[PayReq alloc] init];
    
    payRequest.openID    = [data objectForKey:@"appid"];
    
    payRequest.partnerId = [data objectForKey:@"partnerid"];
    
    payRequest.prepayId  = [data objectForKey:@"prepayid"];
    
    payRequest.package   = [data objectForKey:@"package"];
    
    payRequest.nonceStr  = [data objectForKey:@"noncestr"];
    
    payRequest.timeStamp = timeStamp.intValue;
    
    payRequest.sign      = [data objectForKey:@"sign"];
    
    [WXApi sendReq:payRequest];
}



+ (void)startInsuranceWXPayWithModel:(InsurancePayModel*)model
{
    [[PayHelper defaultHelper] startInsuranceWXPayWithModel:model];
}

- (void)startInsuranceWXPayWithModel:(InsurancePayModel*)model
{
    if (![WXApi isWXAppInstalled])
    {
        [Constants showMessage:@"您还未安装微信客户端，请安装微信客户端后进行支付"];
        
        return ;
    }
    NSDictionary *submitdDic = @{@"member_id":_userInfo.member_id,
                                 @"pay_money":model.pay_money,
                                 @"suggest_id":model.suggest_id,
                                 @"address":model.address == nil?@"":model.address,
                                 @"requiry":model.requiry == nil?@"":model.requiry,
                                 @"code_id":model.code_id == nil?@"":model.code_id,
                                 @"remainder":model.remainder == nil?@"":model.remainder};
    
    
    
    [WebService requestJsonOperationWithParam:submitdDic
                                       action:@"third/pay/tenPay/insurance/request"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             [self submitPayRequestToWeChat:data];
         }
         [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
                                [Constants showMessage:[error domain]];
                            }];
    


}

+ (NSString*)getWXPayOutTradeNo
{
  return [[PayHelper defaultHelper] getWXPayOutTradeNo];
}

- (NSString*)getWXPayOutTradeNo
{
    return _wxPayOutTradeNo;
}



#pragma mark - 银联支付

+ (void)startUnionPayWithModel:(PayModel*)model
                normalResponse:(void(^)(UnionPayResopne *payRespone))normalResponse
             exceptionResponse:(void(^)(NSError *error))exceptionResponse;

{
    [[PayHelper defaultHelper] startUnionPayWithModel:model
     normalResponse:^(UnionPayResopne *payRespone) {
         normalResponse(payRespone);
         return ;
     } exceptionResponse:^(NSError *error) {
         exceptionResponse(error);
         return ;
     }];
}

- (void)startUnionPayWithModel:(PayModel*)model
                normalResponse:(void(^)(UnionPayResopne *payRespone))normalResponse
             exceptionResponse:(void(^)(NSError *error))exceptionResponse;


{
    if (model == nil)
    {
        NSError *error = [[NSError alloc] initWithDomain:@"支付信息错误" code:0 userInfo:nil];
        exceptionResponse(error);
        return;
    }
    NSDictionary *submitdDic = @{@"member_id":_userInfo.member_id,
                                 @"money":model.pay_money,
                                 @"service_type":model.service_type,
                                 @"car_id":model.car_id,
                                 @"car_wash_id":model.car_wash_id,
                                 @"service_id":model.service_id == nil?@"":model.service_id,
                                 @"service_mode":model.service_mode == nil?@"":model.service_mode,
                                 @"service_time":model.service_time == nil?@"":model.service_time,
                                 @"service_addr":model.service_addr == nil?@"":model.service_addr,
                                 @"requiry":model.requiry == nil?@"":model.requiry,
                                 @"code_id":model.code_id == nil?@"":model.code_id,
                                 @"latitude":model.latitude == nil?@"":model.latitude,
                                 @"longitude":model.longitude == nil?@"":model.longitude,
                                 @"remainder":model.remainder == nil?@"":model.remainder};
    [WebService requestJsonModelWithParam:submitdDic
                                   action:@"third/pay/union/prepay"
                               modelClass:[UnionPayResopne class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
    {
        if (status.intValue > 0)
        {
            UnionPayResopne *payRespone = (UnionPayResopne*)model;
            
            _unionPayTradeNo = payRespone.out_trade_no;
            normalResponse (payRespone);
            return ;

        }
        else
        {
            NSError *error = [[NSError alloc] initWithDomain:@"数据错误" code:0 userInfo:nil];
            exceptionResponse(error);
            return;
        }
    }
                        exceptionResponse:^(NSError *error)
    {
        exceptionResponse(error);
        return;
    }];
}

+ (NSString*)getUnionPayOutTradeNo
{
    return [[PayHelper defaultHelper] getUnionPayOutTradeNo];
}

- (NSString*)getUnionPayOutTradeNo
{
    return _unionPayTradeNo;
}

+ (void)setUnionPayOutTradeNo:(NSString*)outTradeNo
{
    [[PayHelper defaultHelper] setUnionPayOutTradeNo:outTradeNo];
}

- (void)setUnionPayOutTradeNo:(NSString*)outTradeNo
{
    _unionPayTradeNo = outTradeNo;
}

@end
