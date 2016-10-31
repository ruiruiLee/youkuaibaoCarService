//
//  PayModel.h
//  优快保
//
//  Created by cts on 15/4/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface PayModel : JsonBaseModel

@property (strong, nonatomic) NSString *op_type;//订单类型

@property (strong, nonatomic) NSString *order_id;//订单号 车保姆用

@property (strong, nonatomic) NSString *out_trade_no;//订单id

@property (strong, nonatomic) NSString *car_wash_id;//车场id

@property (strong, nonatomic) NSString *member_id;//用户id

@property (strong, nonatomic) NSString *car_id;//用户车辆id

@property (strong, nonatomic) NSString *pay_type;//支付类型

@property (strong, nonatomic) NSString *pay_money;//支付金额

@property (strong, nonatomic) NSString *is_super;//是否是vip服务

@property (strong, nonatomic) NSString *requiry;//更多需求

@property (strong, nonatomic) NSString *service_addr;//预约服务地址

@property (strong, nonatomic) NSString *service_time;//预约服务时间

@property (strong, nonatomic) NSString *service_mode;//服务方式 上门、到店

@property (strong, nonatomic) NSString *service_id;//服务id

@property (strong, nonatomic) NSString *service_type;//服务类型

@property (strong, nonatomic) NSString *code_id;//优惠券id

@property (strong, nonatomic) NSString *latitude;//服务坐标

@property (strong, nonatomic) NSString *longitude;//服务坐标

@property (strong, nonatomic) NSString *remainder;//支付余额




@end
