//
//  PayInfo.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface PayInfo : JsonBaseModel

@property (nonatomic, strong) NSString *config_id;
@property (nonatomic, strong) NSString *recharge_money;
@property (nonatomic, strong) NSString *present;
@property (nonatomic, strong) NSString *confg_desc;
@property (nonatomic, strong) NSString *city_id;
@property (strong, nonatomic) NSString *config_type;
@property (strong, nonatomic) NSString *out_trade_no;



@end
