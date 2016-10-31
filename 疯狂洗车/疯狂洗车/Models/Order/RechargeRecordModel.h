//
//  RechargeRecordModel.h
//  优快保
//
//  Created by cts on 15/6/2.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface RechargeRecordModel : JsonBaseModel

@property (strong, nonatomic) NSString *recharge_id;

@property (strong, nonatomic) NSString *member_id;

@property (strong, nonatomic) NSString *recharge_time;

@property (strong, nonatomic) NSString *recharge_type;

@property (strong, nonatomic) NSString *out_trade_no;

@property (strong, nonatomic) NSString *recharge_money;

@property (strong, nonatomic) NSString *present;

@property (strong, nonatomic) NSString *config_type;



@end
