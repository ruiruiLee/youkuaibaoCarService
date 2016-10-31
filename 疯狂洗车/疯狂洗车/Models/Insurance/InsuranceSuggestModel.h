//
//  InsuranceSuggestModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///保险报价详情model类，包含一个报价的基本信息，期中，详细的信息由字段中suggest_url指向的网页展示，本来没有详情的字段
@interface InsuranceSuggestModel : JsonBaseModel

@property (strong, nonatomic) NSString *insur_status;//保险状态（0和已可以支付报价） 0.正常 1.支付中 2.已支付 3.已快递  PS:当处于无法支付的状态时需要隐藏购买按钮。

@property (strong, nonatomic) NSString *pay_price;//需支付的钱

@property (strong, nonatomic) NSString *contact_phone;//联系电话

@property (strong, nonatomic) NSString *contact_name;//联系人

@property (strong, nonatomic) NSString *suggest_url;//保单详情url


@end
