//
//  InsurancePayModel.h
//  优快保
//
//  Created by cts on 15/7/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///保险报价支付信息model类，包含该保险报价支付时所需要的所有信息，类似车服务的支付数据
@interface InsurancePayModel : JsonBaseModel

@property (strong, nonatomic) NSString*member_id;

@property (strong, nonatomic) NSString*code_id;

@property (strong, nonatomic) NSString*suggest_id;

@property (strong, nonatomic) NSString*pay_money;

@property (strong, nonatomic) NSString*remainder;

@property (strong, nonatomic) NSString*address;

@property (strong, nonatomic) NSString*requiry;


@end
