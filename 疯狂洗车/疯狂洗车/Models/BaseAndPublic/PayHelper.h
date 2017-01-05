//
//  PayHelper.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayConfig.h"
#import "PayModel.h"
#import "InsurancePayModel.h"
#import "PayInfo.h"
#import "UnionPayResopne.h"


@interface PayHelper : NSObject
{
    NSString  *_rechargeTradeID;
//    PayConfig *_payConfig;
//    PayConfig *_insurancePayConfig;
    NSString  *_wxPayOutTradeNo;
    NSString  *_unionPayTradeNo;

}

+ (id)defaultHelper;

+ (void)startAlipayWithPrice:(NSString*)payPrice
                andUserCarID:(NSString*)carID
                andCarWashID:(NSString*)carWashId
                   orderName:(NSString *)orderName
               andOutTradeNo:(NSString*)outTradeNo
               andTicketCode:(NSString*)ticketCode
                andRemainder:(NSString*)remainderValue
                  andIsSuper:(BOOL)isSuper;


+ (void)startRechargeToAliPayWithPayInfo:(PayInfo*)payInfo;

+ (void)startRechargeToWXPayWithPayInfo:(PayInfo*)payInfo;


+ (void)startWXpayWithPrice:(NSString*)payPrice
               andUserCarID:(NSString*)carID
               andCarWashID:(NSString*)carWashId
              andTicketCode:(NSString *)ticketCode
               andRemainder:(NSString*)remainderValue
                 andIsSuper:(BOOL)isSuper;


+ (void)startCarNurseAlipayWithModel:(PayModel *)model;

+ (void)submitPayRequestToAliPay:(NSDictionary*)submitDic;

+ (void)startCarNurseWXpayWithModel:(PayModel *)model;

+ (void)submitPayRequestToWeChat:(NSDictionary*)submitDic;

+ (void)startInsuranceAlipayWithModel:(InsurancePayModel*)model;


+ (void)startInsuranceWXPayWithModel:(InsurancePayModel*)model;

+ (void)startUnionPayWithModel:(PayModel*)model
                normalResponse:(void(^)(UnionPayResopne *payRespone))normalResponse
             exceptionResponse:(void(^)(NSError *error))exceptionResponse;


+ (NSString*)getUnionPayOutTradeNo;

+ (void)setUnionPayOutTradeNo:(NSString*)outTradeNo;



+ (NSString*)getWXPayOutTradeNo;


@end
